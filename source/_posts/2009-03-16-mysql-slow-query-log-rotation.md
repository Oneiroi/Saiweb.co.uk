--- 
wordpress_id: 613
title: mySQL slow query log rotation
date: 2009-03-16 11:50:11 +00:00
tags: 
- mysql
- slow query
- log rotation
tags: 
- mysql
wordpress_url: https://blog.oneiroi.co.uk/mysql/mysql-slow-query-log-rotation
---
One of the issues facing log rotation in mySQL is that mySQL doesn't seem to have the ability to perform a "reload".

Meaning standard methods of rotating logs using logrotate leave mySQL logging an error in the syslog saying that the log file could not be found, and refusing to to any logging until the server is restarted, not fun if like me you manage high availability solutions and restarting a service is never the best option.

As such I have written this log rotate script, this does however make some assumptions.

<ol>
	<li>Your mysql user is "mysql"</li>
	<li>Your mysql slow query log is /var/log/mysql-slow.log</li>
</ol>

The script is written to perform the following actions:

<ol>
	<li>Rotate weekly</li>
	<li>Retain 3 rotations (3 files + live log)</li>
	<li>Compress on rotate (gzip)</li>
	<li>Create new logfile with 660 permissions chowned to mysql:mysql</li>
	<li>Run: mysqladmin flush-logs</li>
</ol>

<strong>Please be aware that the flush logs command will also rotate any binary logging currently in place, please ensure this will not adversely affect your deployment prior to use </strong>

<strong>Please ensure you carry out your own testing prior to deploying this script into a live environment.</strong>

<a href="https://svn.blog.oneiroi.co.uk/branches/linux-the-sysadmin-script/branches/logrotate.d/mysql">https://svn.blog.oneiroi.co.uk/branches/linux-the-sysadmin-script/branches/logrotate.d/mysql</a>

{% highlight bash %}
#
# mySQL slow log rotation script by D.Busby
# place this script in /etc/logrotate.d/ or your appropriate logrotate dir.
# https://creativecommons.org/licenses/by-sa/2.0/uk/ CC BY-SA
#
# NOTE: if you are reliant on binlogs i.e. for replication, 'flush logs' closes the current binlog and moves to the next itteration of log files
# You should test this does not cause an issue with your deployment before using this script
# 
/var/log/mysql-slow.log {
	weekly
	rotate 3
	compress
	missingok
	notifempty
	sharedscripts
	create 660 mysql mysql
	postrotate
		/usr/bin/mysqladmin flush-logs
	endscript
}
{% endhighlight %}
