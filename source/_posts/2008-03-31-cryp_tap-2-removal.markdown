--- 
wordpress_id: 27
layout: post
title: Cryp_Tap-2 Removal
date: 2008-03-31 08:45:05 +01:00
tags: 
- cryp_tap-2
- virus
categories: 
- windows
wordpress_url: https://saiweb.co.uk/windows/cryp_tap-2-removal
comments: true
---
<p><script type="text/javascript"><!--
google_ad_client = "pub-5002016982726982";
/* 468x60, created 09/04/08 */
google_ad_slot = "2202844884";
google_ad_width = 468;
google_ad_height = 60;
//-->
</script><br />
<script type="text/javascript"
src="https://pagead2.googlesyndication.com/pagead/show_ads.js">
</script></p>


<p>Nasty little bug this one, it's a mutator, and despite having booted the machine into safe mode, used process explorer to kill every process it hooked into and finally having to use a command window to remove the offending .dll, once this thing got an active internet connection the fun and games started again!</p>
<p>The best thing you can do is go strait for the removal tool <a href="https://www.symantec.com/security_response/writeup.jsp?docid=2004-112210-3747-99">here</a></p>
<p>There is also links on that page for more information on the virus.</p>
<p>I suggest you remove the infected machine from having any network connection, download the removal tool to a known "good" workstation, and load the .exe onto removable storage (usb), to be run on the infected machine.</p>
<p><strong>UPDATE:</strong> Just using the tool for me at least isn't working! I am now trying this in safe mode.</p>
<p><strong>UPDATE2:</strong> OK! Wonderfull the symantec removal tool is not working at all I am trying another tool <a href="https://www.atribune.org/ccount/click.php?id=4">VundoFix</a></p>
<p>I'll post anoth update once the scan has finished</p>
<p><strong>UPDATE3:</strong> Nope, role on tool #3 <a href="https://download.bleepingcomputer.com/sUBs/ComboFix.exe">COMBOFIX</a></p>
<p><strong>UPDATE4: </strong><a href="https://www.bleepingcomputer.com/combofix/how-to-use-combofix">Combofix</a> did the job, this tool does advertise the fact that 1/100 machines die from running this tool, so if the symantec tool doesn't work use combofix (at your own risk). NOTE: I ran this in safe mode, it then rebooted windows normally and ran the log dump, the system may hang while it does this, mine recovered after about 5 mins, I also copied the program to C:\ prior to running.</p>
<p><script type="text/javascript"><!--
google_ad_client = "pub-5002016982726982";
/* 468x60, created 09/04/08 */
google_ad_slot = "2202844884";
google_ad_width = 468;
google_ad_height = 60;
//-->
</script><br />
<script type="text/javascript"
src="https://pagead2.googlesyndication.com/pagead/show_ads.js">
</script></p>
