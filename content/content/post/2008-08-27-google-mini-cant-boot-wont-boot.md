---
date: "2008-08-27T15:22:03Z"
tags:
- general
title: Google Mini - Can't Boot Wont Boot
wordpress_id: 159
wordpress_url: https://blog.oneiroi.co.uk/general/google-mini-cant-boot-wont-boot
---
First off let me start by saying if your google mini is still in warranty <strong>APPLY FOR AN IN WARRANTY REPAIR.</strong>

<strong>As a further disclaimer the information provided is for informational and possibly even entertainment purposes only, I accept no liability if you end up bricking your google mini / voiding your warranty / agreement / get yourself sued by google.</strong>

As stated by google you are free to use the mini for the life of the hardware, irrespective of any support contracts. Repairing / replacing components such as the motherboard / cpu / ram therefor prolong "the life of the hardware", I would personaly draw the line at replacing the hard drive, as this can be seen as taking a copy of the google software which is illegal and you have no right to do, SO DON'T DO IT.

Opening your google mini case WILL void your warranty and any support agreement you have with google, and it's not an easy task at all in the first place.

The situation today comes from a big blue paper weight ... a VERY expensive blue paper weight ...

As any "good" consumer I contact the supplier of the faulty hardware ... surely a fault of this nature would warrant a repair?

<hr />Hello **********,

Thank you for writing to Google.

The technical support and hardware warranty for the Google Mini can be extended to up to a maximum of two years. Since your device is past the two year mark, you would need to purchase a new Google Mini if you wanted to be under support again.

However, you can still use the Google Mini to provide the most relevant search results in the industry to your users. The Google search technology comes under a perpetual license, so you are free to keep using it for the life of the hardware.

<hr />I just love these template responses don't you?!?!?!? NO ME NEITHER!

"you can still use the Google Mini" .... well clearly I can't ... aside from either using as amunition in my latest server room catapult project ... or having a very techie paper weight. (Could also double as an educator of the general end user, it is heavy enough)

Clearly at this point google either wants me to resort to acts of medieval carnage with their little blue block of annoyance, or fork out a MINIMUM of £1,990 for a new box ... that's $3638.32 for you US guys.

Not exactly helping with the TCO for a search solution is it? a nice £1k+ / year in Google's pocket, as if they realy need it.

So setting my catapult and newly crafted paper viking style hat and sword to the side, I began looking for alternatives ... It's obviously a hardware fault, no VGA output no "beep" on boot up ...

Thoughts of projectile Blue Boxes of Death and galloping paper vikings on office chairs aside, the task was not going to be easy as the mini is purposely designed to stop the end user from opening it, nothing of course some thermite would have a problem with, the blue block of annoyance's owner however was reluctant to try this option.

The "tamper proof" chasis screws are made of soft aluminium, well it's not as if it was going to be a problem the unit had been opened, google are not about to accept this "old" model anyway and it was as they put it "out of contract", wire clippers + brute force = removed screws, you'll also have to peal back the "google" sticker on the top of the case as this attached the top plat to the front plate of the chasis.

Upon cracking open the case this model in question has a SuperMicro motherboard

{{< highlight bash >}}
Model: P8SCT
PCB Revision: 1.01
{{< / highlight >}}

I check the "usual suspects", swap out the CPU (p4) with a known working CPU same problem no VGA output ... at this point I'm getting annoyed and in what can only be described as a case of irony, I use Google to search for the motherboard manual, hoping a CMOS reset might shed some light as this thing isn't even starting the BIOS from what I can tell ...

** One CMOS clear, and several expletives later **

No dice, this blue box is doing it's best to give me cause to launch it out of the window, at this point more irony sets in as I realise that even Microsoft's <a href="https://en.wikipedia.org/wiki/Blue_Screen_of_Death">B.S.O.D</a> is more informative than this ....

Then it hits me ... SuperMicro are bound to have a support department for their server boards?

** One contact form and 2minutes 40 seconds later **

<hr />Hello Sir,

Please test without any memory and check if system reports a memory error beep (long beeps)

If so then there could be a issue with the used memory test them 1 by 1 or test with different memory

<hr />Sure enough one dead DIMM removal later and this blue box of annoyance, is happily "crawling" away ... which is just as well it is crawling as if it _had_ legs then I would have broken them ...

So in summary a new DIMM is on order, total hardware cost £18, I make that a 99.1% saving.

With thanks to: <a href="https://www.anandtech.com/IT/showdoc.aspx?i=2523&amp;p=3">Anandtech.com</a> and <a href="https://www.supermicro.com/">SuperMicro</a>
