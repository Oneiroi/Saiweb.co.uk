--- 
wordpress_id: 1160
title: Gluster resolving a split brain in a replicated setup
date: 2011-12-20 12:29:08 +00:00
tags: 
- gluster
- split-brain
- split
- brain
- fix
tags: 
- linux
wordpress_url: https://blog.oneiroi.co.uk/linux/gluster-resolving-a-split-brain-in-a-replicated-setup
---
Initially this took about ~7hours to diagnose and fix, with what I have learned about the inner workings of gluster and the tools I am providing opensource this should cut resolution time down to ~5minutes.

Firs you must meet the following conditions:

<ol>
	<li>You are running gluster >= 3.0 <= 3.2 (May also work on 2.x I have not tested, and will not work with future versions if gluster change their use of xattrs)</li>
	<li>You are running a replicated volume (Again I have not tested distributed volumes, in theory remove, re-add and rebalance will fix these) </li>
	<li>You have a "good" copy of you data (This is essential this assume you have at least 1 brick with a good copy of the file system</li>
</ol>

<strong>Restrain and restore the "bad" brick</strong>

<ol>
	<li>Shutdown all services that are using the mounted filesystem (i.e. httpd / nginx / *ftpd)</li>
	<li>Unmount all the file systems on the node (glusterfs / nfs / etc ...)</li>
	<li>Grab a copy of <a href="https://github.com/Oneiroi/sysadmin/tree/master/gluster">stripxattr.py</a> make sure you READ the README for installation requirements and usage</li>
	<li>Run stripxattr.py against the backing filesystem on the "bad" node ONLY <strong>NOT AGAINST A GLUSTER MOUNT</strong></li>
	<li>From the "good" node, not rsync the data: rsync -gioprtv --progress /path/to/filesystem root@<bad_node>:/path/to</li>
	<li>From the "good" node, trigger an "<a href="https://docs.redhat.com/docs/en-US/Red_Hat_Storage_Software_Appliance/3.2/html/User_Guide/sect-User_Guide-Managing_Volumes-Self_heal.html">auto heal</a>" this will re-populate the xattr data (this must be done on a glusterfs mount not nfs/cifs/etc...)</li>
	<li>Download <a href="https://github.com/Oneiroi/sysadmin/tree/master/gluster">listxattr.py</a> once the self heal has completed see the README file for a "quick and dirty" consistency check</li>
	<li>All being well you have now resolved a split-brain and can return your node to service</li>
</ol>

<strong>Current known gluster issues</strong>

<ol>
	<li>NFS is much (48x in tests) faster for small files i.e. php webapps, but does not support distributed locking meaning: all nodes can write to the same file at the same time, this is what cause our original split brain</li>
</ol>


So what is the resolution int his case? 

Selective use, use glusterfs for filesystems that you need distributed locking, often in large production deploys php files will not change often, in this case NFS is perfect.

If you are still writing php sessions to a file system then <a href="https://blog.oneiroi.co.uk/php/high-availability-joomla-wordpress-load-balance-persistant-php-database-sessions">STOP IT</a> and use a database! (Better yet use memcache).

