--- 
wordpress_id: 1137
layout: post
title: Pivoting ssh reverse tunnel gateway
date: 2011-10-06 14:43:02 +01:00
tags: 
- ssh
- pivot
- gateway
- reverse
- tunnel
- epic
- win
categories: 
- linux
wordpress_url: https://saiweb.co.uk/linux/pivoting-ssh-reverse-tunnel-gateway
comments: true
---
They say necessity is the mother of invention, if this is true then surely the mother of all fuck ups is shoddy customer service, say an isp that will randomly shut down a port because it has high bandwidth usage without asking the customer about it first, and flat out refusing to do anything for 24hrs ...

In one of the worst customer service experiences I've ever had the miss fortune to have been a part of all access was closed to our in office version control systems due to "high usage", now this is a pretty essential service as you might imagine, how then to restore access, when the restrictions are beyond your control? (And I mean EVERY inbound port was dead ...)

Fortunately it would seem outbound SSH was not affected, so after much vocal drawing and re-drawing many times over on the whiteboard I had a cunning plan ...

Using 3 linux devices I would create the following.

1. A device through which using host entries / dns changes the version control would be available whilst not actually running on the box itself.

2. An in house device which would be the device on which the tunnels are created in the first place.

3. The device(s) on which the version control systems reside.

<strong>Gateway device</strong>

On the gateway device sshd_config needs to be updated with:

{% highlight bash %}GatewayPorts yes{% endhighlight %}

And sshd reloaded.

Also if you are using a local firewall (i.e. iptables) you will need to setup the appropriate rules as if the service were running natively on the device

<strong>Pivot Device</strong>

Generate rsa ssh keys and deploy your id_rsa.pub to the gateway device, (update sshd_config to enable RSA Auth if required)

The tunnel.

{% highlight bash %}
ssh <Gateway Device> -l root -g -N -R 0.0.0.0:<Service Port>:10.0.0.1:<Service Port>  -vvv
{% endhighlight %}

Now you only really need to use root if the port you need to gateway is a  privileged port (<1024).

Here 10.0.0.1 is the internal address of the device the connection should "pivot" onto.

Once the tunnel was in place the services could be reached via the gateway device, this was essentially a "poor mans" NAT in a time of need, I really do not suggest this for long term use.


