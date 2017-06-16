--- 
wordpress_id: 181
layout: post
title: Honeypotting for viruses - Statement of fees 2008/09
date: 2008-08-29 08:23:08 +01:00
tags: 
- virus
- honey pot
- troj_agent.anid
- troj_zbot.wb
- worm_system.aa
categories: 
- hacking
- linux
- microsoft_office_2003
- security
wordpress_url: https://blog.oneiroi.co.uk/hacking/honeypotting-for-viruses-statement-of-fees-200809
comments: true
---
Getting this email on a regular basis?

"<em>Please find attached a statement of fees as requested, this will be
posted today.</em>

<em>The accommodation is dealt with by another section and I have passed
your request on to them today.</em>

<em>Kind regards.</em>

<em>Hannah </em>"

Yes it is a virus the attached .doc.exe file seems to vary daily in it's choice of virus.

So far it has been:

<a href="https://www.trendmicro.com/vinfo/virusencyclo/default5.asp?VName=TROJ_AGENT.ANID">TROJ_AGENT.ANID</a>
TROJ_ZBOT.WB (No page exists for this variant at the moment)
<a href="https://www.trendmicro.com/vinfo/virusencyclo/default5.asp?VName=WORM_SYSTEM.AA">WORM_SYSTEM.AA</a>

All 3 of which were not detected in the most uptodate pattern from trend, having to instead resort to their CPR release (Controlled Pattern), after emailing these samples to their labs (Another unknown variant was received today, and sent to Trend labs).

This brings into question the validity of "Honey pot" accounts to catch these viruses, the only reason I am able to attain these "samples" before they become a problem is due to the fact I have a "Honey pot" email account with a generic often spammed address format for this purpose.

This is making "Honey pots" more of a NEED now instead of an "Über Techies" box of tricks the end user is afraid to go within 30 meters of.

If you run a windows based network I suggest you do some research into how to setup a good honey pot (DO not use an account on your exchnage server that would be REALY stupid), you can also post a comment or use the contact for for advice.

Once setup make it part of your daily routine to test samples as they some in against your anti virus solution, making sure you know how to send samples to the providers labs for analysis.
