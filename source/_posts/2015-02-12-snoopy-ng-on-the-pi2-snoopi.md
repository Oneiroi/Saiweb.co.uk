---
title: "Snoopy NG on the Pi2"
date: 2015-02-12 19:22
tags:
- wifi
- snoopy
- snoopi
- snoopyng
---

I've said it many times over in the talks I've given both at conferences and during meetings, the devices we carry betray a wealth of information about us without us even knowing.

Projects like Jassegar leverage this to masquerade as trusted wifi networks, and yet these issues remain.

And worse still are present in other standards beyond WiFi.

Enter [Snoopy-NG](https://www.sensepost.com/blog/11042.html), this is a suite of tools mostly authored in python which orchestrate the passive collection of the data our wireless devices are constantly screaming out into the Ether.

If you've ever spoken to me at a conference or on site, chances are you've seen my "bag of toys"; the reasons for this are for demonstration purposes.

There's nothing I've found more powerful than giving a practical demonstration of an issue; be it process or security issues at fault (Please consider this the next time you raise a bug on a project's tracker, and provide as much detail as you can screencasts are very useful).

So in this train of thought; following the announcement of [RasPi2](https://www.raspberrypi.org/products/raspberry-pi-2-model-b/), it was time to add another tool / toy to the arsenal.

And so went the "rehashing" of some of the older tools, cases etc...

{% img https://blog.oneiroi.co.uk/images/pi2_atheros_peli_case.jpg %}
{% img https://blog.oneiroi.co.uk/images/peli_usb_power_mod.jpg %}
{% img https://blog.oneiroi.co.uk/images/peli_18000maH.jpg %}


This was not without its issues however, seems if you try to draw more power than the Pi2 can provide it leads to some odd behaviour.

{% img https://blog.oneiroi.co.uk/images/arch_pi2_issues.jpg %}
{% img https://blog.oneiroi.co.uk/images/arch_pi2_issues-2.jpg %}
{% img https://blog.oneiroi.co.uk/images/raspbian_pi2_issues.jpg %}

I took to the [Raspi forums](https://www.raspberrypi.org/forums/viewtopic.php?f=28&t=99530) though the discussion appears to yield nothing but "you've got PSU problems".

In the end the Atheros WiFi is now using a USB-Y adapter (hence the two use A cables attaching to the battery pack), as I've little time to waste on the debate of what a "non crappy" PSU is despite giving complete examples of all types of power supplies used in the diagnosis of the issues at hand, which appear to have been ignored.

Now running on Raspbian a git clone of [Snoopy-ng](https://github.com/sensepost/snoopy-ng) was taken, depedencies installed and some modifications to /etc/rc.local to have snoopy-ng run at startup, and we've got a fully functional "drone unit", though currently reliant on the old "blinken lights" to produce confidence in the running of Snoopy (the WiFi LED will blink in approx 30 second intervals whilst in monitor mode).

{% gist c3b7429768b979280590 rc.local %}
{% gist c3b7429768b979280590 start %}

Currently this has had some 24hrs of stable data collection, with the only interuptions to uptime being the change between wall socket and battery power when moving around.

I would really be intrested in seeing a USB battery pack which can also take a "trickle charge" to aid in mobility, sort of a mini UPS if you will.

What's next? maybe the [USB Armory](https://www.crowdsupply.com/inverse-path/usb-armory) which looks quiet promissing; I'm also looking to add [BadUSB](https://github.com/adamcaudill/Psychson), [HackRF](https://greatscottgadgets.com/hackrf/) to the "bag of toys".

I've also been looking at SDR [on and off](https://twitter.com/icleus/status/529585357437014018), particuarly instrested in the [POCSAG Pager network](https://en.wikipedia.org/wiki/POCSAG) which seems to be another clear text protocol, aswell as 802.15.4 (Xbee / Zigbee) which appears to be making itself into traffic controll systems and is again completely open.

Why you may ask would these things make it into the "bag of toys"?

I reffer back to my previous point of practical examples, unless you can demonstrably show people why something is insecure / broken they have little interest / time / money in fixing the issue at hand, if you want results far better to show someone the problem and work with them on the fix.

A.K.A. Providing a Proof of Concept



