---
date: "2010-11-10T14:28:48Z"
tags:
- rant
title: The idiocy of "anonymous proxies"
wordpress_id: 970
wordpress_url: https://blog.oneiroi.co.uk/rant/the-idiocy-of-anonymous-proxies
---
Or rather the idiocy of your generic "I've just been to pc world/<some other computer retailer> to get on the intarnets", who for the duration of this post we will refer to as Joe Idiot.

Joe concerned with his online privacy comes across an anonymous proxy service, thinking nothing of it Joe installs said proxy service and uses it for all his online activity "sticking it to the man" as he would say, whether playing farmville on facebook or managing his bank account online, Joe feels overly confident in his ability to remain anonymous on the interwebs,

But this is where things go wrong, this is when Joe finds his Bank account his empty, and perhaps even worse someone has logged into his facebook account and trashed his Farmville, what could have possibly caused this?, no internet type hacker could of found Joe surely with his elite proxy skills keeping him Anonymous on the internet ? ... this dear readers is where Joe and by extension the ill informed general population of internet users are wrong.

First some clarification as to what a proxy service is.

{{< highlight bash >}}
You ----> Your proxy service ---> The web page you want
{{< / highlight >}}

In the simplest of terms when using an anonymous proxy Joe is no longer connecting to the servers upon which Joe's precious facebook / whatever account resides, Joe is connecting to the proxy service servers, and by extension <strong>Joe is sending all his data to the proxy servers</strong>.

Slight pause while the market for anonymous proxies dips a few points ...

Now by no means am I saying that all proxy service providers log the data you are sending to their servers, I am just pointing out to the Joe's out there, that they could, and could do so without your consent and you would never even know.

So please just because someone posted to your facebook wall to try this awesome proxy service, don't jump on the proverbial bandwagon spend some time checking things out like

<ul>
	<li>Are they a reputable company?</li>
	<li>What does a quick google of their company name turn up?</li>
</ul>

It astounds me how many people could save month/years of headache by spending 5 minutes actually researching what they are doing, and knowing all the implications of what they are doing.

So for clarification, Anonymous proxies are only anonymous to the end website, being as they originating IP to their eyes is that of your proxy service, there is zero anonymity at the proxy side and all data you send to it can be captured.

