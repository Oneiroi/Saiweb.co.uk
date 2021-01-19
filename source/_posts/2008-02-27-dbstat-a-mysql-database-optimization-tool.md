--- 
wordpress_id: 10
title: dbStat a mysql database optimization tool.
date: 2008-02-27 13:32:07 +00:00
tags: 
- mysql
- dbstat
- database
- optimization
- tool.
tags: 
- linux
- mysql
- php
- dbstat
wordpress_url: https://blog.oneiroi.co.uk/linux/dbstat-a-mysql-database-optimization-tool
---
I have been working on a script as of late to aid in the ever ongoing process of optimizing a web applications "back end", inevitably the database, and underlying code.

Thus dbstat was born, the current version is not for release _just yet_ , as some tweaks are still needed, at the moment it only supports reporting for a single database at any one time.

v 0.5 Features list.
<ol>
	<li>Dynamic / Fixed row size checking. (Dynamic size rows can cause table fragmentation).</li>
	<li>MyISAM / InnoDB  checking (Reports total number of tables using these engines).</li>
	<li>Index threshold testing.</li>
	<li>Table fragmentation threshold testing.</li>
	<li>Table size threshold testing.</li>
	<li>Database size reporting.</li>
</ol>
At the moment this is currently written in PHP, and is quite heavily scripted I will be looking to move to C++ for a v1.0 for the release, for calculations sake and to remove the need to install PHP.

I will post more information as the project develops, I will be looking to release the program and source under GPL by version 1.

By version 1, I intend to have included the following:
<ol>
	<li>User interactive reporting. (On even of threshold being exceeded, prompt user to fix or skip, with cursory notes*)</li>
	<li>Table de-fragmentation.</li>
	<li>Reporting to include suggested fixes.</li>
</ol>
*Cursory notes  to describe the fix, and possible implications of actioning it.

So watch this space, and please leave requests via comments :)
