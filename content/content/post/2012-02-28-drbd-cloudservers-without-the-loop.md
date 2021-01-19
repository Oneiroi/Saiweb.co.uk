---
date: "2012-02-28T00:00:00Z"
published: false
tags:
- drbd
title: DRBD at CloudServers without the loop device - Operation FAILED
---

<u>DRBD at CloudServers</u>

This is a short guide on getting DRBD working @ Rackspace CloudServers
Please note I will be resizing the root partition on the cloud server, this is not for the
squeemish! 

I highly recomend you only attempt this on new builds or throw away virtual machines, this only works for ext3 filesystems I have not tested nor do I know the implications of trying this on ext4!

<u>rescue mode</u>

In this first step we need to place the cloudserver in Rescue mode, so.

1. log into your rackspacecloud portal.
2. Hosting
3. Cloud Servers
4. Click server
5. Click Rescue

Read the prompt:
```
    Placing your Cloud Server into rescue mode will allow you to debug system issues that are preventing it from booting to a usable state.

    The rescue boot will use your current server IP and OS distro. Your original server devices will be accessible within the rescue mode as /dev/sda1 (root) and /dev/sda2 (swap). A temporary root password will be flashed when the image has booted. Note: the SSH server key will be different on the rescue image than your server.

    Rescue mode is limited to 90 minutes, after which the rescue image is destroyed and the server will attempt to reboot. You may end the rescue mode at any time.
```

Note: In rescue mode /dev/xvda becomes /dev/sda

You can shose at this point to connect via SSH or via the Web Console, I will be opting for SSH.

Note: the host key is generated at startup, your ssh client will alert about a miss matching host key if you have allready connected to this host before.
Or as a one off:
```
    ssh -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no user@host
```    
Do not use this reguarly, unless you enjoy the prospect of being an easy m.i.t.m target.

