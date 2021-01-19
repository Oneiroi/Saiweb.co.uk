--- 
wordpress_id: 1118
title: php mail() - Making it not suck using sendmail
date: 2011-09-18 12:22:46 +01:00
tags: 
- php
- mail
- sendmail
tags: 
- linux
- php
wordpress_url: https://blog.oneiroi.co.uk/linux/php-mail-making-it-not-suck-using-sendmail
---
Ok ok ... as some of the people work with are aware, I did this months ago fro one project, ment to blog and document it then in fact I have a draft post last modified 06/05/2011 covering full spam score reduction, and half finished instructions on setting up a mail relay ... so in the interim of finishing that post I'm going to cover improving user experience through proper php configuration.

Out of the box, php will use sendmail, and it will do so as follows.
<ol>
	<li>mail() forks sendmail process</li>
	<li>sendmail attempts to send email to destination server</li>
	<li>sendmail returns on send complete</li>
</ol>
<div>Generally this isn't a problem but what if at point 2. there is an issue with the destination MTA ? well in that case php will infact sit around waiting fot sendmail to complete, leaving your user with a hung screen / hung ajax call.</div>
<div>So what to do?</div>
<div>Simply put you want to offset the sending email process you do not want the end user sat around waiting for sendmail to finish sending the email, but you do want the email to send ... decisions ... decisions.</div>
<div>So edit yout php.ini .</div>


{% highlight bash %}sendmail_path = /usr/sbin/sendmail -t -i -O DeliveryMode=b{% endhighlight %}


This sets the delivery mode to background, sendmail will return to php near instantly and send the email in the background by placing in into a queue.


TL;DR

Put the above in your php.ini to not hang around to sendmail, and hav it return instantly.
