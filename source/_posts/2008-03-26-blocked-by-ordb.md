--- 
wordpress_id: 22
title: blocked by ORDB
date: 2008-03-26 10:18:25 +00:00
tags: 
- ordb
- exchange
- blocked
tags: 
- windows
- ordb
wordpress_url: https://blog.oneiroi.co.uk/windows/blocked-by-ordb
---
<p>Well this is a barrel of laughs...</p>
<p>"<em>The problem is that the ORDB blacklist (which was decommissioned on Dec 18 2006) has been reactivated, but in such a way that it returns a positive match for every query. The operators have done this in order to prompt people who were still using the list to remove it from their configuration.</em>"</p>
<p>Source: <a href="https://forums.whirlpool.net.au/forum-replies-archive.cfm/944800.html">https://forums.whirlpool.net.au/forum-replies-archive.cfm/944800.html</a></p>
<p>At the moment this is effecting our exchange servers, and it's unclear if this is a legacy smtp event or part of the anti spam software...</p>
<p>Everything is being bounced, needless to say I can tell you working for a company that has over a million emails a day this is NOT GOOD!</p>
<p>If your clients are receiving bounce backs I suggest you contact them immediately, and inform them of the situation.</p>
<p>ORDB SORT YOUR ACT OUT!</p>
<p>I will update as I find a workaround!</p>
<p><strong>UPDATE!!!!</strong></p>
<p>For exchnage 2003 use the following article as a guide (Thanks <a href="https://www.absolutech.co.uk/">KERM</a>!):</p>
<p><a href="https://www.msexchange.org/tutorials/Blacklist_Support_Exchange_2003.html">https://www.msexchange.org/tutorials/Blacklist_Support_Exchange_2003.html </a></p>
<p>Remove ORDB! (see below)</p>
<p>(UPDATE: OR remove wirehub: see new post)</p>
<p><img src="https://blog.oneiroi.co.uk/uploads/2008/03/ordb.JPG" alt="ordb.JPG" /></p>

<a href="https://it.slashdot.org/article.pl?sid=08/03/25/2124224">Slashdot article</a>
