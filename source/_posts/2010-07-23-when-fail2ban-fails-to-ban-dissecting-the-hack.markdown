--- 
wordpress_id: 900
layout: post
title: When fail2ban fails to ban - Dissecting the hack
date: 2010-07-23 10:23:52 +01:00
tags: 
- force
- dissecting
- hack
- fail2ban
- brute
categories: 
- hacking
- linux
wordpress_url: http://saiweb.co.uk/hacking/when-fail2ban-fails-to-ban-dissecting-the-hack
comments: true
---
Most of the time when I review our log watches each morning I become enraged at the number of automated attacks,

But ever so occasional I find one that frankly intrigues me.

Today is just such an occasion where I have had multiple Brute force login attempts, the ingenious part is this attack has been designed to bypass tools such as fail2ban, blockhosts etc, and this is how
<ol>
	<li>Attack is launched from <strong>XXX.XXX.XXX.XXX</strong></li>
	<li><strong></strong> has PTR set for <strong>sub.domain.tld</strong></li>
	<li>Failed login attempts record <strong>sub.domain.tld</strong> due to reverse lookup</li>
	<li>There is no A record, attacker maintains their own nameservers for the <strong>domain.tld</strong></li>
	<li>fail2ban notes failed logins, attempts to resolve <strong>sub.domain.tld</strong> to an IP but fails, due to missing A record</li>
	<li> Attacker can continue brute force attempts unhindered by being banned</li>
</ol>
I am still reading into how to counter this and will update this post as I figure out how to work around it, it's a very sneaky and frankly quiet clever method of working around most automated blacklisting/banning tools.

<strong>Update 1:</strong>
One method I am trialing is the "log target" feature of iptables, in an attempt to match login failure times to the iptables log, I'll post back with results.

{% highlight bash %}
iptables -A INPUT -p tcp --dport ftp -j LOG
{% endhighlight %}

Outputs

{% highlight bash %}
Jul 23 11:45:57 132 kernel: IN=eth0 OUT= MAC=<mac addr> SRC=<connecitng ip> DST=<server ip> LEN=64 TOS=0x00 PREC=0x00 TTL=55 ID=47423 DF PROTO=TCP SPT=3865 DPT=21 WINDOW=65535 RES=0x00 SYN URGP=0 
Jul 23 11:45:57 132 kernel: IN=eth0 OUT= MAC=<mac addr> SRC=<connecitng ip> DST=<server ip> LEN=52 TOS=0x00 PREC=0x00 TTL=55 ID=45370 DF PROTO=TCP SPT=3865 DPT=21 WINDOW=65535 RES=0x00 ACK URGP=0 
Jul 23 11:45:57 132 kernel: IN=eth0 OUT= MAC=<mac addr> SRC=<connecitng ip> DST=<server ip> LEN=52 TOS=0x00 PREC=0x00 TTL=55 ID=46896 DF PROTO=TCP SPT=3865 DPT=21 WINDOW=65535 RES=0x00 ACK URGP=0 
Jul 23 11:46:01 132 kernel: IN=eth0 OUT= MAC=<mac addr> SRC=<connecitng ip> DST=<server ip> LEN=63 TOS=0x00 PREC=0x00 TTL=55 ID=38502 DF PROTO=TCP SPT=3865 DPT=21 WINDOW=65535 RES=0x00 ACK PSH URGP=0 
Jul 23 11:46:02 132 kernel: IN=eth0 OUT= MAC=<mac addr> SRC=<connecitng ip> DST=<server ip> LEN=52 TOS=0x00 PREC=0x00 TTL=55 ID=32551 DF PROTO=TCP SPT=3865 DPT=21 WINDOW=65535 RES=0x00 ACK URGP=0 
Jul 23 11:46:02 132 kernel: IN=eth0 OUT= MAC=<mac addr> SRC=<connecitng ip> DST=<server ip> LEN=52 TOS=0x00 PREC=0x00 TTL=55 ID=59735 DF PROTO=TCP SPT=3865 DPT=21 WINDOW=65535 RES=0x00 ACK URGP=0 
Jul 23 11:46:04 132 kernel: IN=eth0 OUT= MAC=<mac addr> SRC=<connecitng ip> DST=<server ip> LEN=66 TOS=0x00 PREC=0x00 TTL=55 ID=23116 DF PROTO=TCP SPT=3865 DPT=21 WINDOW=65535 RES=0x00 ACK PSH URGP=0 
Jul 23 11:46:07 132 kernel: IN=eth0 OUT= MAC=<mac addr> SRC=<connecitng ip> DST=<server ip> LEN=52 TOS=0x00 PREC=0x00 TTL=55 ID=40246 DF PROTO=TCP SPT=3865 DPT=21 WINDOW=65535 RES=0x00 ACK URGP=0 
{% endhighlight %}

<strong>Update 2: Defeating the hack</strong>

Now granted this would be a lot worse had the attacking IP been dynamic, fortunatly in this case it's not

{% highlight bash %}
grep kernel /var/log/messages | awk '{print $9}' | sed 's/SRC=//' | uniq -c | sort
{% endhighlight %}

{% highlight bash %}
390   173.XXX.XXX.XXX
      4 195.XXX.XXX.XXX
{% endhighlight %}

Ip's have been masked to prevent anyone complaining or threatening legal action (again) for inferring you should block their ip / network range ... and me firing off the obligatory "Well if you policed your own network I wouldn't have to post this no would I" email, 

Maybe I am just being Cynical in my "old" age ...

Any how as you may have guess I'm black holing the ip with the 390 connection entries.

<strong>Thanks</strong>

Being as I spoke to a load of people during the course of this I realy can not remember who contributed what to this solution, so I'll just have to thank you all let me know if you want a crediting link.



