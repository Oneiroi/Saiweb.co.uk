--- 
wordpress_id: 704
layout: post
title: Using freeNAS for Disaster Recovery - Part 1
date: 2009-07-24 15:45:43 +01:00
tags: 
- nas
- freenas
- disaster recovery
- build
categories: 
- freenas
wordpress_url: https://saiweb.co.uk/freenas/using-freenas-for-disaster-recovery-part-1
comments: true
---
As the company I am working for (<a href="https://www.psycle.com">Psycle Interactive Ltd</a>) grow there became an increasing need to store and share large files between machines, granted we are all on MACs here, but the "drop box" becomes inconvenient when you want to share that file with multiple people.

As such I looked for ways to build a "cost effective" NAS, and now following the success of a recent build using <a href="https://www.freenas.org/">FreeNAS</a> for deploying an office NAS with 2.7TB of usable disk space I/we have developed a concept for using these relatively cheap NAS systems for Disaster Recovery Purposes.

This NAS build at the time of writing costs £740.54 inc VAT, for a 4TB system, giving approx 2.7TB of usable diskspace in a RAID 5 configuration, try getting a pre-built model for that, here's a comparison
<ul>
	<li>4TB NAS Built in this series £740.54 inc VAT</li>
	<li>Iomega 4TB NAS ~£2576.50</li>
	<li>HP Proliant 4TB ~£4502</li>
	<li>Netgear Readynas ~£1322.17</li>
</ul>
note: "~"
As show above I will be building our 4 NAS systems (1 I have already built) for around £1600 less than the price of a single HP Proliant system.

This blog series will cover the build process of the NAS systems as they are built, along with the theory and methods used to allow them to function as DR devices.

[gallery]

Currently we are waiting for the memory to arrive from Crucial, so until that arrives the new builds will not progress, in Part 2 I will be going over the motherboard and the "extras" we have chosen to use for this build.

See you in part 2!
