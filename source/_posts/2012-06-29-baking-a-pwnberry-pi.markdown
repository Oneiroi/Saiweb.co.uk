---
layout: post
title: "Baking a pwnberry pi"
date: 2012-06-29 12:54
comments: true
categories:
- linux
- raspi
- security
- pentesting
- netsec 
---

Earlier in the month I made reference in my Google+ posting that I had begun prototyping a pentesting "drop box" using the (Raspberry Pi)[https://www.raspberrypi.org] as the brains.

This is now 19 days since, and I realised I had not gotten around to writing a blog post on the project.

<strong>The Problem</strong>

The general public are unaware just how much data they send/receive at any given time; especially if said person has a "smart phone" the wealth of personal data a person carries around in their pocket can be staggering; more so that they have absolutely no clue how bad that can potentially be.

Want to carry out a little experiment?

1. Gather some none netsec aware people
2. How many of them can tell you right now without looking, if their phones wifi is enabled?
3. How many can do the same for bluetooth?
4. Without giving details, how many have passwords / bank details / something that shoudln't be on their phone; on their phone?

You'll be concerned with the results (unless you have somehow found a random grouping of people completely aware of their phones function and content at all times ...).
 
<strong>Bridging the gap</strong>

In my experience no matter how you phrase it; for the general end consumer any conversation on netsec is met with indifference mainly due to a lack of understanding which is frustrating to say the least.

However you can can two directions in this situation berate the stupid luser; or you can attempt to educate them, and to that effect the most successfull method is something visual, in the form of a practical demonstration of the point you are trying to get across.

Why? It removes the need for the end consumer to attempt to mentally visualise what you are describing; all puns aside this makes it far easier for the end consumer to understand.

<strong>Education, got it ... so why the pi?</strong>

Simple really, inexpensive 600MHZ arm processor that can boot linux and run from a battery pack.

 The peak consumption I read somewhere is around 700ma, the battery pack in question is a 5000maH which asusming we see a 60% return on a full charge equestes to roughly 4.5hrs run time total.

1. Low power consumption
2. Easily portable
3. Relativly inexpensive
4. Runs linux


<strong>The Concept</strong>

I'd like to assume if you are reading this, you have at least a basic knowledge of netsec so at this point the post becomes less end user friendly ...

1. Jassegar - utilizing jassegar to masquerade as a trusted ap, and route traffic through ethernet / usb 3g dongle.
    a. Desposable - setup and go, access data over 3g connection via a reverse tunnel; remote wipe / destruction.
2. Karma - I don't know much about the karma quite, it appears this can be used for much the same as jassegar.

Couple the above with airdrop-ng for active denial of all wifi in the area, and suddenly every smart phone / laptop in the area is routing via the pwnberry pi and NO ONE is the wiser.

<strong>Proof or STFU</strong>

Whilst I don't have a working demo at this time, perhaps some photos of the "build" would suffice?

{% img https://blog.oneiroi.co.uk/images/pwnberry-ingredients.jpg %}

Running left to right:

1. SD Card
2. 5000maH usb battery
3. Bottom of the "weather proof box"
4. Raspberry PI
5. ALFA awus036nh

{% img https://blog.oneiroi.co.uk/images/pwnberrypi-weatherproof-box.jpg %}

All boxed in the "Premium" container, aka rubber sealed tupperware of doom ...

<strong>To come ...</strong>

I'm trying out different distributions to achieve this, pwnpi is looking promising at the moment.

As always time is limited so it's on an as / when basis.


