--- 
wordpress_id: 791
layout: post
title: Call to undefined function imagettfbbox()
date: 2009-10-13 13:19:20 +01:00
tags: []

categories: 
- php
wordpress_url: https://blog.oneiroi.co.uk/php/call-to-undefined-function-imagettfbbox
comments: true
---
<strong>Call to undefined function imagettfbbox()</strong>

Either you do not have php GD installed (check your phpinfo(); and see if GD has laoded with TTF support)

Or if you are compiling from source add: --with-gd  --with-freetype-dir=/lib64 --with-ttf=/lib64 --enable-gd-native-ttf

 to your configure line.

Note: you'll need gd-devel and freetype-devel libs installed, and im using /lib64 as im running a 64bit OS.
