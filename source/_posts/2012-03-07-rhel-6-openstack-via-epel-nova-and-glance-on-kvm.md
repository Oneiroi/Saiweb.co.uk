---
title: "RHEL 6 Openstack via EPEL Nova and Glance on KVM"
date: 2012-03-07 16:59
published: true
tags:
- openstack 
---

{% img https://blog.oneiroi.co.uk/openstack-cloud-software-vertical-small.png %}
In this post I will cover getting openstack nova and glance services installed from EPEL and configured to the point where an image can be started, this assumes

1. You have a mysql instance installed and running
2. You have a rabbitmq-server installed and running
3. You have kvm installed and running (libvirt)
4. You have selinux set to permissive, as I will not be covering selinux rules here at this time and I do not think disabled is a valid option ;-)

I will also be carrying out mySQL configuration of glance and nova, for 2011.3 (Diablo), though most if not all of this should be portable to the Essex release

<strong>Install EPEL</strong>

{% highlight bash %}
rpm -Uvh https://download.fedoraproject.org/pub/epel/6/i386/epel-release-6-5.noarch.rpm
{% endhighlight %}

<strong>Install Nova and Glance</strong>

{% highlight bash %}
yum -y install openstack-nova openstack-glance
{% endhighlight %}

yum should take care of all the dependencies here, and install both with a minimal configuration.

<strong>Burning and Rebuilding bridges</strong>
<a id="burning-bridges"></a>

First thing's first KVM is going to install with it's own default bridged networking, this provides NAT.

Which is also noted as being <a href="https://www.cyberciti.biz/faq/linux-kvm-disable-virbr0-nat-interface/">very slow</a> (There is/was an note on the wiki@ linux-kvm.org but I have been unable to locate it at the time of writing)

If you are only setting this up for experimentation you can run with the default networking, simply use vibr0 in your nova.conf instead of br0, and ensure you have ipv4 forwarding enabled.

<u> Burning Bridges </u>

```
virsh net-list
Name                 State      Autostart
-----------------------------------------
default              active     yes 
virsh net-destroy default
Network default destroyed
virsh net-undefine default
Network default has been undefined
service libvirtd restart
```

<u> Building Bridges </u>

The theory here is that this configuration of bridge will give us near native network performance, which if you are setting up for use beyond a throwaway sandbox, you really do not want to start introducing bottlenecks.

Shutdown and disable NetworkManager

```
service NetworkManager stop
chkconfig NetworkManager off
chkconfig network on
```

If you know of a NetworkManager friendly way of doing the following please let me know!

In this scenario br0 becomes your current eth0 

/etc/sysconfig/network-scripts/ifcfg-br0 

```
DEVICE=br0
TYPE=Bridge
BOOTPROTO=static
IPADDR=192.168.99.1
NETMASK=255.255.255.0
GATEWAY=192.168.99.254
ONBOOT=yes
DELAY=0
```

/etc/sysconfig/network-scripts/ifcfg-eth0
```
DEVICE=eth0
BOOTPROTO=none
TYPE=Ethernet
HWADDR=00:11:22:33:44:55
ONBOOT=yes
USERCTL=no
BRIDGE=br0
```

There is plenty more fun to be had here such as bonded interfaces (I myself have a few systems with bonded interfaces as such becoming br0 -> bond0 -> NIC's), but that's for another time.

Note: you may also use brctl for temporary configurations if you are just experimenting.

Caution: my network dropped out immediatly on my testbox, most likely because networkmanager was running, always ensure you can attach to the head of your box when doing network configuration ;-)

