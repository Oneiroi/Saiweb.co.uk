---
date: "2011-04-25T19:54:06Z"
tags:
- hacking
- linux
- security
title: Cloaking your web apps - The hooded Apache
wordpress_id: 1008
wordpress_url: https://blog.oneiroi.co.uk/hacking/cloaking-your-web-apps-the-hooded-apache
---
<p>Go ahead and run</p>
<p>{{< highlight bash >}}
curl -I https://blog.oneiroi.co.uk
{{< / highlight >}}</p>
<p>You will get </p>
<p>{{< highlight bash >}}
HTTP/1.1 200 OK
Date: Mon, 25 Apr 2011 19:33:29 GMT
Server: Apache
Vary: Accept-Encoding,Cookie
Cache-Control: max-age=3, must-revalidate
WP-Super-Cache: Served supercache file from PHP
Connection: close
Content-Type: text/html; charset=UTF-8
{{< / highlight >}}</p>
<p>As an attacker looking to hit a web app, one of the first things you're going to want to look into is what version of web server is running, in this case you can see this blog in fact runs apache ... but there is not much else to go on here is there.</p>
<p>That's intentional, and by manual configuration changes I have put in place, this is not the case of a default LAMP install, take for instance, this snippet from another website,</p>
<p>{{< highlight bash >}}
Server: Apache/2.2.16 (Debian)
X-Powered-By: PHP/5.2.14
{{< / highlight >}}</p>
<p>This already has given me a wealth of information to go on and begin prepping an attack, I now know the site is running php version 5.2.14 Apache version 2.2.16 and that the underlying OS is Debian.</p>

See the dilemma? your default roll outs are just declaring their running versions to anyone willing to listen, so lets make it a little more stealthy.

First and foremost if you are using php, edit your php.ini and set the following:

{{< highlight bash >}}
expose_php = off
{{< / highlight >}}

Now head into your httpd.conf and set the following

{{< highlight bash >}}
ServerTokens prod
{{< / highlight >}}

and

{{< highlight bash >}}
ServerSignature off
{{< / highlight >}}

With these 3 simple steps all the headers will now return is Server: Apache this is the first step to shielding your app, I'll be covering further steps as time allows.


