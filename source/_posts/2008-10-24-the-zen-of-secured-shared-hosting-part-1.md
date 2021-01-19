--- 
wordpress_id: 243
layout: post
title: The zen of secured shared hosting part 1
date: 2008-10-24 08:20:02 +01:00
tags: 
- security
- suphp
- hosting
- zen
categories: 
- hacking
- linux
- php
- apache
- hosting
- security
wordpress_url: https://blog.oneiroi.co.uk/hacking/the-zen-of-secured-shared-hosting-part-1
comments: true
---
Welcome to part one of the 'zen of secured shared hosting' series.<br /><br />In this part I will be covering the concepts of secured shared hosting, and why you as a shared hosting provider should be taking steps to ensure this is how you deploy your hosting environments.<br /><br />Let's first take a typical L.A.M.P setup:<br /><br />PHP Compiled from source as apache module.<br />mySQL installed from RPM or update package (yum / up2date).<br />HTTPD installed as RPM or update package (yum / up2date).<br /><br />Please note at the time of writing if you yum / apt-get / up2date install your PHP package you will have varying results when attempting to compile and install suPHP, as such grab the source code from php.net, and follow this series.<br /><br />As a shared hosting provider lets say you have 5 clients all hosted from the one server, each client using vsftpd is chrooted() into their home directory, and their ssh access disabled, supposedly secure enough.<br /><br />Unfortunatly not so, due to the L.A.M.P configuration the 'apache' user needs a minimum of read and execute permissions over all the PHP files on the system, why is this a problem?<br /><br />This is a problem largely due to human nature of the client, your 'joe bloggs' client doesn't care about the technical aspects of web hosting or websites, they just want an easy pretty interface to get their corner of the internet online, downloading something like drupal or joomla.<br /><br />Now this isn't a dig at open source CMS, this is an insight into human nature, look at the changelog for any open CMS and you will see 'security fixes', unfortunatly all 'joe bloggs' cares about is that their website is working, and this is wher things take a turn for the worse.<br /><br />Joe Bloggs never updates his open CMS platform, meaning any vulnerabilities patched in subsequent releases are still exploitable on his website, worst case scenario that this is an XSSI (Cross Server Script Includes) vulnerbility.<br /><br />An attacker finds this website and idetifies the security hole, using XSSI to install a PHP interactive shell, giving the attacker SSH like access to the hosting environment, most people at this point think so the attacker has compromise one site ... so what we can restore that site from backups and it's only one site that's affected, the other 4 users either do not use open CMS or are up to date with all the security patches.<br /><br />Well that's where you would be wrong, with the hosting setup outlined above the SSH like PHP shell is now running as the apache user, meaning the attacker can go anywhere and read anything apache can, and with the hosting setup oulined above that mean reading things like datbase connection files, suddenly all the clients on the hosting environment have their websites compromised as the attacker gains mySQL access and starts changing content on thewebsites, despite the fact that the other 4 sites themselves were never exploited.<br /><br />One clients error just became a cascading exploit on your hosting platform, now make that a more realistic platform say 30 clients on the box, some are online shops, the issue just became a whole lot bigger there is lost revenue due to downtime of the shop sites, and worse still the attacker now has access to any customer details those shops were storing! but it's not Joe Bloggs that's accountable it's YOU as the hosting provider, you can take steps to prevent one exploited site becoming 30, and this web series will tell you host to do it.<br /><br />coming in part 2:<br /><br />an introduction to suPHP<br />compiling php as a cgi binary, and why you need to do so<br /><br /><br /><br /><br />
