--- 
wordpress_id: 1129
title: "Linux collection of handy scripts and one liners \xE2\x80\x93 Volume 2 (Warning: contains shortcuts)"
date: 2011-09-26 15:43:34 +01:00
tags: 
- linux
- lhol
- one
- liners
tags: 
- linux
wordpress_url: https://blog.oneiroi.co.uk/linux/linux-collection-of-handy-scripts-and-one-liners-volume-2-warning-contains-shortcuts
---
<strong>See if hosts are up using ping in range 60 -> 200</strong>

{% highlight bash %}
for i in {60..200}; do ping -c 1 -W 1 192.168.1.$i > /dev/null; ([[ $? == 0 ]] && echo "$i UP" || echo "$i DOWN");  done
1 UP
2 DOWN
3 UP
...
{% endhighlight %}

Note: for OSX use "ping -c 1 -t 1"

<strong>Chaining "UP" hosts for a quick (syn) port scan</strong>

{% highlight bash %}
for i in {60..200}; do ping -c 1 -W 1 192.168.1.$i > /dev/null; ([[ $? == 0 ]] && nc -v -n -z -w1 192.168.1.$i 20-22); done
(UNKNOWN) [192.168.1.1] 22 (ssh) open
(UNKNOWN) [192.168.1.3] 22 (ssh) open
{% endhighlight %}

<strong>Recover from a bad mysql password set (Update mysql.users set password='Iforgotawherestatemenlulz')</strong>

Assumes for every user there is an @localhost host, grabs the in memory password hash and resets 
{% highlight bash %}

mysql -Bse 'Select distinct(user) from mysql.user;' | while read uname; do mysql -Bse "show grants for '$uname'@'localhost';" 2>&1 | grep IDENTIFIED | grep -v 'root' | grep -v 'ERROR' | sed 's|GRANT USAGE ON *.* TO ||g' | sed "s|@'localhost' IDENTIFIED BY PASSWORD||g" | awk '{print "Update user set Password="$2" where User="$1";"}' | mysql mysql; done
{% endhighlight %}

If you've run FLUSH PRIVILEGES; however you == b0ned.

<strong>Quick substitute and run</strong>

Command1:

{% highlight bash %}
ping -c 1 -t 1 192.168.1.1
{% endhighlight %}
Opps that's OSX synatx 

Command2:
{% highlight bash %}
^-t 1^-W 1
{% endhighlight %}
et voila corrected syntax.

<strong>Shortcuts</strong>

!! - Execute last command
!ping - Execute last ping command, can be used to !any command just be careful.
ctrl+r - reverse search, just start typing the cmd for it to search your history, hit tab to complete
ctrl+a - jump to beginning of line
ctrl+e - jump to end of the line

<strong>cURL FU</strong>

curl -I -L blahblah.tld - Run a HEAD and follow redirects (very handy for quicklooking @ bit.ly short URLS before hitting them in a browser).

<strong>python FU</strong>

python -m SimpleHTTPServer - serves the current `pwd` as a browseable directory (Very cool but VERY insecure)
python -m cProfile script.py - generate trace stats for a script execution (Very handy for finding excessive loops)

<strong>DNS Fu</strong>

Wikipedia over DNS:

host -t txt fu.wp.dg.cx

fu.wp.dg.cx descriptive text "Fu may refer to: Fu (Technology, especially computer related) (used as a suffix) - relating to a person - Possessing superior skills in an art\; relating to an artifact - representing an expression of high art. code-fu, Perl-fu, C-fu, etc, Fu (literature)," " a Chinese genre of rhymed prose, Fu (kana), a symbol in Japanese syllabaries, Fu County, in Shaanxi, China, Fu Foundation... https://a.vu/w:Fu"

Useful on _some_ public wifi connections if you just want to look something up quick (dns is not always re-written).

Get all MX servers for a domain:

dig google.co.uk MX

; <<>> DiG 9.6.0-APPLE-P2 <<>> google.co.uk MX
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 64165
;; flags: qr rd ra; QUERY: 1, ANSWER: 4, AUTHORITY: 4, ADDITIONAL: 4

;; QUESTION SECTION:
;google.co.uk.			IN	MX

;; ANSWER SECTION:
google.co.uk.		10800	IN	MX	10 google.com.s9a1.psmtp.com.
google.co.uk.		10800	IN	MX	10 google.com.s9a2.psmtp.com.
google.co.uk.		10800	IN	MX	10 google.com.s9b1.psmtp.com.
google.co.uk.		10800	IN	MX	10 google.com.s9b2.psmtp.com.

;; AUTHORITY SECTION:
google.co.uk.		59925	IN	NS	ns2.google.com.
google.co.uk.		59925	IN	NS	ns3.google.com.
google.co.uk.		59925	IN	NS	ns4.google.com.
google.co.uk.		59925	IN	NS	ns1.google.com.

;; ADDITIONAL SECTION:
ns1.google.com.		158334	IN	A	216.239.32.10
ns2.google.com.		158334	IN	A	216.239.34.10
ns3.google.com.		158741	IN	A	216.239.36.10
ns4.google.com.		158334	IN	A	216.239.38.10

;; Query time: 68 msec
;; SERVER: 
;; WHEN: Mon Sep 26 16:41:26 2011
;; MSG SIZE  rcvd: 310

<strong>mySQL FU</strong>

in one line, take a database, in stream replace content and stream into another db.

mysqldump original_db | sed 's/content_or_regex_to_replace/content_or_backref_replacement/g' | mysql destination_db
