provider "openstack" {
    tenant_name = "${var.tenant_name}"
    auth_url  = "${var.auth_url}"
}

output "minion-ip" {
   value = "${join(" ", openstack_compute_instance_v2.salt-minion.*.access_ip_v4)}"
}

resource "openstack_compute_floatingip_v2" "fip" {
    count = "${var.minion_count}"
    pool = "floating"
  }

resource "openstack_compute_instance_v2" "salt-minion" {
    region = ""
    count = "${var.minion_count}" 
    name = "${var.name}${count.index}"
    image_name = "${var.image_name}"
    flavor_name = "${var.flavor_name_master}"
    key_pair = "${var.key_pair}"
    security_groups = ["default"]
    floating_ip = "${element(openstack_compute_floatingip_v2.fip.*.address, count.index)}"
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
        "zypper --non-interactive --no-gpg-checks in salt-minion",
        "echo master: ${var.salt_master} > /etc/salt/minion.d/minion.conf",
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
