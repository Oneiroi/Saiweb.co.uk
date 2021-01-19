--- 
wordpress_id: 681
layout: post
title: mySQL and the phantom disk space
date: 2009-07-03 09:04:35 +01:00
tags: []

categories: 
- mysql
wordpress_url: https://blog.oneiroi.co.uk/mysql/mysql-and-the-phantom-disk-space
comments: true
---
Title for a cheesy sysadmin novel I know.

But over the last month or so I have been plagued by a mySQL server that was reporting a full root partition, when it wasn't full ...

Causing me some <a href="https://twitter.com/Saiweb/status/2451146916">headaches</a> 

Allow me to explain:

{% highlight bash %}
df -h
Filesystem                     Size    Used    Avail   Use%   Mounted On
/dev/sda1                     20G   17G      1.8G    91%    /   

...
{% endhighlight %}

Looks simple enough right? I just need to free up some space?

Afraid not.

{% highlight bash %}
du -mcs /
2264 /
2264 Total
{% endhighlight %}

Just for some clarification this small partition is in use for the operating system only, the mysql instance itself is infact mounted on a much larger partition using the same method as detailed in <a href="https://blog.oneiroi.co.uk/hacking/mysql-moving-varlibmysql-and-error-121">mysql moving /var/lib/mysql and error121</a>

So here's the problem, <strong>df</strong> and therfor all the monitoring systems are reporting the disk as full where as <strong>du</strong> clearly shows it is not ... 

Leaving me in the position of if I can not find where the disk usage is with <strong>du</strong> I have no way of freeing the disk space and bringing the service back online ...

Or do I?

After talking with Matthew Ife of ukfast he suggests there must be a an unclosed file IO (aka a file descriptor) that is using up the diskspace, these descriptors do not show up using <strong>du</strong>

After some searching around I find the command <strong>lsof</strong> this command will list the open file descriptors for a process including their current size ...

{% highlight bash %}
psa ux | grep mysqld
mysql     8131  2.8  1.5 304088 63668 ?        Sl   09:37   0:36 /usr/libexec/mysqld --basedir=/usr --datadir=/var/lib/mysql --user=mysql --pid-file=/var/run/mysqld/mysqld.pid --skip-external-locking --socket=/var/lib/mysql/mysql.sock

lsof -p 8131

...
mysqld  27878 mysql    3w   REG                8,2 14930490713   3290408 /var/log/mysql-slow.log.1 (deleted)
...
{% endhighlight %}

As you can see above the open file descriptor flagged as (deleted) was increasing in size until the diskspace ran out, for the time being I have since disabled mysql slow query logging whilst I sort out the log rolling as described in <a href="https://blog.oneiroi.co.uk/mysql/mysql-slow-query-log-rotation">Mysql slow query log rotation</a>


