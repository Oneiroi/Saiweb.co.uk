---
date: "2013-09-21T00:00:00Z"
tags:
- security
title: Tor gains 1.2M users in wake of NSA scandal ironically making it easier for the NSA
---

So ... [TOR](https://www.torproject.org/) is supposed to have gains 1.2 Million users following all the fanfare around the NSA.

If I were to facepalm at this point I fear my face would pushed out the back of my skull, so let me relay a small bit of insight.

TOR is an anonymizing proxy so long as every node along the chain is "behaving", let's say fo sake for argument somene sets up a malicious exit node, [Jackin' TOR](https://packetstorm.foofus.com/papers/attack/jackin-tor.txt) shows just such a setup used to inject content into http requests.

* inject javascript
* javascript executed by browser, makes request to malicious host
* identifying the browser if exploit exits this can now be used
* malicious payload send back in request
* malicious program now running makes direct request to C&C server (this does not go out via TOR, rquest is no longer anonymous)
* we can pretty much do anything we want now with the system

And if the above does not work?

* inject javascript
* steal cookies
* steal users accounts with banking, email, other services.


 
