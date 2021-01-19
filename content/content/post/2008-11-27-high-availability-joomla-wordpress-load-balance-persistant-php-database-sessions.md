---
date: "2008-11-27T16:27:09Z"
tags:
- mysql
- php
title: High Availability Joomla, Wordpress - Load balance persistant PHP database sessions
wordpress_id: 312
wordpress_url: https://blog.oneiroi.co.uk/mysql/high-availability-joomla-wordpress-load-balance-persistant-php-database-sessions
---
If you've seen the new twitter feed to the right you may of seem some ramblings about 'cura'.

Cura is a PHP class I have authored in Co-operation with <a href="https://www.psycle.com/en/">Psycle Interactive</a> (The company I now work for, so be sure to thank them for allowing me to publish this write up!)

<strong>So what does it do?</strong>
Cura sets several call back objects in your PHP application that re-directs all session data to a mySQL database.

<strong>But why do I need that?</strong>
The average 1 server end user can stop reading here, as I can tell you now that Cura is not for you.

If however you are a business fielding multiple web servers then read on.

By passing all your PHP sessions to a database you remove the work around requirements for a load balanced solution.

i.e. web1 web2

1) Shopper arrives at web1 and logs in.
2) Shopper adds item to cart, which is logged against their session.
3) web1 is subjected to a search engine index.
4) web2 is now serving the shopper, shoppers basket is now logged out as their session id has changed ...

There are numerous work around methods for this, such as having a single shared mount point for the PHP session files, the use of cookies etc ...

The problem is in a high availability solution that a single mount point is just that, it's singular and therefor a single point of failure.

Then there is the use of cookies, which is fine until you start to store a lot of data during your users session, at which point on each server change you are reliant on the cookie data being transmitted back to the server each time, raising the question what is the point of adding a load balanced solution if the user experience becomes degraded due to it's deployment?

So secret option number 3 is to use a database, you can remove the single point of failure by having a mySQL cluster, and you haven't got to worry too much about how much data you are storing.

Because everything is in a database whenever your web application is run (web1, web2) it will read the data from one source, allowing persistent sessions across your whole platform without the need for single mount points or session replication.

The source files are available from: <a href="https://svn.blog.oneiroi.co.uk/branches/cura-php/trunk">https://svn.blog.oneiroi.co.uk/branches/cura-php/trunk/</a>

{{< highlight bash >}}
svn co https://svn.blog.oneiroi.co.uk/branches/cura-php/trunk/
{{< / highlight >}}

To deploy this solution simply add the following lines to any file that calls session_start();

{{< highlight bash >}}
require_once('/path/to/cura.class.php');
$cura = new cura($db, $user, $password, $host);
session_start();
...
the rest of your file...
{{< / highlight >}}
Ensure that you have created a 'sessions' table as per the provided sessions.sql file in your database.

I will be adding simplified support for wordpress and joomla shortly these will become available from: <a href="https://svn.blog.oneiroi.co.uk/branches/cura-php/trunk/">https://svn.blog.oneiroi.co.uk/branches/cura-php/trunk/</a>
