--- 
wordpress_id: 696
layout: post
title: Converting mySQL latin1 to utf8
date: 2009-07-14 08:46:02 +01:00
tags: 
- mysql
- sysadmin
- utf-8
- utf8
- iconv
- multibyte
- latin1
- latin-1
- convert
- converting
- mysqldump
categories: 
- mysql
wordpress_url: https://saiweb.co.uk/mysql/converting-mysql-latin1-to-utf8
comments: true
comments: true
---
<ul>
<strong>The problem</strong></ul>


We've all been in this position at some point, working for a company who wants to internationalize their website, and so their mySQL CMS data ...

But all is not so well as just using 'SET NAMES utf8' and changing all 'charset' on tables to utf8,

You may fall foul of seeing content like &#193;&pound;

This is due to the fact in this case the latin1 encoded £ has not properly been converted to utf8 and as such is not rendering correctly, this is true of most 'multibyte' characters.

<ul>
<strong>The solution</strong></ul>

What you need to do is actually convert the character set to utf8, in order to do this your going to need to run it through a program you could use iconv if you are already familiar with it, however if your system has python installed you can grab a copy of my <a href="https://www.saiweb.co.uk/sysadmin">sysadmin</a> program which has iconv like functionality but is far more user friendly.

<ul>
<strong>What you will need</strong></ul>

<ul>
	<li>Text Editor (vi/nano/pico/emacs)</li>
	<li>Python 2.4 or higher</li>
	<li><a href="https://linux.about.com/od/commands/l/blcmdl1_sed.htm">SED</a> package</li>
	<li><a href="https://www.saiweb.co.uk/sysadmin">Sysadmin program</a></li>
	<li>mySQL</li>
</ul>

<ul>
<strong>Preparing the file</strong></ul>

This assumes the database is currently using latin1, in theory this could be any encoding.

Get a dump of the database:

{% highlight bash %}
mysqldump --set-character-set=latin-1 --set-charset -u user -pPASSWORD databasename > databasename-latin1.sql
{% endhighlight %}

Now you have to be aware of what you need to replace using SED, you can't just replace all instances of 'latin1' as <a href="https://en.wikipedia.org/wiki/Murphy%27s_law">Murphy's law</a> being as it is means that somewhere there will be 'latin1' in the physical content, especially for instance if I was using a mysql dump from this blog.

As such you need to replace the following:

{% highlight bash %}
/*!40101 SET NAMES latin1 */;
{% endhighlight %}

If your database dump is small enough (sub 100mb) you can edit this line directly in your text editor, alternatively you can do the following.

{% highlight bash %}
cat ./databasename-latin1.sql | sed 's/SET NAMES latin1/SET NAMES utf8/g' > tmp
cat ./tmp > ./databasename-latin1.sql
rm -f ./tmp
{% endhighlight %}

Now you need to replace all instances of 'CHARSET=latin1'

{% highlight bash %}
cat ./databasename-latin1.sql | sed 's/CHARSET=latin1/CHARSET=utf8/g' > tmp
cat ./tmp > ./databasename-latin1.sql
rm -f ./tmp
{% endhighlight %}

Now we have to run the file through the charset converter

{% highlight bash %}
sysadmin -c iconv -d ./databasename-latin1.sql,latin-1,utf-8
{% endhighlight %}

If your sql dump is over 30mb, you will be prompted to confirm you wish to proceed, please remember that this will load the entire file into memory, so ensure you have enough available system memory before proceeding, I also suggest not running this on a production server.

If any characters could not be converted you will be alerted to their exact position within the file, from there you will either need to use sed to replace the character or use your text editor.

If all went well you now have ./databasename-latin1.sql.utf-8 (note the utf-8 extension), you now have a complete utf8 mySQL dump, all you need do now is import the dump.

<strong><ul>Further reading</ul></strong>

<ol>
	<li><a href="https://www.saiweb.co.uk/mysql/mysql-forcing-utf-8-compliance-for-all-connections">Force mySQL utf8 connections</a></li>
	<li><a href="https://www.saiweb.co.uk/mysql/mysql-bash-backup-script">mySQL backup script</a></li>
</ol>
