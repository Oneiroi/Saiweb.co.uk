---
date: "2010-04-06T19:27:10Z"
tags:
- linux
title: mod_authz_svn / mod_dav_svn prompting for password
wordpress_id: 852
wordpress_url: https://blog.oneiroi.co.uk/linux/mod_authz_svn-mod_dav_svn-prompting-for-password
---
Strangely I've had some people reporting issues with being <a href="https://OFFLINE/saiweb/ticket/68">prompted for a username and password when accessing files on svn.blog.oneiroi.co.uk 
</a>

it would appear in mod_dav_svn-1.4.2-4.el5_3.1 that this directive: AuthzSVNNoAuthWhenAnonymousAllowed

now defaults to OFF, well that was a p.i.t.a trying to track down, having never seen that directive in ANY of the documentation ...

Anyway pass this on to other facing the same issue.

