--- 
wordpress_id: 322
layout: post
title: Zen of secured shared hosting, back on track ... kinda
date: 2008-12-03 12:11:54 +00:00
tags: []

categories: 
- general
wordpress_url: https://blog.oneiroi.co.uk/general/zen-of-secured-shared-hosting-back-on-track-kinda
comments: true
---
Well I have managed to plug the security hole, and I am currently working on refining the deployment by using the ability to disable functions in php ...

The downside?

Some 5244 approx functions over 23 a4 pages ...

<a title="03122008325 by Ascrethy, on Flickr" href="https://www.flickr.com/photos/31732936@N06/3079949402/"><img src="https://farm4.static.flickr.com/3216/3079949402_9b0b492a6c.jpg" alt="03122008325" width="500" height="375" /></a>

<strong>update 04/12/2008:</strong>

For the impatient you can grab a php script I have written to build the complete comma separated list from subversion here: <a href="https://svn.blog.oneiroi.co.uk/branches/zen_of_secured_shared_hosting/trunk/disable_functions_string.php">https://svn.blog.oneiroi.co.uk/branches/zen_of_secured_shared_hosting/trunk/disable_functions_string.php
</a>

Please note this is a 'paranoid' list (some 354 functions!), you will need to for instance remove phpversion, ini_get and http_build_query from the list to get wordpress working.

Customize to your needs :-)
