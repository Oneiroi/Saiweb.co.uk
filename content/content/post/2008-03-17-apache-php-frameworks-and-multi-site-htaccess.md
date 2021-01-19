---
date: "2008-03-17T11:26:09Z"
tags:
- linux
- apache
title: Apache, PHP Frameworks, and multi site .htaccess
wordpress_id: 16
wordpress_url: https://blog.oneiroi.co.uk/linux/apache-php-frameworks-and-multi-site-htaccess
---
If like me you have a PHP framework, that runs multiple sites, you no doubt have thought at some point in time ...

<em> "Hey I realy could do with this re-write rule on that site, but I don't want it applying to all sites running on the same framework"</em>

Well fear not, after much head scratching, AccessFileName directive to the rescue! i.e.

 Using the above method you can specify bespoke htaccess files on a per VirtualHost basis.

{{< highlight bash >}}&lt;VirtualHost xxx.xxx.xxx.xxx:80&gt;
        DocumentRoot /path/to/framework
        ServerName buzz.blog.oneiroi.co.uk
        <strong>AccessFileName .buzz_htaccess</strong>
        CustomLog logs/buzz_access_log combined
        ErrorLog logs/buzz_error_log
&lt;/VirtualHost&gt;{{< / highlight >}}
 Enjoy!
