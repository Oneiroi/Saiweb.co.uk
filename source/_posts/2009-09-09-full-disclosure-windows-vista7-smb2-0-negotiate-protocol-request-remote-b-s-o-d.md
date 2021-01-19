--- 
wordpress_id: 772
layout: post
title: "Full Disclosure: Windows Vista/7 : SMB2.0 NEGOTIATE PROTOCOL REQUEST Remote B.S.O.D"
date: 2009-09-09 09:00:48 +01:00
tags: []

categories: 
- windows
wordpress_url: https://blog.oneiroi.co.uk/windows/full-disclosure-windows-vista7-smb2-0-negotiate-protocol-request-remote-b-s-o-d
comments: true
---
<a href="https://g-laurent.blogspot.com/">laurent gaffie</a> has produced a proof of concept remote BSOD affecting windows vista /7.

It is advised at this time to block all NETBIOS and SMB trafic on your network as there is currently no patch available.

Read the entry here: <a href="https://seclists.org/fulldisclosure/2009/Sep/0039.html">https://seclists.org/fulldisclosure/2009/Sep/0039.html</a>

At the time of writing this entry I tested this on a Windows Vista VM (fully patched).
<p style="text-align: center;"><a href="https://blog.oneiroi.co.uk/uploads/2009/09/2009-09-09_0954.png"><img class="aligncenter size-medium wp-image-773" title="2009-09-09_0954" src="https://blog.oneiroi.co.uk/uploads/2009/09/2009-09-09_0954-300x271.png" alt="2009-09-09_0954" width="300" height="271" /></a></p>

<a href="https://www.microsoft.com/technet/security/advisory/975497.mspx">
MS - Security Advisory</a>
