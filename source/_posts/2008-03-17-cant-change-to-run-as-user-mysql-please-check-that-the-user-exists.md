--- 
wordpress_id: 17
layout: post
title: Can't change to run as user 'mysql'. Please check that the user exists!
date: 2008-03-17 15:08:06 +00:00
tags: 
- mysql
categories: 
- linux
- mysql
wordpress_url: https://blog.oneiroi.co.uk/linux/cant-change-to-run-as-user-mysql-please-check-that-the-user-exists
comments: true
---
So you've recently made a change to your mysql installation and see the following in

 /var/lib/mysql/server.err

 {% highlight bash %}080317 14:08:50 mysqld started
080317 14:08:50 [ERROR] Fatal error: Can't change to run as user 'mysql' ; Please check that the user exists!{% endhighlight %}{% highlight bash %}080317 14:08:50 [ERROR] Aborting

080317 14:08:50 [Note] /usr/sbin/mysqld: Shutdown complete

080317 14:08:50 mysqld ended

{% endhighlight %} This is a problem that many a time spent on google has not found the result, so I am writing here what exactly to do in this situation ...

 First off

{% highlight bash %} cd /var/lib/mysql{% endhighlight %}

Now run {% highlight bash %}ls -la{% endhighlight %}

 No doubt you will see something similar to this:

{% highlight bash %}drwx--x--x   2 27 mysql     4096 Mar 17 14:05 mysql{% endhighlight %}

Notice the "27 mysql", the user no longer existsing in /etc/passwd.

This is fairly simple to fix.

{% highlight bash %}adduser mysql{% endhighlight %}
{% highlight bash %}chown mysql:mysql -R /var/lib/mysql{% endhighlight %}

Now start up Mysql i.e. "service start mysql" and everyhing _should_ be fine. 
