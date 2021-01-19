---
date: "2012-07-02T00:00:00Z"
tags:
- linux
- kvm
- virt-resize
- RHEL
- LVM
title: KVM Linux - expanding a guest LVM file system using virt-resize
---

In this post I will cover growing the file system of a guest instance when running KVM linux.

For this you will require the following Packages:

1. libguestfs-tools
2. guestfish

<strong>Shutdown the instance</strong>

In order to grow the disk we must virsh shutdown the instance, this can be achieved using a simple `virsh shutdown instance_name`, try to avoid running a virsh destroy as we want a clean filesystem to avoid issues in the resize.

<strong> Get current image information</strong>

After the image has shutdown we can now go ahead and get some information on the disk configuration:

```
virt-filesystems --long --parts --blkdevs -h -a centos_centos6.qcow2

Name       Type       Size  Parent
/dev/sda1  partition  200M  /dev/sda
/dev/sda2  partition  9.8G  /dev/sda
/dev/sda   device     10G   -

```

As can be seen here there is a single 10GB virtual disk residing on /dev/sda

<strong>virt-rezise</strong>

We must then create a destination disk image, of the required total size

```
qemu-img create -f qcow2 outfile 150G
```

I have opted to use the --expand flag, if this is not specified a new partition is created to ocupy the free space, refer to ```man virt-resize``` for more advanced options such as splitting the freespace to grow existing partitions (i.e. expand the boot partition +100M)

```
virt-resize --expand /dev/sda2 original.qcow2 outfile.qcow2
```

Go make a coffee as this step will take a while to complete.

<strong>Finishing up</strong>

If you were to start the instance back up now using outfile.qcow2 as the disk image, you would find the OS reports the original disk size, this is due to the LVM configuration which we can not change "online" (unless of course you are changing a partition that can be unmounted, not the case here).

We will use guestfish to complete the process.

```
guestfish --rw -a outfile.qcow2

Welcome to guestfish, the libguestfs filesystem interactive shell for
editing virtual machine filesystems.

Type: 'help' for help on commands
      'man' to read the manual
      'quit' to quit the shell

><fs> run
><fs> list-filesystems
/dev/vda1: ext4
/dev/VolGroup00/LogVol00: ext4
/dev/VolGroup00/LogVol01: swap
><fs> lvresize-free /dev/VolGroup00/LogVol00 100
><fs> resize2fs /dev/VolGroup00/LogVol00
><fs> e2fsck-f /dev/VolGroup00/LogVol00
><fs> exit

virt-df -h outfile.qcow2
Filesystem                                Size       Used  Available  Use%
centos_el6_php53_lap:/dev/sda1            194M        52M       132M   27%
centos_el6_php53_lap:/dev/VolGroup00/LogVol00
                                          146G       1.1G       137G    1%

```

Your lvm configuration may differ change the above according to the output from list-filesystems.

Note: I run e2fsck-f as a precaution, this is not a required step though I highly recomend doing this.

Now finally swap out the images (or update the libvirt xml file, it's up to you)

```
mv ./original.qcow2 ./original.bak
mv ./outfile.qcow2 ./original.qcow2
virsh start instance_name
```

If you instance starts successfully and all your data is intact the original.bak can be safely removed.

