---
title: "yummy chroots Building chroots with yum on fedora 16"
date: 2012-03-07 16:59
tags:
- linux
---

We're going to build a minimal chroot directory for Fedora 16 using yum and rpm, we are using the ChrootDirectory functionality of Openssh which only came in >= 4.9p1

Credit goes [Here](https://prefetch.net/articles/yumchrootlinux.html) for a great article getting me started on this.

As root:
{% highlight bash %}
mkdir --mode=700 -p /chroot/chrootuser
rpm --root /chroot/chrootuser --initdb
yumdownload --destdir=/var/tmp fedora-release
rpm --root /chroot/chrootuser -ivh --nodeps /var/tmp/fedora-release*rpm
yum --installroot=/chroot/chrootuser -y install bash
yum --installroot=/chroot/chrootuser -y install coreutils
groupadd chrooted
{% endhighlight %}

Edit /etc/ssh/sshd_config

{% highlight bash %}
Match Group chrooted
        ChrootDirectory /chroot/%u
        AllowTcpForwarding no
        X11Forwarding no
        AllowAgentForwarding no
        PermitRootLogin no
        ForceCommand /bin/bash
{% endhighlight %}

And restart the service: systemctl restart sshd.service

Add the user:

{% highlight bash %}
useradd -G chrooted -d /chroot/chrootuser chrootuser
{% endhighlight %}

ssh in as the user and they will be in the jailed directory
