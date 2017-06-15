--- 
wordpress_id: 19
layout: post
title: PHP Security considerations, a quick reference for the newbies.
date: 2008-03-20 09:57:17 +00:00
tags: 
- php
- mysql
- sql
- injection
categories: 
- mysql
- php
- security
wordpress_url: https://saiweb.co.uk/mysql/php-security-considerations
comments: true
---
To often I get passed code to review that quite frankly is so full of holes it wouldn't make an adequate sieve...

So in this quick blog I outline a few simple and easily implemented steps to ensure as you start out in the world of PHP, your first site isn't hacked within 5 minutes, leaving you a whimpering wrek ...

<strong>PHP DON'T EXAMPLE 1:</strong>

Passing RAW globals to mysql!

i.e.

{% highlight bash %}$sql = "SELECT * FROM users WHERE email='.$_GET['email']."' and password='".$_GET['password']"';";
$result = mysql_query($sql);{% endhighlight %}

So what is wrong with the above? <strong><a title="SQL INject Wikipedia Entry" href="https://en.wikipedia.org/wiki/SQL_injection" target="_blank">SQL INJECTION</a> </strong>welcome to a world where people want to break your website, simply because they can ...

I am not going to add more description, just click through to the wiki pedia entry linked above ...

To avoid this PHP comes with two functions <a title="PHP mysql_escape_string()" href="https://www.php.net/mysql_escape_string" target="_blank">mysql_escape_string()</a> and <a title="PHP mysql_real_escape_string()" href="https://www.php.net/mysql_real_escape_string" target="_blank">mysql_real_escape_string()</a>

An example taken from the <a title="PHP mysql_real_escape_string()" href="https://www.php.net/mysql_real_escape_string" target="_blank">mysql_real_escape_string()</a> page:
<p class="example"><strong>Example#2 An example SQL Injection Attack</strong></p>

{% highlight bash %}<span style="color: #000000;"><span style="color: #0000bb;">&lt;?php
</span><span style="color: #ff8000;">// Query database to check if there are any matching users
</span><span style="color: #0000bb;">$query </span><span style="color: #007700;">= </span><span style="color: #dd0000;">"SELECT * FROM users WHERE user='{$_POST['username']}' AND password='{$_POST['password']}'"</span><span style="color: #007700;">;
</span><span style="color: #0000bb;">mysql_query</span><span style="color: #007700;">(</span><span style="color: #0000bb;">$query</span><span style="color: #007700;">);</span></span>{% endhighlight %}{% highlight bash %}<span style="color: #000000;"><span style="color: #007700;"> </span><span style="color: #ff8000;">// We didn't check $_POST['password'], it could be anything the user wanted! For example:
</span><span style="color: #0000bb;">$_POST</span><span style="color: #007700;">[</span><span style="color: #dd0000;">'username'</span><span style="color: #007700;">] = </span><span style="color: #dd0000;">'aidan'</span><span style="color: #007700;">;
</span><span style="color: #0000bb;">$_POST</span><span style="color: #007700;">[</span><span style="color: #dd0000;">'password'</span><span style="color: #007700;">] = </span><span style="color: #dd0000;">"' OR ''='"</span><span style="color: #007700;">;</span></span><span style="color: #007700;"><span style="color: #ff8000;">// This means the query sent to MySQL would be:
</span><span style="color: #007700;">echo </span><span style="color: #0000bb;">$query</span><span style="color: #007700;">;
</span><span style="color: #0000bb;">?&gt;</span></span>{% endhighlight %}
<p class="example-contents">The query sent to MySQL:</p>

{% highlight bash %}
{% highlight bash %}SELECT * FROM users WHERE user='aidan' AND password='' OR ''=''{% endhighlight %}
{% endhighlight %}
<p class="example-contents">This would allow anyone to log in without a valid password.</p>
<p class="example-contents">So in summary READ the <a title="PHP mysql_real_escape_string()" href="https://www.php.net/mysql_real_escape_string" target="_blank">mysql_real_escape_string()</a> page, and even if you don't implement the "best practice" example on that page PLEASE make sure you at least escape $_SESSION $_GET $_POST inputs with a mysql escape function!</p>
<p class="example-contents"></p>
<p class="example-contents"></p>
