--- 
wordpress_id: 996
layout: post
title: Saying no to the YESMAN - Defense against Jasager
date: 2011-03-16 17:52:21 +00:00
tags: 
- jasager
- mitm
- defense
categories: 
- hacking
wordpress_url: https://saiweb.co.uk/hacking/saying-no-to-the-yesman-defense-against-jasager
comments: true
---
With work returning to "normal" levels I began digging through my backlog of seclist updates, errata updates and security related podcasts,

One particular attack method has me concerned as a typical Paranoid Systems Admin, namely the one covered by Darren @ Hak5.org,

Where combining jasager and airdrop-ng can allow you to easily set yourself up as a m.i.t.m transparently, so I began thinking how would you defend against such an attack, with most if not all wifi clients switching to jasager transparently without the user ever knowing, now remember this is all theory at this point it could be completely wrong, please leave feedback in the comments.

before I beging let's make a couple of assumptions.
<ol>
	<li>You are the admin for your network</li>
	<li>You are in control of all AP's on your network</li>
</ol>
If you can not confirm 1 &amp; 2 then you can land yourself in a whole heap of trouble, so think before you do please ...

That said onto a possible defense scenario, making airdrop-ng work as a "shield".

The main premise of airdrop is to send DeAuth packets forcing a wifi client to reconnect, Darren's jasager + airdrop  podcast ("Airport wifi challenge") used this in conjunction with jasager to force clients to reconnect but to jasager instead, essentially denying access to the real AP's and masquerading as them using jasager.

With me so far?
<ol>
	<li>Client is connected to REAL Access Point</li>
	<li>airdrop-ng sends DeAuth for all BSSIDs except jasager's</li>
	<li>Client Attempts to reconnect, jasager masquerades as the REAL AP</li>
	<li>Client is now pwned.</li>
</ol>
To re purpose airdrop-ng as a "shield", we change step 2 above .
<ol>
	<li>Client is connected to REAL Access Point</li>
	<li>airdrop-ng sends DeAuth for all BSSIDs except the REAL access point</li>
</ol>
Now this does cause a problem for any genuine "pop up" wifi, such as the share functionality on mac osx, and  mobile hotspots (wifi 3g), but it is one possible method of defense.

If you have some theories related to detecting and defeating WiFi m.i.t.m attacks please let me know, I'd love to hear them,

I'll work on getting a screencast for this up as soon as possible.
<ul>
	<li>this will not protect against BSSID / MAC spoofing,</li>
	<li>this will only prevent against a rougue AP BSSID masquerading as your valid AP.</li>
	<li>this will only work within range of your wifi device generating the DeAuth packets.</li>
	<li>improper configuration could cause D.o.S of nearby REAL Ap's and generaly piss people off.</li>
</ul>

<strong>Update 04/10/2011</strong> Seems that this project <a href="https://code.google.com/p/wifijammer/">wifijammer</a> can do exactly what I outlined above. via: <a href="https://hackaday.com/2011/10/04/wifi-jamming-via-deauthentication-packets">Hackaday</a>
