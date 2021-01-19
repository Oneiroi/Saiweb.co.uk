---
date: "2010-07-19T17:48:05Z"
tags:
- linux
title: Enable logging in the SFTP subsystem
wordpress_id: 897
wordpress_url: https://blog.oneiroi.co.uk/linux/enable-logging-in-the-sftp-subsystem
---
This is something I have wanted to get working for some time now, and thanks to James P for passing me a note that as of OpenSSH 4.4 you can infact add command line args for the Subsystem configuration, which when combined with the  (I assume new) logging functionality of the sftp-service allows you to finally log what is occuring during an sftp session.

Note: Requires OpenSSH >= 4.4

Replace the susbsystem line in your /etc/ssh/sshd_config with

{{< highlight bash >}}
Subsystem	sftp	/usr/libexec/openssh/sftp-server -f LOCAL5 -l INFO
{{< / highlight >}}

Add the following to /etc/syslog.conf

{{< highlight bash >}}
#sftp logging
local5.*						/var/log/sftpd.log
{{< / highlight >}}

Restart the sshd and syslog services, try an sftp upload and review the logs @ /var/log/sftpd.log
