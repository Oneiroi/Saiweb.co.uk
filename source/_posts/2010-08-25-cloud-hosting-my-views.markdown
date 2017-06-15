--- 
wordpress_id: 927
layout: post
title: Cloud hosting - my views
date: 2010-08-25 15:25:05 +01:00
tags: 
- hosting
- cloud
- is
- pants
categories: 
- hosting
wordpress_url: https://saiweb.co.uk/hosting/cloud-hosting-my-views
comments: true
---
This blog entry here: <a href="https://rackerhacker.com/2010/08/25/a-nerds-perspective-on-cloud-hosting/">https://rackerhacker.com/2010/08/25/a-nerds-perspective-on-cloud-hosting/</a> prompted me to write this blog post, after I realized I'd filled the comment field, without ending my "monologue", anyway I thought it would be better to voice my opinions here, to you lot who are daft enough to read this blog.

I think the problem mainly is the term "cloud" has been massively over marketed and possibly long since lost it's original meaning, with providers trying to jump on the marketing bandwagon.

I've not made the jump to "the Cloud" yet, as frankly I can't see a benefit to them over properly configured HA installations, for example I would much rather be using several pre-configured servers using RHCS to handle the migration of critical services (mySQL etc..).

I begin to see the benefits for large hosting providers, where customers what the power of a dedicated server but only pay for what they actually use, in this instance a provider ensures up time through live migration,

Some other misconceptions through over marketing I'd like to point out,

1) <strong>The "cloud" is not always on</strong>

Don't get me wrong it can be configured to be close, using distributed VM's for your critical services (i.e. apache), coupling this with loadbalancing and clustering setups.

The misconception for most "end users" is that if you buy a single cloud instance, through magic/voodoo it will always be on 100% of the time!

Simply put if the hardware it was running on dies, it will go down, regardless of live migration measures in place, there will be downtime, do not pass go do not collect http 200 go directly to &gt; /dev/null

2) <strong>The "cloud" is not secure</strong>

If you insist on putting your 5 year old joomla website on a cloud VM, it can and will become compromised quickly, security is only going to be as good as the configuration you have in place, you have mitigation measures such as
<ul>
	<li>selinux</li>
	<li>webapp updates/patches</li>
	<li>fail2ban/banhosts packages</li>
</ul>
Whilst in itself a VM is largely seen as secure as it protects the host machine should the VM become compromised, it is not always the case, for instance there have been several occurrences of VMWare ESXI servers allowing code execution on the host (long since patched Don't panic!), allowing attackers who have compromised a VM on the cloud to root the host machine and as a cascading effect every other VM instace on the box.

Let me point out a worst case scenario here:
<ol>
	<li>Hypervisor running on Host A with 30 Vm's</li>
	<li>Host A is part of a resilient set with live migration in place, Hosts B,C,D</li>
	<li>VM A's 5 year old joomla app is subject to an XSS bug, and an attacker places the r57 shell on the webapp,</li>
	<li>attacker proceeds to deploy backdoors (i.e. meterpreter)</li>
	<li>VM A is subject to remote code execution on host</li>
	<li>Attacker compromises Host</li>
	<li>Host A is now root'ed</li>
	<li>Attacker forces Migration of VM A onto Host B</li>
	<li>Host B rooted using same method</li>
	<li>Rinse &amp; repeat for C &amp; D</li>
</ol>
In summary, if you are looking at a cloud solution and your web presence is important take an informed decision from one of the larger providers, and <strong>NEVER EVER</strong> go with the cheapest option you could find, probably on ebay ...

The cloud is not some magical being created by the hosting fairies that will take all your hosting and maintenance woes away, it may or may not be the right thing for your business / web app, and in certain instances can lower TCO, I for one will be sticking with my Cluster services and high Availability designs for a while yet.
