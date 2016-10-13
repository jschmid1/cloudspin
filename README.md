# Cloudspin 

* Spawns an arbitrary ammount of vms on any openstack instance.
* Installs/preconfigures Salt on the minion and the master.


## Installation

Clone and execute cloudspin.

## Usage

Source your openrc file in order to set the needed env vars.

Or set the following vars via a ~/.cloudspinrc

```bash
OS_USERNAME
OS_PASSWORD
OS_TENANT_NAME
AUTH_URL
KEY_PAIR
```

Template files will reside in $HOME/.cloudspin/


Spin up a customizable cluster with Salt preinstalled.

>Usage:
>./cloudspin [arguments] 
>
>        --salt-master <> Provide IP/Hostname if you already have a salt-master 
>
>        --minion-count <> The number of minions you want to spawn : defaults to 3 
>
>        --flavor-name-master <> Openstack Image Flavor for the master : defaults to d2.small 
>
>        --flavor-name-minion <> Openstack Image Flavor for the minion : defaults to d2.small 
>
>        --image-name <> OpenStack Image Name : defaults to SP1 
>
>        --list-os <> Lists all the available options 
>
>        --login-user <> Specify the login user for the initial ssh connection: defaults to root 
>
>        --login-password <> Specify the login password for the initial ssh connection: defaults to linux 
>
>        --auth-url <> Specify the auth-url for the horizon dashboard : defaults to cloud.suse.de 
>
>        --tenant-name <> Tenant name for the horizon dashboard: defaults to ses : 
>
>        --key-pair <> The keypair you want to use to deploy the vms : defaults to ci-jenkins 
>
>        --node-name <> Name your machines: defaults to ses-devnode and salt-master 
>
>        --destroy <> Destroy all machines 
>
>        --output-ips <> Display IPs of your running VMs 
>
>        --help <> Displays this message


If you already have a Salt-Master then you can specify its IP/Hostname by --salt-master HOST/IP 

The IP will be added to /etc/minion.d/minion on each node.

You are limited to two sets of machines. Please keep in mind that we do not have limitless ressources.

There is a --destroy switch. Use it.

See --help for more options.

## Contributing

1. Fork it!
2. Create your feature branch: `git checkout -b my-new-feature`
3. Commit your changes: `git commit -am 'Add some feature'`
4. Push to the branch: `git push origin my-new-feature`
5. Submit a pull request :D

## License

See LICENSE
