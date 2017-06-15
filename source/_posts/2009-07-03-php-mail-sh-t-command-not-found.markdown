--- 
wordpress_id: 686
layout: post
title: "php mail() sh: -t command not found"
date: 2009-07-03 16:06:25 +01:00
tags: []

categories: 
- linux
- php
wordpress_url: https://saiweb.co.uk/linux/php-mail-sh-t-command-not-found
comments: true
---
PHP mail() not working?

getting "sh: -t: command not found" when testing using the cli?
what you have is a missing devel package!!!!

In my case sendmail-devel was missing, you'd think the configure script would alert on this but alas no, devel pack installed and one recompile later and the issue is solved.


