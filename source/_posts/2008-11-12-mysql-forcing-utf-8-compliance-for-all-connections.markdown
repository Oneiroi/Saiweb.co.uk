--- 
wordpress_id: 254
layout: post
title: mySQL forcing utf-8 compliance for all connections.
date: 2008-11-12 10:05:45 +00:00
tags: 
- php
- mysql
- c
- utf-8
- init_connect
- utf8
categories: 
- mysql
wordpress_url: https://saiweb.co.uk/mysql/mysql-forcing-utf-8-compliance-for-all-connections
comments: true
comments: true
---
The problem that most people face when setting up a UTF-8 database in mySQL is that without calling 'SET NAMES' in the mySQL client prior to issuing any queries (PHP, C++ etc ...) that the client connection will actually in most cases default to  latin-1.

However as of mySQL 5.x or higher you can issue a statement in the my.cnf file calling init_connect.

This will trigger a series of defined commands / queries every time a non super user connects (So if you are using root to connect to your mySQL database, stop reading now and slap yourself HARD).

i.e.

{% highlight bash %}
[mysqld]
init_connect='SET collation_connection = utf8_general_ci'
init_connect='SET NAMES utf8'
default-character-set=utf8
character-set-server=utf8
collation-server=utf8_general_ci
skip-character-set-client-handshake
{% endhighlight %}

<strong>UPDATE 04/09/09</strong>

my mySQL version 5.0.45 x64 only picks up the last entry of init_connect

Use this example in this case:

{% highlight bash %}
[mysqld]
init_connect='SET collation_connection = utf8_general_ci; SET NAMES utf8;'
default-character-set=utf8
character-set-server=utf8
collation-server=utf8_general_ci
{% endhighlight %}


Restart mySQL and check the mysqld.log has not returned any errors (Or your event viewer if you are using windows).

Every client connection will now default to utf-8 encoding and not latin-1, removing the need to add a SET NAMES call on every connection.

This will work for PHP, C++, ruby etc... as the client encoding is now handeled server side, rather that waiting on the client to issue a SET NAMES command.

<strong>UPDATE 30/03/09</strong>: Added "skip-character-set-client-handshake" this ignores the clients request to set the connection charset, this info courtesy of "wardo" <a href="https://word.wardosworld.com/?p=164 ">https://word.wardosworld.com/?p=164 </a>

<strong>UPDATE 10/09/09</strong>

Been having some issues with this working the workaround is to add this config as a single line:

{% highlight bash %}
init_connect='SET collation_connection = utf8_general_ci; SET NAMES utf8;'
{% endhighlight %}
