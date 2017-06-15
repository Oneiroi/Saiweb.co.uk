--- 
wordpress_id: 666
layout: post
title: High Availability mySQL binlog position comparrison woes
date: 2009-06-16 14:10:19 +01:00
tags: 
- nagios
- mysql
- high availability
- replication
categories: 
- nagios
- mysql
wordpress_url: https://saiweb.co.uk/nagios/high-availability-mysql-binlog-position-comparrison-woes
comments: true
---
I ment to note this down yesterday but everything is going ten to the dozen at the moment.

basically I have now authored a nagios addon for monitoring master-master replication between two servers, this carries out 4 stages of checks

<ol>
	<li>Validates all required data is passed by servers</li>
	<li>Slave IO is running on both servers</li>
	<li>Seconds_Behind_Master check, args can be passed to vary warn and critical thresholds</li>
	<li>(slave) Master_Log_File == (master) File</li>
</ol>

The 5th check was a comparison on the binlog positions themselves, comparing (slave) Read_Master_Log_Pos and (master) Position

Here in lies the problem, which took a while to track down, the problem is that no matter what I tried the slave was <strong>ALWAYS</strong> behind the master position ... but why?

The reason is why I designed the High Availability solution in the first place ... Very high traffic level, in the region of 20,800 transactions per second.

Why was this the problem? the two queries run to gather the data are done sequentially per server, using the python time library I was able to find that there is a 0.02s interval between gathering datasets (20 milliseconds) ... in that time 416 transactions had take place.

i.e.

time: binlog pos

Slave A

0.000: 100

Master B

0.020: 516

This unfortunately has now lead to some 32 lines of code being commented out, as I can see no way to reliably use the binlog positions for monitoring the replication in this situation, if any delay occurs anywhere at any point during the dataset collection i.e. network latency, delay in query processing due to traffic peak on one server ... etc. the collected samples will always be different

The only way I ever see this working is if you can validate that the datasets came from the same exact point in time down to the nanosecond, this however is again not possible, on the network the servers currently reside there is a 0.13 millisecond ping response time this works out to 13,000 nanoseconds (0.00013 * 10^9)

If anyone has any theories on how to overcome this please let me know.


NOTE: At present due to the programming of this addon being done during working hours the nagios addons are not for public release at this time, this may be subject to change in the future should my employers allow their release.






