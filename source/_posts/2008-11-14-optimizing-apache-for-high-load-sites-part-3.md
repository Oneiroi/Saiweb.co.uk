--- 
wordpress_id: 298
layout: post
title: Optimizing Apache for high load sites - Part 3
date: 2008-11-14 11:11:03 +00:00
tags: 
- apache
- optimize
categories: 
- linux
- apache
wordpress_url: https://blog.oneiroi.co.uk/linux/optimizing-apache-for-high-load-sites-part-3
comments: true
---
<b>Pulling it all together.</b>

In <a href="https://blog.oneiroi.co.uk/linux/optimizing-apache-for-high-load-sites-part-1">Part 1</a>

I covered the use of pmap to provide an insight into the memory footprint of the apache service.

In <a href="https://blog.oneiroi.co.uk/linux/optimizing-apache-for-high-load-sites-part-2">Part 2</a>

I covered a list modules that are typically enabled in a standard httpd/apache setup, and listed which modules I was disabling to reduce the memory foot print.

After improving the appmem script in <a href="https://blog.oneiroi.co.uk/uncategorized/linux-the-sysadmin-script-part-4">Part 4 of the linux sysadmin script</a> I updated part 3 of this series with the new memory foot print figures.

Summary aside, now we have reduced the memory footprint of your apache installation lets go onto actually making the most of your new found memory excess ..'potential' max clients.

As stated in part 3 of this series, I am assuming the server you are making these configuration changes is a dedicated apache server.

However you also need to be aware of your CGI programs such as PHP, if you are to configure PHP with a maximum memory of 32MB, you must be aware that there is the potential for PHP to try to use this much memory on each allocation, this is where "optimizing PHP gor high load sites" comes into play, a furture series I plan to write, for the time being however I am only covering the configuration of apache.

Your httpd.conf should have the following entries (or similar).

{% highlight bash %}
# prefork MPM
# StartServers: number of server processes to start
# MinSpareServers: minimum number of server processes which are kept spare
# MaxSpareServers: maximum number of server processes which are kept spare
# ServerLimit: maximum value for MaxClients for the lifetime of the server
# MaxClients: maximum number of server processes allowed to start
# MaxRequestsPerChild: maximum number of requests a server process serves
<IfModule prefork.c>
StartServers       8
MinSpareServers    5
MaxSpareServers   20
ServerLimit      256
MaxClients       256
MaxRequestsPerChild  4000
</IfModule>
# worker MPM
# StartServers: initial number of server processes to start
# MaxClients: maximum number of simultaneous client connections
# MinSpareThreads: minimum number of worker threads which are kept spare
# MaxSpareThreads: maximum number of worker threads which are kept spare
# ThreadsPerChild: constant number of worker threads in each server process
# MaxRequestsPerChild: maximum number of requests a server process serves
<IfModule worker.c>
StartServers         2
MaxClients         150
MinSpareThreads     25
MaxSpareThreads     75
ThreadsPerChild     25
MaxRequestsPerChild  0
</IfModule>
{% endhighlight %}

{% highlight bash %}
[buzz@buzz_srv ~]httpd -l
Compiled in modules:
  core.c
  prefork.c
  http_core.c
  mod_so.c
{% endhighlight %}

As can be seen above in my installation the part of the config I am interested in is prefork.c.


Now with my theorehtical max clients in part 3 hitting 800.5, lets first go for a safer figure, say 60% 

{% highlight bash %}
<IfModule prefork.c>
StartServers       8
MinSpareServers    5
MaxSpareServers   20
ServerLimit      480
MaxClients       480
MaxRequestsPerChild  4000
</IfModule>
{% endhighlight %}

From here use the script in <a href="https://blog.oneiroi.co.uk/linux/linux-the-sysadmin-script-part-1">part 1 of the Linux sysadmin script</a>, to monitor your active http connections, and 'tweak' your configuration accordingly.

Remember you must only set the MaxClients and ServerLimit to a value you can safely contain in ram, swapping out to disk will cause a major slow down.
