--- 
wordpress_id: 952
layout: post
title: ssh x11 forwarding who needs vnc?
date: 2010-09-30 22:18:17 +01:00
tags: 
- ssh
- x11
- forward
categories: 
- linux
wordpress_url: https://saiweb.co.uk/linux/ssh-x11-forwarding-who-needs-vnc
comments: true
---
This is one of those things I find my jaw dropping at, whilst punching myself for not knowing about it sooner.
It's true as much as I live in the cli & ssh to do my job I find sometimes I require a VNC connection (i.e. the plethora of system-config-* stuff in RH)

Now however there is an alternative (so long as your client machine has x11 installed)

{% highlight bash %}
SSH -X <server ip> -l <user>
{% endhighlight %}

That's it simple as that, now use a cli command to launch your normal gui tool i..e

{% highlight bash %}
kate ~/.bashrc
{% endhighlight %}

And x11 will launch on the machine you are working from, now don't think the gui is running form your machine it's not!

your machine is now acting as a thin client simply interacting over SSH, with the gui tool running from the server itself!

And there is where the awesomeness lies, esp if like me you run OSX whilst managing *nix servers.

*grin*

