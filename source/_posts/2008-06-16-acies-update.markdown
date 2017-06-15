--- 
wordpress_id: 66
layout: post
title: Acies update
date: 2008-06-16 15:50:22 +01:00
tags: 
- php
- acies
categories: 
- linux
- php
- acies
wordpress_url: https://saiweb.co.uk/linux/acies-update
comments: true
---
<p>Well the XML rendering API has been giving me no end of head ache during the development ... the end is in sight however.</p>
<p>Acies is moving along nicely, I am debating the use of globals over extended classes.</p>
<p>At this moment all objects are callable using the $this->CLASS->method(); this is fine in the current model of parent executing child, this does make accessing the parent objects from the child classes, much more difficult, however I want to avoid the use of many "Global" declarations ...</p>
<p>*sigh* ... Well as I strive to get this framework done no doubt there will be much more "hairpulling" ...</p>
