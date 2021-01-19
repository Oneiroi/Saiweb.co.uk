---
date: "2011-08-12T08:25:45Z"
tags:
- linux
- hosting
- varnish
title: Content purging changes in Varnish 3.0
wordpress_id: 1085
wordpress_url: https://blog.oneiroi.co.uk/linux/content-purging-changes-in-varnish-3-0
---
If you tie in your web application to automatically PURGE content when you modify it, thus keeping the content "fresh" while using Varnish you may notice if you made the jump from 2.x to 3.x that your PURGE VCL is no longer working, I refer you to: <a href="https://www.varnish-software.com/blog/bans-and-purges-varnish-30">https://www.varnish-software.com/blog/bans-and-purges-varnish-30</a>

In short replace your usual

{{< highlight bash >}}
sub vcl_hit {
        if (req.request == "PURGE") {
                set obj.ttl = 0s;
                error 200 "Purged."; #uses error function to return simple confirmation
        }
}
sub vcl_miss {
        if (req.request == "PURGE") {
                error 404 "Not in cache."; #request to purge none existant item
        }
}
{{< / highlight >}}


with

{{< highlight bash >}}
sub vcl_recv {
        if (req.request == "PURGE") {
                if (!client.ip ~ purge) {
                        error 405 "Not allowed.";
                }
                ban("req.url ~ "+req.url+" && req.http.host == "+req.http.host);
                error 200 "Purged.";
        }
...
{{< / highlight >}}

Substituting "~ purge" with your ACL name, the above implement wild card purging aswell, if you do not want this and only want PURGE for the exact passed URL replace 

"req.url ~ "+req.url

with

"req.url == "+req.url

