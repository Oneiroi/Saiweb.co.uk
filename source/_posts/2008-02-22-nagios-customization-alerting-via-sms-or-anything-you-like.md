--- 
wordpress_id: 6
layout: post
title: "Nagios customization: Alerting via SMS, or anything you like!"
date: 2008-02-22 13:28:13 +00:00
tags: 
- nagios
- linux
- networking
- customization
- sms
- php
- txt
- text
- mobile
- phone
- alerting
categories: 
- nagios
- networking
- linux
wordpress_url: https://blog.oneiroi.co.uk/nagios/nagios-customization-alerting-via-sms-or-anything-you-like
comments: true
---
So I find myself needing to tweak my <a href="https://www.nagios.org/" title="Nagios" target="_blank">Nagios</a> installation a little bit, in this case I found the need for "out of hours" SMS alerts.

<a href="https://www.nagios.org/" title="Nagios" target="_blank">Nagios</a> doesn't cater for this natively, rather it does however allow you to create your own custom commands, this allows you to specify a script to be executed.

Now I am going to assume you are already quite familiar with <a href="https://www.nagios.org/" title="Nagios" target="_blank">Nagios</a> , so here is the command definition from my installation.

<font color="#c0c0c0">
</font>

<p align="left"><font color="#3366ff"> # 'alert-by-sms' command definition
</font><font color="#3366ff"> define command{
</font><font color="#3366ff"> command_name    alert-by-sms
</font><font color="#3366ff"> command_line    /etc/nagios/alert-by-sms.php "** $NOTIFICATIONTYPE$ alert - $HOSTALIAS$/$SERVICEDESC$ is $SERVICESTATE$ **"
</font><font color="#3366ff"> }</font>

As you can see all this command definition realy does is execute a php script, bear in mind that

"/path/to/php /path/to/script "

as the command_line does not seem to work, so just add "#!/path/to/php -q" to the top of the php script (before the opening &lt;?PHP tag). and CHMOD +X the file.

The php script used here takes $argv[1] and passes it into a function specific to the SMS api I use, the phone number and API definitions are hard coded ito the script.
You don't really need me to upload my script, and if you do then you shouldn't be attempting this ...

Basically <a href="https://www.nagios.org/" title="Nagios" target="_blank">Nagios</a> will execute the script, as defined at command_line, the script can do anything you choose.

Now to implement the command so it is actually used, I am pretty sure this entry in "timeperiods.cfg" is the default but just incase here it is.

<font color="#3366ff"># 'nonworkhours' timeperiod definition
define timeperiod{
timeperiod_name nonworkhours
alias           Non-Work Hours
sunday          00:00-24:00
monday          00:00-09:00,17:00-24:00
tuesday         00:00-09:00,17:00-24:00
wednesday       00:00-09:00,17:00-24:00
thursday        00:00-09:00,17:00-24:00
friday          00:00-09:00,17:00-24:00
saturday        00:00-24:00
}</font>

This is what I use for the "out of hours" definition, now to implement the SMS alerting, for this I have simply created a new contact definition in "contacts.cfg", granted this means there are now two contact definitions for myself.

<font color="#3366ff">define contact{
contact_name                    out_of_hours
alias                           Out Of Hours Mobile</font>

<font color="#3366ff">service_notification_period     nonworkhours
host_notification_period        nonworkhours
service_notification_options    c,u,r,f
host_notification_options       d,u,r
service_notification_commands   alert-by-sms
host_notification_commands      alert-by-sms
email                          you.email@here.com</font>

<font color="#3366ff">}</font>

This can be further customized depending on your setup, in this case the contact is me and I want to receive alerts for all servers &amp; services, so I just add the contact  "out_of_hours" into the admins contact group.

<font color="#3366ff">define contactgroup{
contactgroup_name       admins
alias                   Nagios Administrators
members                 nagios-admin,out_of_hours
}</font>

So there you have it, you now have the ground work to potentially make <a href="https://www.nagios.org/" title="Nagios" target="_blank">Nagios</a> fire you alerts anyway you like, you could go as far as having it call you via attached modem, if you _realy_ want, but when you want your servers talking to you via phone call is the day you need to switch to decaff, and head out to the pub once in a while.

Now just "nagios -v /path/to/nagios.cfg" to do a quick sanity check and make sure there are no errors (if you have any go back and fix them and run nagios -v again!), if all is ok /etc/init.d/nagios restart (or equivalent for your distribution).

As always if you run into problems drop me a comment :-)
