---
date: "2008-06-16T15:50:22Z"
tags:
- linux
- php
- acies
title: Acies update
wordpress_id: 66
wordpress_url: https://blog.oneiroi.co.uk/linux/acies-update
---
<p>Well the XML rendering API has been giving me no end of head ache during the development ... the end is in sight however.</p>
<p>Acies is moving along nicely, I am debating the use of globals over extended classes.</p>
<p>At this moment all objects are callable using the $this->CLASS->method(); this is fine in the current model of parent executing child, this does make accessing the parent objects from the child classes, much more difficult, however I want to avoid the use of many "Global" declarations ...</p>
<p>*sigh* ... Well as I strive to get this framework done no doubt there will be much more "hairpulling" ...</p>
