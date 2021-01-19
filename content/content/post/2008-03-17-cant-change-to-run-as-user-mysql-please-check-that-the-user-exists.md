---
date: "2008-03-17T15:08:06Z"
tags:
- linux
- mysql
title: Can't change to run as user 'mysql'. Please check that the user exists!
wordpress_id: 17
wordpress_url: https://blog.oneiroi.co.uk/linux/cant-change-to-run-as-user-mysql-please-check-that-the-user-exists
---
So you've recently made a change to your mysql installation and see the following in

 /var/lib/mysql/server.err

 {{< highlight bash >}}080317 14:08:50 mysqld started
080317 14:08:50 [ERROR] Fatal error: Can't change to run as user 'mysql' ; Please check that the user exists!{{< / highlight >}}{{< highlight bash >}}080317 14:08:50 [ERROR] Aborting

080317 14:08:50 [Note] /usr/sbin/mysqld: Shutdown complete

080317 14:08:50 mysqld ended

{{< / highlight >}} This is a problem that many a time spent on google has not found the result, so I am writing here what exactly to do in this situation ...

 First off

{{< highlight bash >}} cd /var/lib/mysql{{< / highlight >}}

Now run {{< highlight bash >}}ls -la{{< / highlight >}}

 No doubt you will see something similar to this:

{{< highlight bash >}}drwx--x--x   2 27 mysql     4096 Mar 17 14:05 mysql{{< / highlight >}}

Notice the "27 mysql", the user no longer existsing in /etc/passwd.

This is fairly simple to fix.

{{< highlight bash >}}adduser mysql{{< / highlight >}}
{{< highlight bash >}}chown mysql:mysql -R /var/lib/mysql{{< / highlight >}}

Now start up Mysql i.e. "service start mysql" and everyhing _should_ be fine. 
