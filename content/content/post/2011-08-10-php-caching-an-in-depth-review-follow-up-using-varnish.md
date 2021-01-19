---
date: "2011-08-10T20:59:26Z"
tags:
- php
- hosting
title: PHP & Caching an in depth review - Follow up using Varnish
wordpress_id: 1069
wordpress_url: https://blog.oneiroi.co.uk/php/php-caching-an-in-depth-review-follow-up-using-varnish
---
Ok, so following up on PHP & Caching with Varnish, let's cut to the hard facts shall we?

Using the same tests as <a href="https://blog.oneiroi.co.uk/hosting/php-caching-an-in-depth-review" title="PHP & Caching an in depth review"></a>


 ab -c 100 -n 500 -g ./saiweb-nocache-nogzip.bpl https://blog.oneiroi.co.uk/
This is ApacheBench, Version 2.3 <$Revision: 655654 $>
Copyright 1996 Adam Twiss, Zeus Technology Ltd, https://www.zeustech.net/
Licensed to The Apache Software Foundation, https://www.apache.org/

Benchmarking blog.oneiroi.co.uk (be patient)
Completed 100 requests
Completed 200 requests
Completed 300 requests
Completed 400 requests
Completed 500 requests
Finished 500 requests


Server Software:        Apache
Server Hostname:        blog.oneiroi.co.uk
Server Port:            80

Document Path:          /
Document Length:        92719 bytes

Concurrency Level:      100
Time taken for tests:   0.184 seconds
Complete requests:      500
Failed requests:        0
Write errors:           0
Total transferred:      47597095 bytes
HTML transferred:       47379409 bytes
Requests per second:    2716.92 [#/sec] (mean)
Time per request:       36.806 [ms] (mean)
Time per request:       0.368 [ms] (mean, across all concurrent requests)
Transfer rate:          252573.13 [Kbytes/sec] received

Connection Times (ms)
              min  mean[+/-sd] median   max
Connect:        1    4   1.1      4       6
Processing:     9   31   7.0     32      47
Waiting:        2    7   5.7      4      26
Total:         15   35   6.8     36      53

Percentage of the requests served within a certain time (ms)
  50%     36
  66%     38
  75%     39
  80%     39
  90%     41
  95%     44
  98%     48
  99%     51
 100%     53 (longest request)

<a href="https://blog.oneiroi.co.uk/uploads/2011/08/Out.png"><img src="https://blog.oneiroi.co.uk/uploads/2011/08/Out.png" alt="ab -c 100 -n 500 -g ./saiweb-nocache-nogzip.bpl https://blog.oneiroi.co.uk/" title="ab -c 100 -n 500 -g ./saiweb-nocache-nogzip.bpl https://blog.oneiroi.co.uk/" width="640" height="480" class="aligncenter size-full wp-image-1070" /></a>


2716.92 requests per second with a server load average of 0.1, and in this case varnish is serving cache from disk.

Caching using varnish (Or even nginx / mod_cache) means that PHP does not get executed at all, the cache system grabs the cache content and serves it.

This of course has the benefit of reducing the CPU and memory resources needed for the running of your application, but it does have some caveats.

<ul>
	<li>This only works for GET requests, and content not reliant on Cookies (Truely dynamic content will not cache)</li>
	<li>But on the "flipside" Varnish supports ESI, which when setup correctly you can target the dynamic sections of a pag for "passthrough" and have the rest cached</li>
<ol>


More details to come, as I have time to add them I have have a lot of posts to make on boxgrinder, KVM, libvirtd etc.
