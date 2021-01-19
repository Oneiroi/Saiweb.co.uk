--- 
wordpress_id: 686
title: "php mail() sh: -t command not found"
date: 2009-07-03 16:06:25 +01:00
tags: []

tags: 
- linux
- php
wordpress_url: https://blog.oneiroi.co.uk/linux/php-mail-sh-t-command-not-found
---
PHP mail() not working?

getting "sh: -t: command not found" when testing using the cli?
what you have is a missing devel package!!!!

In my case sendmail-devel was missing, you'd think the configure script would alert on this but alas no, devel pack installed and one recompile later and the issue is solved.


