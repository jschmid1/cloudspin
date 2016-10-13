provider "openstack" {
    tenant_name = "${var.tenant_name}"
    auth_url  = "${var.auth_url}"
}

output "master-ip" {
   value = "${join(" ", openstack_compute_instance_v2.salt-master.*.access_ip_v4)}"
}

output "minion-ip" {
   value = "${join(" ", openstack_compute_instance_v2.salt-minion.*.access_ip_v4)}"
}

resource "openstack_compute_floatingip_v2" "minion-fip" {
    count = "${var.minion_count}"
    pool = "floating"
  }

resource "openstack_compute_floatingip_v2" "master-fip" {
    count = "1"
    pool = "floating"
  }
resource "openstack_compute_instance_v2" "salt-master" {
    region = ""
    count = "1" 
    name = "salt-master"
    image_name = "${var.image_name}"
    flavor_name = "${var.flavor_name_master}"
    key_pair = "${var.key_pair}"
    security_groups = ["default"]
    floating_ip = "${element(openstack_compute_floatingip_v2.master-fip.*.address, count.index)}"
    metadata {
        demo = "metadata"
    }
    network {
        name = "fixed"
    }
    provisioner "remote-exec" {
        inline = [
        "zypper --quiet ar ${var.saltstack_repo} saltstack",
        "zypper ref",
        "zypper --non-interactive --no-gpg-checks in salt-master",
        "zypper --non-interactive --no-gpg-checks in salt-minion",
        "systemctl enable salt-master.service",
        "systemctl start salt-master.service"
        ]
        connection {
            type = "ssh"
            user = "${var.login_user}"
            password = "${var.login_password}"
        }   
    }
}
resource "openstack_compute_instance_v2" "salt-minion" {
    region = ""
    count = "${var.minion_count}" 
    name = "${var.name}${count.index}"
    image_name = "${var.image_name}"
    flavor_name = "${var.flavor_name_minion}"
    key_pair = "${var.key_pair}"
    security_groups = ["default"]
    floating_ip = "${element(openstack_compute_floatingip_v2.minion-fip.*.address, count.index)}"
    metadata {
        demo = "metadata"
    }
    network {
        name = "fixed"
    }
    provisioner "remote-exec" {
        inline = [
        "zypper --quiet ar ${var.saltstack_repo} saltstack",
        "zypper ref",
        "zypper --quiet --non-interactive --no-gpg-checks in salt-minion",
        "echo \"master: ${join(" ", openstack_compute_instance_v2.salt-master.*.network.0.fixed_ip_v4)} \" > /etc/salt/minion.d/minion.conf",
        "systemctl enable salt-minion.service",
        "systemctl start salt-minion.service"
        ]
        connection {
            type = "ssh"
            user = "${var.login_user}"
            password = "${var.login_password}"
        }   
    }
}