Now we need to record some information, however the text above is missleading /dev/sda does not exist as a device, this has been confirmed by Rackspace as information from the previous infrastructure (Slicehost I'd assume), the actual device is: /dev/xvdb (1 Data, 2 Swap) (And with any luck they will correct this soon within the system)

Now we need to do some information collecting so for now just mount /dev/xvdb1 onto /media:
```
    mount /dev/xvdb1 /media
    root@RESCUE ~]# df -h && df && df -B 4k && fdisk -l && fdisk -s /dev/xvdb1
Filesystem            Size  Used Avail Use% Mounted on
/dev/xvda1            9.4G  894M  8.1G  10% /
tmpfs                 120M     0  120M   0% /dev/shm
/dev/xvdb1             75G  2.1G   69G   3% /media
Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/xvda1             9804120    914776   8391324  10% /
tmpfs                   122228         0    122228   0% /dev/shm
/dev/xvdb1            78440392   2157668  72298188   3% /media
Filesystem           4K-blocks      Used Available Use% Mounted on
/dev/xvda1             2451030    228694   2097831  10% /
tmpfs                    30557         0     30557   0% /dev/shm
/dev/xvdb1            19610098    539417  18074547   3% /media

Disk /dev/xvdb: 81.6 GB, 81604378624 bytes
255 heads, 63 sectors/track, 9921 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/xvdb1   *           1        9922    79690752   83  Linux

Disk /dev/xvda: 10.2 GB, 10200547328 bytes
255 heads, 63 sectors/track, 1240 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x0005781c

    Device Boot      Start         End      Blocks   Id  System
/dev/xvda1   *           1        1241     9960448   83  Linux

Disk /dev/xvdd: 536 MB, 536870912 bytes
255 heads, 63 sectors/track, 65 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/xvdd1               1          65      522112   82  Linux swap / Solaris

Disk /dev/xvdc: 536 MB, 536870912 bytes
255 heads, 63 sectors/track, 65 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/xvdc1               1          65      522112   82  Linux swap / Solaris
79690752
```

Note: You _could_ in get all this information before dropping into rescue mode if you really wanted to.

<u>Preparation</u>


First a fsck we want it to report a clean FS without attempting any changes so we run this with the -n option, go grab a coffee this will take a while:
```
    umount /media
    fsck -n /dev/xvdb1 
    fsck from util-linux-ng 2.17.2
    e2fsck 1.41.12 (17-May-2010)
    /: clean, 62421/9961472 files, 852007/19922688 blocks
```
Great we have a clean FS (note it will rpoert erros if the fs is still mounted!) we need to remove the journal, which essentially will turn a ext3 FS into ext2:
```
    tune2fs -O ^has_journal /dev/xvdb1
    tune2fs 1.41.12 (17-May-2010)
```
Force a filesystem check with e2fsck -f:
```
    e2fsck 1.41.12 (17-May-2010)
    Pass 1: Checking inodes, blocks, and sizes
    Pass 2: Checking directory structure
    Pass 3: Checking directory connectivity
    Pass 4: Checking reference counts
    Pass 5: Checking group summary information
    /: 62421/9961472 files (0.6% non-contiguous), 819205/19922688 blocks
```
Now we can resize the filesystem from the recon above we know that we are presentl using 2.1GB / 75GB so in this case I will "shave" 20GB off the top to become the DRBD volume
```
    resize2fs 1.41.12 (17-May-2010)
    Resizing the filesystem on /dev/xvdb1 to 14080000 (4k) blocks.
    The filesystem on /dev/xvdb1 is now 14080000 blocks long. 
```
Now we need to delete and recreate our partitions
```
fdisk /dev/xvdb

WARNING: DOS-compatible mode is deprecated. It's strongly recommended to
         switch off the mode (command 'c') and change display units to
         sectors (command 'u').

Command (m for help): p

Disk /dev/xvdb: 81.6 GB, 81604378624 bytes
255 heads, 63 sectors/track, 9921 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

    Device Boot      Start         End      Blocks   Id  System
/dev/xvdb1   *           1        9922    79690752   83  Linux

Command (m for help): d  
Selected partition 1

Partition number (1-4): 1
First cylinder (1-9921, default 1): 1
Last cylinder, +cylinders or +size{K,M,G} (1-9921, default 9921): +59136000K

Command (m for help): a
Partition number (1-4): 1

Command (m for help): w
The partition table has been altered!

Calling ioctl() to re-read partition table.
Syncing disks.
```

Wait how did I get 59136000K for the last cylinder? well we take 14080000 from resize2fs multiply by 4 and again by 1.05, why?

1. 4K blocksize
2. 1.05 gives us a 5% saftey buffer
3. final figure 59136000K
4. the option a is used to set the bootable flag back onto parition 1

Now we check the filesystem
```
    fsck from util-linux-ng 2.17.2
    e2fsck 1.41.12 (17-May-2010)
    fsck.ext2: Superblock invalid, trying backup blocks...
    fsck.ext2: Bad magic number in super-block while trying to open /dev/xvdb1

    The superblock could not be read or does not describe a correct ext2
    filesystem.  If the device is valid and it really contains an ext2
    filesystem (and not swap or ufs or something else), then the superblock
    is corrupt, and you might try running e2fsck with an alternate superblock:
    e2fsck -b 8193 <device>
```
Awww crap ... right lets find out where that superblock is we run mke2fs with the -n flag this is a dry run, it will not write filesystem changes::

```    
     mke2fs -n /dev/xvdb1 
mke2fs 1.41.12 (17-May-2010)
Filesystem label=
OS type: Linux
Block size=4096 (log=2)
Fragment size=4096 (log=2)
Stride=0 blocks, Stripe width=0 blocks
3702784 inodes, 14785816 blocks
739290 blocks (5.00%) reserved for the super user
First data block=0
Maximum filesystem blocks=4294967296
452 block groups
32768 blocks per group, 32768 fragments per group
8192 inodes per group
Superblock backups stored on blocks: 
    32768, 98304, 163840, 229376, 294912, 819200, 884736, 1605632, 2654208, 
    4096000, 7962624, 11239424
```

Ok NONE of these superblock worked for me ... BLAM trashed VM, see why I suggested a throw away!

I am frankly stumped on this one ... I've posted it anyway as some of the information may be useful.

<u>Sources</u>

1. https://rackerhacker.com/2011/02/13/dual-primary-drbd-with-ocfs2/
2. https://www.howtoforge.com/linux_resizing_ext3_partitions i
3. https://www.cyberciti.biz/faq/recover-bad-superblock-from-corrupted-partition/
