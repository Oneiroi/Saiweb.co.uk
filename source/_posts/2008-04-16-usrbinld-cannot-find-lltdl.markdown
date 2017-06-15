--- 
wordpress_id: 38
layout: post
title: "/usr/bin/ld: cannot find -lltdl"
date: 2008-04-16 11:40:08 +01:00
tags: 
- ltdl
- libphp5.la
categories: 
- hacking
- linux
- php
wordpress_url: https://saiweb.co.uk/hacking/usrbinld-cannot-find-lltdl
comments: true
---
<p>Now this one was annoying!</p>
<p>Whilst adding imap support to a php 5.2.2 installation running from a red hat linux 4 distro, I kept getting the same error, when running my custom config script.</p>
<p>{% highlight bash %}/usr/bin/ld: cannot find -lltdl
collect2: ld returned 1 exit status
make: *** [libphp5.la] Error 1{% endhighlight %}</p>
<p>Very strange as the files were there!</p>
<p>{% highlight bash %}[root@dev01 ~]# ldconfig -p |grep ltdl
        libltdl.so.3 (libc6) => /usr/lib/libltdl.so.3
        libguile-ltdl.so.1 (libc6) => /usr/lib/libguile-ltdl.so.1{% endhighlight %}</p>
<p>So guess what the problem was ... PHP's make script.</p>
<p>Note the "/usr/lib/libltdl.so.3" this as it would turn out was a symlink to "/usr/lib/libltdl.so.3.1.0" </p>
<p>So just by adding out own symlink without the version number "ln -s /usr/lib/libltdl.so.3.1.0 /usr/lib/libltdl.so" voila the compile runs perfectly!</p>
<p>Another obscure bug *sigh*, ah well at least I can play with the imap extentions now :-P</p>
