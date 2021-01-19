--- 
wordpress_id: 715
title: "Using freeNAS for Disaster Recovery \xE2\x80\x93 Part 2"
date: 2009-07-27 12:42:13 +01:00
tags: 
- nas
- freenas
- disaster recovery
- build
tags: 
- freenas
wordpress_url: https://blog.oneiroi.co.uk/freenas/using-freenas-for-disaster-recovery-part-2
---
We are still unfortunately waiting for the memory to arrive from crucial, *sigh*, so in this part I will cover what the "extras" are and the installation of them.

Parts list:
<ol>
	<li>Chenbro ES34069</li>
	<li>Jetway JNC92 Motherboard</li>
	<li>Jetway SATA II Daughterboard</li>
	<li>2GB Transcend Flash Memory Module</li>
	<li>4 x Samsung Spinpoint 1TB</li>
	<li>2GB Low profile Ram (When it arrives)</li>
</ol>
<span style="text-decoration: underline;"><strong>The Case</strong></span>
<p style="text-align: center;"><img class="size-medium wp-image-717 aligncenter" title="Chenbro ES34069" src="https://blog.oneiroi.co.uk/uploads/2009/07/IMG_0216-300x225.jpg" alt="Chenbro ES34069" width="300" height="225" /><img class="size-medium wp-image-718 aligncenter" title="Chenbro ES34069 &quot;guts&quot;" src="https://blog.oneiroi.co.uk/uploads/2009/07/IMG_0217-225x300.jpg" alt="Chenbro ES34069 &quot;guts&quot;" width="225" height="300" /></p>

The Chenbro ES34069 case has 4 'hot swappable' SATA 2 HD caddies, optional card reader, internal PSU.

<span style="text-decoration: underline;">PROS:</span>

Good quite case, has all the required features, even some extras such as LED's for the network interfaces, nice and compact, with the hot swap being a major bonus

<span style="text-decoration: underline;">CONS:</span>

I'd have to say the price, this case weighs in at £200+ which is a bit hefty for a case.

The proprietary PSU adapter, I've not had any issues with the PSU's power adapter, but by the looks of things it is bespoke to Chenbro, so I doubt getting a spare/replacement is going to be easy.

The USB header, and optional Card reader, this is more a 'con' of this build, as the motherboard used only has 2 USB headers, one of which is being used by the USB storage for the operating system, meaning you have the choice of either using the front facing USB or the optional card reader.

Inaccessible backplane, now this for me was the kicker, the Daughterboard comes with some finely crafted 90 degree SATA cables, which would of been perfect, if I had been able to actually access the backplane to attach them, I could not for the life of me find a way to get to the backplane without causing irreversible damage to the case itself.

<span style="text-decoration: underline;"><strong>The Motherboard</strong></span>

The Jetway JNC92 Motherboard comes with an Intel Atom Dual core 330 processor, the reasoning behind this will become clear later on, however you can opt for the cheaper single core processors if you wish.
<p style="text-align: center;"><img class="size-medium wp-image-716 aligncenter" title="Jetway JNC92 Motherboard, CN1 Sata Daughtboard, Transcend 2GB &quot;SSD&quot;" src="https://blog.oneiroi.co.uk/uploads/2009/07/IMG_0214-300x188.jpg" alt="Jetway JNC92 Motherboard, CN1 Sata Daughtboard, Transcend 2GB &quot;SSD&quot;" width="300" height="188" /></p>

As the picture shows I have opted to use a Transcend 2GB USB module which attaches directly onto the motherboard, this will be used to store the freeNAS operating system

The SATA II Daughterboard has onboard hardware RAID support 0, 1, 0+1, and 5 RAID options across the 4 ports, I am still debating using the hardware RAID over Software RAID for the following reasons.

Yes I know Hardware raid is much much faster however as I understand it due to the XOR logic used in the hardware processor, using hardware raid essentially locks you into using a particular manufacturers hardware, which if this line is discontinued by the time something goes wrong is a serious issue when trying to recover data, this is where software raid shines as it is code based, and will run from any x86 capable hardware, and lets face it, it is not as if we are lacking CPU power in this build!

<span style="text-decoration: underline;">PROS:</span>

Cheap and cheerfull motherboard

Powerful dual core CPU (Not like we're going to be playing Crysis here, but for the use it is intended this CPU has ample power)

Expandability, this HAS to be the biggest selling point for this motherboard, you do not have to use it for any one thing in particular, I will shortly be looking at using this motherboard with the 3 x Gigabit daughterboard for building a hardware network monitor, think IDS, man in the middle machine goodness!

<span style="text-decoration: underline;">CONS:</span>

Heatsinks, or their rotation they are top to bottom, where as the case I am using as most cases now has the airflow front to back, this is a minor con, but the heatsinks should be orientated for the best airflow.

USB headers, the Transcend USB module is designed to lock into the plastic socket you useually find on your USB headers, this motherboard does not have the sockets just the raw pins.

<strong><span style="text-decoration: underline;">More images</span></strong>

[gallery]
