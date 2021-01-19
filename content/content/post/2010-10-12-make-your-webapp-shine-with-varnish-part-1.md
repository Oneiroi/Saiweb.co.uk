---
date: "2010-10-12T12:56:55Z"
tags:
- linux
- technology
- hosting
title: Make your webapp shine with varnish - Part 1
wordpress_id: 957
wordpress_url: https://blog.oneiroi.co.uk/linux/make-your-webapp-shine-with-varnish-part-1
---
<strong>Part 1, what is varnish?</strong>

The <a href="www.varnish-cache.org">varnish cache project</a> is one you really need to get familiar with if you manage any high volume websites, it can mean the difference between a self destructing web app that buckles under it's own load, and an apparently seamless web app serving 1000's of concurrent connections per second with relative ease.

<strong>How does it work?</strong>

Varnish acts as a proxy server, in that when a use sends a GET request varnish will lookup in its internal database for a cached version and if it can not find one it will pass the request to the "back end" or in this case an apache server, varnish will then cache the response for subsequent accesses.

Now you may ask yourself why do you need this? this boils down to what you are trying to achieve with your web application, if your application is heavily reliant on dynamic content and regularly gets some 400 concurrent users for example, lets assume the following:

<ol>
	<li>400 concurrent unique users</li>
	<li>Average page render time is 0.85s</li>
</ol>

<strong>The Math</strong>

Based on this if you were to place varnish in front of your application with a 60second ttl (time to live, length of time varnish will hold an object in cache):
<ol>
	<li>Varnish ttl 60 seconds</li>
	<li>400/0.85 = 470.59/second</li>
	<li>28235.29/minute</li>
	<li>Factor of reduction to "back end": x28235.29</li>
</ol>

So in the example above simply by caching a page for as little as 60 seconds, the requests/minute as reduced from 28235.29 to 1, now even reducing the cache times to 10 seconds in this example would give a x4705.88 reduction.

How is this reduction a good thing, well time on cpu for one, varnish when configured correctly is very very fast, and even with an out of the box configuration it's still going to be much faster than your dynamic web application.

<strong>Summary</strong>

So here ends a brief introduction to varnish and why you realy want to start using it, in the following parts we will cover

<ul>
	<li>Configuration overview</li>
<ul>
	<li>brief overview of each sub section based on the 2.1 syntax</li>
</ul>

<ul>
	<li>Advanced configuration</li>
<ul>

	<li>Load balancing</li>
	<li>Failover handling</li>
	<li>Raising cache hitrate</li>
	<li>Pros and cons of each setup</li>
	<li>Benchmarks</li>
</ul>

</ul>
</ul>










