---
date: "2008-03-10T15:46:56Z"
tags:
- windows
- microsoft_office_2003
title: Microsoft Office (Word, Excel, Outlook) Slow When Connected To Network, But Fast When Not?
wordpress_id: 14
wordpress_url: https://blog.oneiroi.co.uk/windows/microsoft-office-word-excel-outlook-slow-when-connected-to-network-but-fast-when-not
---
Yes the title seems a little weird, but it's a little problem that has been the bane of my and a fellow techs existence for a couple months now.

An international office on permanent VPN connection to where I work would experience extremely slow load times of office documents even if they were local to the machine, strangely this only occurred when connected to the network (and hence to the domain).

What was eventually found by the afor mentioned fellow tech was that every time an office application would load (i.e. open a new document) it was "polling" the entire domain for listed printers and folders, not a problem in the local office with Gigabit connectivity, but a major problem for an international office with several employees over a low bandwidth line ...

So how to fix this?!?

 (Assuming windows XP &amp; Classic Menu)

START &gt; CONTROL PANEL &gt; Folder Options &gt; View

 Uncheck "Automatically search for network printers and folders" &gt; OK

 Now make sure you exit all office applications (better yet just reboot)

If this does not solve the issue, or only provides a slight gain it's time to remove the "recent files" list, from within excel

TOOLS &gt; OPTIONS &gt; General

 Uncheck "Recently use file list" ... Exit all office apps (or reboot).

And try again, this _appears_ to solve the slow down.

Any problems drop me a comment.
