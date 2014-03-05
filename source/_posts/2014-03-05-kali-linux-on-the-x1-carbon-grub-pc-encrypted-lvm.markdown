---
layout: post
title: "Kali linux on the X1 Carbon grub-pc encrypted LVM FINALLY!"
date: 2014-03-05 11:02
comments: true
categories:
- linux
- grub-pc
- lvm
- ecryption 
---

So finally I have Kali linux 1.0.6. installed as the main OS on my Lenovo X1 Carbon, this was not a trivial matter to say the least.

First of all the installation routine fails trying to install grub-pc; this is due to the network configuration step of the routine creating a blank /etc/resolv.conf

So right after network configuration has completed inspect your /etc/resolv.conf and if it is blank as mine was:

```
echo "nameserver 8.8.8.8" >> /etc/resolv.conf
```

Ensuring this is done BEFORE it reaches the grub installation step; this will now complete as expected.


Next up post reboot the encrypted LVM fails to mount, citing it was unable to find kali-root


```
Loading, please wait...
    Volume group "kali" not found
    Skipping volume group kali
Unable to find LVM volume kali/root
```

[Help is however at hand](http://mstramgram.com/kali-encrypted-lvm-install-fails-to-boot/), boot back into the live distro forensics mode, and what follows is my somewhat condensed and modified procedure

```
blkid /dev/sda5
/dev/sda5: UUID="XXXXXX" TYPE="crypto_luks"
cryptsetup /dev/sda5 luksOpen sda1_crypt
vgchange -ay kali
mkdir -p /mnt/root
mount /dev/mapper/kali-root /mnt/root
cd /mnt/root
mount -t proc proc proc
mount -t sysfs sys sys
mount -o bind /dev dev
mount /deva/sda1 boot
chroot /mnt/root
echo "sda1_crypt UUID=XXXXXX non luks" > /etc/crypttab
update-initramfs -u
exit
reboot
```


As for UEFI / EFI ? Don't even get me started there nothing I have spent long evening hours looking into works for kali, not using the fedora shim nothing at this time; I'm very annoyed at this and will post again once I arrive to a resolution.

In the interim [CaptTofu](http://patg.net/docker/2014/03/03/ansible.html) release some interesting material on leveraging [Docker](http://docker.io) to test PXC deploys, he's even go so far to produce some Ansible playbooks for the deployment process; I've been helping to work in some respect on the Ansible side and I can see a lot of potential in docker aswell as a lot of issues (it is a very young project it reminds me a lot of OpenStack hack in the diablo RC days), I encourage you to check this out.

