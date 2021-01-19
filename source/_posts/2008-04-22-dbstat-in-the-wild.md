--- 
wordpress_id: 40
layout: post
title: dbStat in the Wild
date: 2008-04-22 15:08:12 +01:00
tags: []

categories: 
- linux
- mysql
- dbstat
wordpress_url: https://blog.oneiroi.co.uk/linux/dbstat-in-the-wild
comments: true
---
Seems that dbStat had to be developed much faster than I realised, it _was_ a personal project that I was working on as I got time.<br /><br />Now it has been completely re-written to provide a complete "break down" of a large mySQL database suffering some major iowait (on average 15%).<br /><br />The database in question was 17GB in size with 63% of that data size being pure indexes ... MAJOR headache.<br /><br />After completion of v1.0 dbStat, and subsequent review of the output, we were able to reduce the Index size by 7GB (41% of Total).<br /><br />So the datbase is siting at ~10gb (40% index), plenty more work to do, but by removing the problem causing indexes we have reduced the index overhead and stemmed a growth of ~380mb/24hrs<br /><br />Rapid development has left a few bugs, currently dbStat is at v1.2 with a very buggy CSV export function, anyway more as the project progresses, it also raises a few questions about public release now due to it being laregly to resolve a business issue.<br /><br /><br />Hmm maybe I can get a testimonial! haha<br /><br />EDIT: iowait is down to 2.28% now :D<br /><br /><br />
