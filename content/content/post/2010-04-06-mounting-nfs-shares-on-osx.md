---
date: "2010-04-06T15:18:22Z"
tags:
- mac
title: Mounting NFS shares on OSX
wordpress_id: 844
wordpress_url: https://blog.oneiroi.co.uk/mac/mounting-nfs-shares-on-osx
---
Having little time to update my blog, I've been updating a wiki I keep with various tidbits, so I thought I might as well share a few, they will be appearing on here over the next few days.

First off you will want to open the "Terminal" application, not so much a play on words it is really called Terminal.

Applications -> Utilities -> Terminal

{{< highlight bash >}}
showmount -e aaa.bbb.ccc.ddd
{{< / highlight >}}

Where aaa.bbb.ccc.ddd is the IP or FQDN of your NFS server, this command will show a list of mountable exports on the device.

{{< highlight bash >}}
sudo mount -t ntfs aaa.bbb.ccc.ddd:/exported/path ~/Desktop/nfs_folder
{{< / highlight >}}

If you look on your desktop you will now see that the folder icon has changed to an aliased drive icon <a href="https://blog.oneiroi.co.uk/uploads/2010/04/2010-04-06_1615.png"><img src="https://blog.oneiroi.co.uk/uploads/2010/04/2010-04-06_1615.png" alt="alias drive icon" title="mac ALIAS drive" width="35" height="40" class="alignnone size-full wp-image-845" /></a>

<strong>
NOTE:</strong> These changes will not persist through a reboot, I have not yet found a way of doing this short of some apple / automator script to remount the drives on startup.
