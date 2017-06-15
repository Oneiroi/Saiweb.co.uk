--- 
wordpress_id: 75
layout: post
title: Cisco Catalyst 3560 and 802.1Q VoIP
date: 2008-07-09 13:51:36 +01:00
tags: 
- 802.1q
- voip
- cisco
- "3650"
- encapsulation
categories: 
- networking
- cisco
- voip
wordpress_url: https://saiweb.co.uk/networking/cisco-catalyst-3560-and-8021q-voip
comments: true
---
Some VoiP devices require the use of 802.1Q, encapsulation protocol, to set this up you are going to have to do this using telnet, and on a per port basis.

If you don't know how to start a telnet session with your Cisco device, then I suggest you stop reading now, and defer this task to someone who does, no offense but getting this wrong can screw up your network.

{% highlight bash %}
User Access Verification

Password:
3560>enable
Password:
3560#conf t
Enter configuration commands, one per line.  End with CNTL/Z.
3560(config)#int GigabitEthernet0/1
3560(config-if)#switchport trunk encapsulation dot1q
3560(config-if)#switchport mode trunk
3560(config-if)#^Z
3560#wr mem
Building configuration...
[OK]
{% endhighlight %}

All you need to know is above, simple rinse and repeat for the other ports you wish to use 802.1Q, of course you can forgo the CTRL+Z followed my wr mem if you have multiple ports to do, just make sure you do CTRL+Z folowed by a "wr mem" otherwise your changes will only effect the current running configuration, if the device is restarted for whatever reason changes will be lost.