Once you have these configurations in place (Ensuring your have replaced the placeholder IP's and MAC address with valid ones) you can now go for a 

```
service network restart
```

All being well you'll lose and re-establish connection, of you'll be attaching a monitor / to kvm over ip.

<strong>Configuring Nova</strong>

First we're going to need a blank database, please ensure you change the placeholder password that follows for something more secure, and amend the host if you are using mySQL on the same host as nova.

{% highlight sql %}
create database nova;
grant all privileges on nova.* to 'nova'@'localhost' identified by 'nova';
{% endhighlight %}

Your /etc/nova.conf should resemble this:

```
--logdir=/var/log/nova
--state_path=/var/lib/nova
--lock_path=/var/lib/nova/tmp
--dhcpbridge=/usr/bin/nova-dhcpbridge
--dhcpbridge_flagfile=/etc/nova/nova.conf
--injected_network_template=/usr/share/nova/interfaces.template
--libvirt_xml_template=/usr/share/nova/libvirt.xml.template
--vpn_client_template=/usr/share/nova/client.ovpn.template
--credentials_template=/usr/share/nova/novarc.template
--network_manager=nova.network.manager.FlatDHCPManager
--iscsi_helper=tgtadm
--sql_connection=mysql://nova:nova@localhost/nova
--rabbit_host=localhost
--glance_api_servers=localhost:9292
--iscsi_ip_prefix=10.0.0.1
--bridge=br0
```

Setup the database and start the relevant nova services

{% highlight bash %}
nova-manage db sync
for i in api network scheduler compute; do service openstack-nova-$i start; done
for i in api network scheduler compute; do chkconfig openstack-nova-$i on; done
{% endhighlight %}

Note: you could also use openstack-nova-db-setup instead of "nova-manage db sync", _but_ it requires mysql-server, which at the time of writing if you have Percona installed will falsely adivse you a need to install mysql-server, Percona need to add: "Provides: mysql-server" to their spec ideally.

Remember this is only a basic setup so a lot of the options are left default such as the network_manager, I will cover their options at a later date.

Onto setting up a basic user (Note: this will be replaced in future posts with keystone)

```
nova-manage user admin saiweb
nova-manage project create saiweb saiweb
nova-manage network create saiweb 192.168.99.1/24 1 256 --bridge=br0
```

Take a moment to run a quick check on your services and network

```
nova-manage service list
Binary           Host                                 Zone             Status     State Updated_At
nova-network     oneiroi                              nova             enabled    :-)   2012-03-07 22:21:10
nova-compute     oneiroi                              nova             enabled    :-)   2012-03-07 22:21:12
nova-scheduler   oneiroi                              nova             enabled    :-)   2012-03-07 22:21:10

nova-manage network list
id      IPv4                IPv6            start address   DNS1            DNS2            VlanID          project         uuid           
1       10.0.0.0/24         None            10.0.0.2        8.8.4.4         None            None            None            7d480f13-47f7-4117-9889-d44f378c3fee

```

Now we need the nova credentials for this user + project.

```
nova-manage project zipfile saiweb saiweb
unzip nova.zip
mv ./{novarc,pk.pem,cert.pem,cacert.pem} ~/.nova/
chmod 700 ~/.nova
chmod 600 ~/.nova/*
rm ./nova.zip
echo ". ~/.nova/novarc" >> ~/.bashrc
source ~/.bashrc
euca-add-keypair nova_key > ~/.nova/nova_key.priv
chmod 600  ~/.nova/nova_key.priv

```


<strong> Configuring Glance </strong>

The only change I made was to make glance use mysql.

{% highlight sql %}
create database glance;
grant all privilges on glance.* to 'glance'@'localhost' identified by 'glance';
{% endhighlight %}

/etc/glance/glance-resgistry.conf
```
...
sql_connection = mysql://glance:glance@localhost/glance
...
```

Once you have made the change, unlike nova all you need do is start glance and it will setup the database.

{% highlight bash %}
for i in api registry; do chkconfig openstack-glance-$i on; service openstack-glance-$i start; done
{% endhighlight %}

Now were going to need an image, I'm using the <a href="https://www.backtrack-linux.org/">BT5-R2</a> .iso as an example, you could use any of the pre-generated images out there, or even build them using <a href="https://fedoraproject.org/wiki/Getting_started_with_OpenStack_Nova#Building_an_Image_With_Oz">oz</a>

```
glance add name="BT5-R2-Gnome-x64" is_public=True container_format=ovf disk_format=raw < ./BT5R2-GNOME-64.iso
```

Once the import has completed it should appear in your glance index

```
glance index
ID               Name                           Disk Format          Container Format     Size          
---------------- ------------------------------ -------------------- -------------------- --------------
1                BT5-R2-Gnome-x64               raw                  ovf                      2762084352
```

And assuming you setup your nova.conf correctly you should now be able to see this image from nova

```
nova image-list
+----+------------------+--------+
| ID |       Name       | Status |
+----+------------------+--------+
| 1  | BT5-R2-Gnome-x64 | ACTIVE |
+----+------------------+--------+
```

You will also have some default instance sizes aka flavours (commands use american spelling flavor).

```
nova-manage flavor list
m1.medium: Memory: 4096MB, VCPUS: 2, Storage: 40GB, FlavorID: 3, Swap: 0MB, RXTX Quota: 0GB, RXTX Cap: 0MB
m1.large: Memory: 8192MB, VCPUS: 4, Storage: 80GB, FlavorID: 4, Swap: 0MB, RXTX Quota: 0GB, RXTX Cap: 0MB
m1.tiny: Memory: 512MB, VCPUS: 1, Storage: 0GB, FlavorID: 1, Swap: 0MB, RXTX Quota: 0GB, RXTX Cap: 0MB
m1.xlarge: Memory: 16384MB, VCPUS: 8, Storage: 160GB, FlavorID: 5, Swap: 0MB, RXTX Quota: 0GB, RXTX Cap: 0MB
m1.small: Memory: 2048MB, VCPUS: 1, Storage: 20GB, FlavorID: 2, Swap: 0MB, RXTX Quota: 0GB, RXTX Cap: 0MB
```

<strong> Booting your first Instance </strong>

```
nova boot --flavor 2 --image 1 "BT5"
+--------------+--------------------------------------+
|   Property   |                Value                 |
+--------------+--------------------------------------+
| accessIPv4   |                                      |
| accessIPv6   |                                      |
| adminPass    | pnFKeVPpbb7bKKy6                     |
| config_drive |                                      |
| created      | 2012-03-07T23:11:59Z                 |
| flavor       | m1.small                             |
| hostId       |                                      |
| id           | 1                                    |
| image        | BT5-R2-Gnome-x64                     |
| key_name     | None                                 |
| metadata     | {}                                   |
| name         | BT5                                  |
| progress     | 0                                    |
| status       | BUILD                                |
| tenant_id    | saiweb                               |
| updated      | 2012-03-07T23:11:59Z                 |
| user_id      | saiweb                               |
| uuid         | fb08be47-2647-4cb2-86d8-867ea0ef4981 |
+--------------+--------------------------------------+
virsh list
 Id Name                 State
----------------------------------
  1 instance-00000001    running

```

And as <a href="https://blueprints.launchpad.net/nova/+spec/iso-boot">iso-boot</a> is not currently complete, this example falls down here, as the instance fails to boot from the .iso file, still you now have

1. Successfully configured nova
2. Sucessfully configured glance
3. Have nova using glance

All you need do is load a valid image into glance and boot using nova, so now I will be cheating a little I will create a blank 10GB qcow2 image, import it into glance
boot it and use virt-manager to attach the .iso and reboot.

```
qemu-img create -f qcow2 blank.qcow2 10G
Formatting 'blank.qcow2', fmt=qcow2 size=10737418240 encryption=off cluster_size=65536
glance add name="blank-10G" is_public=True container_format=bare disk_format=qcow2 < ./blank.qcow2
Added new image with ID: 2
nova boot --flavor 2 --image 2 "BT5"
+--------------+--------------------------------------+
|   Property   |                Value                 |
+--------------+--------------------------------------+
| accessIPv4   |                                      |
| accessIPv6   |                                      |
| adminPass    | H3khDYMwheNNWBV3                     |
| config_drive |                                      |
| created      | 2012-03-07T23:01:50Z                 |
| flavor       | m1.small                             |
| hostId       |                                      |
| id           | 2                                    |
| image        | blank-10G                            |
| key_name     | None                                 |
| metadata     | {}                                   |
| name         | BT5                                  |
| progress     | 0                                    |
| status       | BUILD                                |
| tenant_id    | home                                 |
| updated      | 2012-03-07T23:01:50Z                 |
| user_id      | oneiroi                              |
| uuid         | 05ce2b5d-d03c-442e-99e3-2c079469ec5b |
+--------------+--------------------------------------+
```

Now I cheat I used virt-manager to force off the insance, create and attach an IDE cdrom and set it as the primary boot device.
BT5 boots from the ISO and I can even begin to work through the install to hard drive menus, which as irony would have it prompts me that it needs an 11.5GB partition to install upon :D

I will cover producing proper images in my next openstack post, as the size of the storage volume should not be defined by the image in glance, it should be defined by the falvour being started.
