---
title: "Openstack - Deploying Windows 8"
date: 2012-12-18 19:36
tags:
- openstack
- windows8
- windows
- kvm
- virtio
---

Despite a never ending well of hate for windows, sometimes I have to work with it.

In this case I needed to create a glance image that could be deployed to a openstack cluster ... and that is where the fun stops.

First things first, if you can do a clean install (if you paid the extra £20 and actually received your dvd media that is!) do so, the upgrade process from Windows 7 took the best part of 2 days to complete.

Secondly to create your glance image you're going to have to do the installation on the same type of hypervisor that you have openstack running upon, in this case I will be covering deployment of Windows 8 onto Linux KVM with virtio drivers.

<h2>The kludge</h2>

You can not start the instance using virtio for the hard disk, it simply puts itself into a never ending recovery mode, instead set the bus type to SATA or IDE.

Attach a second drive that uses virtio bus, why you may ask? Windows 8 will now boot and in turn have a device attached which it can not recognize.

Before booting you will also need to attach [this iso](https://alt.fedoraproject.org/pub/alt/virtio-win/latest/images/bin/) as a cdrom, at the time of writing you can use the Win7 drivers for Windows 8. (iso version 0.1-30)

<h2>Square peg, round hole == Bigger hammer</h2>

I opted to first install all the drivers by opening up the virtual cdrom, navigating to the Win7 folder and: right click -> install on all the "Setup Information" files.

My "fun" did not end here however ... because it would appear the attached virtio device was not formatted Windows8 decided to ignore it.

In this case the device manager needs to be launched to resolve the issue a laborious task in itelf.

1. Open desktop, and click the windows explorer tray icon.
2. Right click "Computer" and click properties.
3. Click "Device Manager".
4. Expand the "Disk Drives" section, (if you did not install the drivers and reboot, you may be prompted to install the device, or it will show up as an unknown device instead of a disk drive)
5. Right click properties on the "RedHat VirtIO SCSI Device"
6. Click the volumes tab and click populate.
7. Close all windows leaving the Explorer window open.
8. Right click computer, select Manage.
9. Select disk management, partition and format the Virtio device as you would any other hard drive.
10. You should now have a new volume, this is running with the virtio drivers.
11. Shutdown windows.
12. Reconfigure the KVM instance, remove the VirtIO disk, change the primary disk bus to VirtIO
13. Start windows, and wait ... and wait ...
14. Once the start menu has booted you will begin to notice performance picks up after a while, I assume this is due to background tasks running.
15. Run any updates that may be outstanding and shutdown the instance. I would also advise [configuring remove desktop](https://www.guidingtech.com/13469/hot-to-enable-remote-desktop-in-windows-8/)
16. Convert to qcow2 (if you want), and import into glance as you would any other image.
17. Create or modify a [security group](https://docs.openstack.org/essex/openstack-compute/starter/content/Security_Overview-d1e2505.html) if you have opted to allow Remote Desktop.

And boot the image as normal, ensuring that the selected "flavor" has enough disk space to start the instance.

As for meta data injection, for say account setup I have no idea at this time, please feel free to post in the comment or email me with methods for doing so.

<h2>Credits</h2>

[this blog](https://cloud101.eu/blog/2012/05/31/how-to-create-a-windows-2008-r2-image-for-openstack-with-virtio-support/) for noting the 'dirty hack' workaround in Windows 8 R2

and [James P](https://twitter.com/parters) for having way more patience with windows than I will ever have.
 
