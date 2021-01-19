---
date: "2013-11-18T00:00:00Z"
tags:
- selinux
- amazon
- aws
- ec2
- ami
- linux
- security
title: SELinux on Amazon AMI Linux
---

This took a little digging into; in order to get SELinux to function on Amazon AMI Linux you must carry out the following steps.


`yum -y install policycoreutils selinux-policy-targeted`

Now edit /etc/grub.conf and ensure your kernel line looks something like the following:


```
title Amazon Linux 2013.XX (3.XX.XX-XX.XX.amzn1.x86_64)
root (hd0)
kernel /boot/vmlinuz-3.XX.XX-XX.XX.amzn1.x86_64 root=LABEL=/ console=hvc0 selinux=1 security=selinux enforcing=1 LANG=en_US.UTF-8 KEYTABLE=us
initrd /boot/initramfs-3.XX.XX-XX.XX.amzn1.x86_64.img
```

Note the addition of "selinux=1 security=selinux enforcing=1"

Now: `touch /.autorelabel`

And: `/sbin/new-kernel-pkg --package kernel --mkinitrd --make-default --dracut --depmod --install 3.XX.XX-XX.XX.amzn1.x86_64 || exit $?`

Replacing the XX portions with your running kernel or you can use substitute in the `uname -r` output; this one liner script was obtained from: `rpm -q --scripts kernel` and is required to rebuild the initrd image such that the selinux settings can take effect.

Alternatively if there are updates outstanding a `yum -y update` will acheive the same thing (selinux settings should persist); after all of this you can now `reboot` and wait.

This will take a while to start back up as an selinux relabel is running (this is what the `touch /.autorelabel` achieves.

All being well selinux should now be running enforcing in targeted mode; if not check your /etc/selinux/config file.
