--- 
wordpress_id: 36
title: vsftpd chrooting without the headache, allowing shared directories
date: 2008-04-14 10:35:26 +01:00
tags: 
- vsftpd
- chroot
- sahred
- directories
tags: 
- linux
- security
wordpress_url: https://blog.oneiroi.co.uk/linux/vsftpd-chrooting-without-the-headache-allowing-shared-directories
---
<script type="text/javascript">// <![CDATA[
google_ad_client = "pub-5002016982726982";
/* 468x60, created 09/04/08 */
google_ad_slot = "2202844884";
google_ad_width = 468;
google_ad_height = 60;
// ]]></script>

<script type="text/javascript">// <![CDATA[
src="https://pagead2.googlesyndication.com/pagead/show_ads.js">
// ]]></script>

Chroot'ing a user is always a good idea from a security perspective, but by default it leaves usability lacking.

For example a web development department quite rightly is using individual logins, with each developer able to access each of their site directories, in a non chroot environment.

The downside? the can also browse pretty much the entire server, and each others directories ...

So rather than some extensive and long winded chmoding or directories, we need to chroot them and still preserve access to the shared directories ...

But how?

In this case the shared resource will be /home/shared

First of all for security and chrooting purposes make the following changes to /etc/vsftpd/vsftpd.conf

{% highlight bash %}
anonymous_enable=NO
chroot_local_user=YES
{% endhighlight %}

Now reload vsftpd: /etc/init.d/vsftpd

Create a test user (in this case buzz):

{% highlight bash %}
useradd buzz -d /home/buzz
passwd buzz
{% endhighlight %}

Remove the user's shell access (and subsequently sftp/scp) by editing /etc/pass wd (remove the space between pass wd, wordpress is breaking when I try to post it properly)

replace {% highlight bash %}buzz:x:123:123::/home/buzz:/bin/bash{% endhighlight %} with {% highlight bash %}buzz:x:123:123::/home/buzz:/sbin/nologin{% endhighlight %}

Test the FTP session:
{% highlight bash %}
[root@buzz ~]ftp xxx.xxx.xxx.xxx
Connected to xxx.xxx.xxx.xxx.
220 (vsFTPd 2.0.1)
530 Please login with USER and PASS.
530 Please login with USER and PASS.
KERBEROS_V4 rejected as an authentication type
Name (xxx.xxx.xxx.xxx:buzz): buzz
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp>ls
227 Entering Passive Mode (10,99,1,1,123,97)
150 Here comes the directory listing.
drwxrwxr-- 4 48 48 4096 Mar 27 15:00 www
226 Directory send OK.
ftp> cd /home/shared
550 Failed to change directory.
ftp> cd ./www
550 Failed to change directory.
ftp> quit
221 Goodbye.{% endhighlight %}

In the example above <strong>www</strong> is a symlink to <strong>/home/shared</strong>, as can be seen symlinking does not bypass the chroot settings.

What you need to do is use the "bind" option of the mount command (as root or a sudo'er):

{% highlight bash %}
mkdir /home/buzz/shared
mount --bind /home/shared /home/buzz/shared
{% endhighlight %}

<strong>NOTE: --bind is double dash bind</strong>
<strong>NOTE: to reverse the bind (i.e. if you bind the wrong folder) umount /path/to/binded/folder</strong>


Now re-test the ftp session:

{% highlight bash %}
ftp xxx.xxx.xxx.xxx
Connected to xxx.xxx.xxx.xxx.
220 (vsFTPd 2.0.1)
530 Please login with USER and PASS.
530 Please login with USER and PASS.
KERBEROS_V4 rejected as an authentication type
Name (xxx.xxx.xxx.xxx:buzz): buzz
331 Please specify the password.
Password:
230 Login successful.
Remote system type is UNIX.
Using binary mode to transfer files.
ftp> ls
227 Entering Passive Mode (10,99,1,1,123,97)
150 Here comes the directory listing.
drwxrwxr-- 4 48 48 4096 Mar 27 15:00 www
drwxrwxr-- 4 48 48 4096 Mar 27 15:12 shared
226 Directory send OK.
ftp> cd /home/shared
550 Failed to change directory.
ftp> cd ./www
550 Failed to change directory.
ftp> cd ./shared
250 Directory successfully changed.
ftp> quit
221 Goodbye.
{% endhighlight %}

The user now is in a chroot'ed environment, but can still access the share resources you specify, by binding them.

<strong>FAQ:</strong>

<em>Why remove the users SSH / SCP access?</em>

SCP/SFTP at the time of writing has no logging facility, making it next to impossible to find out who uploaded / overwrote a file in the shared resource at any given time. 

(UPDATE 19/07/2010: <a href="https://blog.oneiroi.co.uk/linux/enable-logging-in-the-sftp-subsystem">https://blog.oneiroi.co.uk/linux/enable-logging-in-the-sftp-subsystem</a>)

By forcing FTP all transactions will appear in the xfer log.

There are mods for SCP out there to allow logging, however you can use them at your own risk I do not recommend using them on a customer facing environment.

<em>Why would I want to "chroot" the user?</em>

Change {% highlight bash %}chroot_local_user=YES{% endhighlight %} to {% highlight bash %}chroot_local_user=NO{% endhighlight %}and reload vsftpd, now login to ftp hand try to get out of your home directory,

you will notice you can pretty much browse the entire file system, and depending on the setup write and delete files owned by anyone in the same group as that user.

By chroot'ing the user you are reducing the potential for things to go wrong on your server, as you add more and more users it reduces the "sys admin" time incurred due to user error.

NOTE: Remember to put {% highlight bash %}chroot_local_user=YES{% endhighlight %}back and reload vsftpd!

<strong>Disclaimer:</strong>

You break it, it's not my fault!

If you run into problems just leave a comment.

<script type="text/javascript">// <![CDATA[
google_ad_client = "pub-5002016982726982";
/* 468x60, created 09/04/08 */
google_ad_slot = "2202844884";
google_ad_width = 468;
google_ad_height = 60;
// ]]></script>

<script type="text/javascript">// <![CDATA[
src="https://pagead2.googlesyndication.com/pagead/show_ads.js">
// ]]></script>
