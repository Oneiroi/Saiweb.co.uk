--- 
wordpress_id: 1060
title: Fixing OSX Lion AFP the version of the server you are trying to connect to is not supported
date: 2011-07-21 13:58:01 +01:00
tags: 
- mac
- centos
- osx
- lion
- afp
- atalk
- netatalk
- "5"
- 5.x
- "5.6"
- epel
- el5
tags: 
- mac
wordpress_url: https://blog.oneiroi.co.uk/mac/fixing-osx-lion-afp-the-version-of-the-server-you-are-trying-to-connect-to-is-not-supported
---
For those using netatalk for AFP shares in this case I am using CentOS, the EL5 compiles are missing the configure lines for the dhx2 extension, which is required by OSX Lion, if you are running x86_64 you can grab this file: <a href='https://blog.oneiroi.co.uk/uploads/2011/07/netatalk-2.0.5-2.x86_64.rpm_.zip'>netatalk-2.0.5-2.x86_64.rpm</a> I have also emailed the Package maintainer @ EPEL with the changes I have made for this RPM so I would like to think that -2 will be available from EPEL soon.

Let me know if you have any issues with my RPM.

<strong>UPDATE: <a href="https://koji.fedoraproject.org/koji/buildinfo?buildID=255047">Official Rebuild in testing</a></strong>




