---
date: "2011-08-16T11:35:54Z"
tags:
- linux
- boxgrinder
- cloud
title: Boxgrinder - setting up a simple CentOS LAMP stack, and deploying it to KVM
wordpress_id: 1054
wordpress_url: https://blog.oneiroi.co.uk/linux/boxgrinder-setting-up-a-simple-centos-lamp-stack-and-deploying-it-to-kvm
---
<a href="https://blog.oneiroi.co.uk/uploads/2011/08/boxgrinder_logo_450px.gif"><img class="aligncenter size-full wp-image-1093" title="boxgrinder_logo_450px" src="https://blog.oneiroi.co.uk/uploads/2011/08/boxgrinder_logo_450px.gif" alt="" width="450" height="110" /></a> If you haven't tried <a href="https://boxgrinder.org">boxgrinder</a> then you are missing out, it makes it extremely easy to script the generation of a virtual machine for output to Rackspace (<a href="https://blog.oneiroi.co.uk/linux/boxgrinder-setting-up-a-simple-centos-lamp-stack-and-deploying-it-to-kvm/comment-page-1#comment-49065">Well not yet</a>), ec2, vmware, virtualbox, KVM etc.

In this post I will cover the basic generation of a LAMP (Linux Apache MySQL PHP) stack CentOS appliance, nothing to complicated I assure you, and no magic like auto deployment spin up etc ... that's for later ... no skipping ahead!

First of all you're going to need <a href="https://boxgrinder.org">boxgrinder</a> I recommend downloading the <a href="https://boxgrinder.org/download/boxgrinder-build-meta-appliance/">Meta appliance</a>, as it has all the tools you need already.

Now I am covering the following.
<ol>
	<li>basic use of boxgrinder-build on the meta appliance</li>
	<li>creation of centos lampstack basic</li>
	<li>deploying the image to KVM</li>
</ol>
I'm going to have to assume that you are capable of downloading and starting up the meta appliance yourself, and focus more on the stack setup.

<strong>Grinding your VM</strong>

Ok so you are going to need a YAML file defining the CentOS lamp stack, save this on your meta appliance as <a href="https://github.com/Oneiroi/boxgrinder-appliances/blob/master/CentOS/CentOS-lamp.appl">CentOS-lamp.yaml</a>

{{< highlight bash >}}
name: CentOS-lamp
summary: Generic CentOS 5.6 LAMP stack, with some apache &amp; php tuning
version: 1
release: 0
hardware:
cpus: 2
memory: 1024
partitions:
"/":
size: 5
"/var/www":
size: 15
os:
name: centos
version: 5
password: changeme
{{< / highlight >}}

On your <a href="https://boxgrinder.org/download/boxgrinder-build-meta-appliance/">Meta appliance</a> run.

{{< highlight bash >}}
boxgrinder-build -d CentOS-lamp.appl
{{< / highlight >}}

This process will take a while, so go and get a coffee, this will produce ./build/appliances/x86_64/centos/5/CentOS-lamp/CentOS-lamp-sda.raw once complete, if you run into issues the -d flag is "debug" paste your log output int the comments and I will do my best to diagnose and fix your issue.

<strong>Deploying to KVM</strong>

boxgrinder has SFTP support for pushing to remote servers, you can use this if you like to automate the "push" of the image to your KVM server, at the moment automated deployment to KVM is not support but may be <a href="https://issues.jboss.org/browse/BGBUILD-211">coming soon</a>.

Assuming you have placed you image in /var/lib/libvirt/images/

{{< highlight bash >}}
virt-install -n "Saiweb - CentOS-lamp Demo" -r 1024 --arch=x86_64 --vcpus=1 --os-type=linux --os-variant=rhel5.4 --disk path=/var/lib/libvirt/images/CentOS-lamp.raw,size=20,cache=none,device=disk --accelerate --network=bridge:br0 --vnc --import
{{< / highlight >}}

<strong>Post startup</strong>

this is a VERY basic setup I have not covered any of the post install options in this post (but I will in future posts), so.

{{< highlight bash >}}
chkconfig httpd on &amp;&amp; service httpd start
chkconfig mysqld on &amp;&amp; service mysqld start
{{< / highlight >}}

This will set your services to automatically start at startup, and start them.
