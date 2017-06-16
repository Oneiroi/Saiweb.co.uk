--- 
wordpress_id: 70
layout: post
title: PHP Portscanning
date: 2008-06-19 07:55:00 +01:00
tags: 
- php
- portscan
categories: 
- hacking
- php
wordpress_url: https://blog.oneiroi.co.uk/hacking/php-portscanning
comments: true
---
This is another _old_ proof of concept I had several years ago, you can infact use PHP to scan ports, bare in mind the legality of this is still somewhat _hazy_ therefore if you must portscan I recomend you only do so on Systems you operate.

<strong>Disclaimer: This tutorial is provided for informational purposes only.</strong>

<strong></strong>

UPDATE: Project file now available from <a href="https://svn.blog.oneiroi.co.uk/branches/port_scanning/trunk/port_scanning.php">https://svn.blog.oneiroi.co.uk/branches/port_scanning/trunk/port_scanning.php</a>

Sample output:
{% highlight bash %}----- PORT SCAN 11 TCP PORTS -----
HOST: 127.0.0.1
DATE: Thu, 19 Jun 2008 08:43:13 +0100
PORT 80 OPEN
PORT 81 CLOSED
PORT 82 CLOSED
PORT 83 CLOSED
PORT 84 CLOSED
PORT 85 CLOSED
PORT 86 CLOSED
PORT 87 CLOSED
PORT 88 CLOSED
PORT 89 CLOSED
PORT 90 CLOSED
PORT 87 CLOSED
PORT 88 CLOSED
PORT 89 CLOSED
PORT 90 CLOSED{% endhighlight %}
<strong>NOTE:</strong> The current timeout is 0.5s per socket meaning you have a potential runtime of (($endport - $start_port) * 0.5) seconds. Make sure this does not excced your max execution time, or in the construct add:
{% highlight php %}$time = (($endport - $start_port) * 0.5) + 5;
set_time_limit($time);{% endhighlight %}
This will increased the max execution time with a 5 second buffer.

Please also note in most cases of "shared" hosting you will not be able to crate socketed connections, they will either be blocked by the hosting providers firewall, or disabled at the php runtime, therfor not giving an accurate result.

Again please note this is a proof of concept, you may freely distribute the code under the <a href="https://www.opensource.org/licenses/mit-license.php">MIT licence</a>
