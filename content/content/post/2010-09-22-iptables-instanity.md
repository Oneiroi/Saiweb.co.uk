---
date: "2010-09-22T17:57:27Z"
tags:
- linux
title: iptables instanity
wordpress_id: 949
wordpress_url: https://blog.oneiroi.co.uk/linux/iptables-instanity
---
Namely a bug to do with iptables rate limiting,

{{< highlight bash >}}
iptables -I INPUT 2 -p tcp --dport http -m state --state NEW -m recent --update --seconds 60 --hitcount 20 -j LOG --log-level=7
{{< / highlight >}}
works!

{{< highlight bash >}}
iptables -I INPUT 2 -p tcp --dport http -m state --state NEW -m recent --update --seconds 60 --hitcount 60 -j LOG --log-level=7
iptables: Unknown error 18446744073709551615
{{< / highlight >}}

-j REJECT also produces the same.

Simply increasing the "hitcount" causes this error, the only work around I have come up with is decreasing the --seconds arg, to yield more hits/sec, still bloody annoying!


