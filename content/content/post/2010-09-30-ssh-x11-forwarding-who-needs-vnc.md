---
date: "2010-09-30T22:18:17Z"
tags:
- linux
title: ssh x11 forwarding who needs vnc?
wordpress_id: 952
wordpress_url: https://blog.oneiroi.co.uk/linux/ssh-x11-forwarding-who-needs-vnc
---
This is one of those things I find my jaw dropping at, whilst punching myself for not knowing about it sooner.
It's true as much as I live in the cli & ssh to do my job I find sometimes I require a VNC connection (i.e. the plethora of system-config-* stuff in RH)

Now however there is an alternative (so long as your client machine has x11 installed)

{{< highlight bash >}}
SSH -X <server ip> -l <user>
{{< / highlight >}}

That's it simple as that, now use a cli command to launch your normal gui tool i..e

{{< highlight bash >}}
kate ~/.bashrc
{{< / highlight >}}

And x11 will launch on the machine you are working from, now don't think the gui is running form your machine it's not!

your machine is now acting as a thin client simply interacting over SSH, with the gui tool running from the server itself!

And there is where the awesomeness lies, esp if like me you run OSX whilst managing *nix servers.

*grin*

