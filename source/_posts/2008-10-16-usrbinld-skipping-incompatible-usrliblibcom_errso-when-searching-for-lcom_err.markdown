--- 
wordpress_id: 235
layout: post
title: "/usr/bin/ld: skipping incompatible /usr/lib/libcom_err.so when searching for -lcom_err"
date: 2008-10-16 10:02:28 +01:00
tags: 
- linux
- php
- skipping imcompatible
- x64
- libcom_err
- libcom_err.so
- configure
- compile
categories: 
- linux
- php
wordpress_url: https://saiweb.co.uk/linux/usrbinld-skipping-incompatible-usrliblibcom_errso-when-searching-for-lcom_err
comments: true
---
<b>/usr/bin/ld: skipping incompatible /usr/lib/libcom_err.so when searching for -lcom_err</b><br /><br />his one has been bugging me for a couple of hours now, when trying to compile PHP on a 64bit OS ...<br /><br /><br />Simple put it's a missing symlink, and the config script is trying to "failover" to the version is can find which is 32 bit ...<br /><br />ln -sf /lib64/libcom_err.so.2 /lib64/libcom_err.so<br /><br />Et voila fixed!<br /><br /><br />
