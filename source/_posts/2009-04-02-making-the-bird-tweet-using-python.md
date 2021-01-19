--- 
wordpress_id: 630
layout: post
title: Making the bird tweet using python
date: 2009-04-02 16:56:35 +01:00
tags: 
- twitter
- python
categories: 
- python
wordpress_url: https://blog.oneiroi.co.uk/python/making-the-bird-tweet-using-python
comments: true
---
After taking another look at Python I am quickly coming to love it, as an "exercise" in re-learning python I decided to write a very simple command line "tweeter" this uses the Twitter API to update your twitter status, extending from the "<a href="https://blog.oneiroi.co.uk/linux/update-twitter-in-a-single-line">update twitter in a single line</a>"

You can grab a copy of the script from here: <a href="https://svn.blog.oneiroi.co.uk/branches/python/tweet.py">https://svn.blog.oneiroi.co.uk/branches/python/tweet.py</a>

<strong>UPDATE 24/03/2011:</strong>Oauth version <a href="https://github.com/Oneiroi/nagios_addons/blob/master/twitter/nagios_bot.py">here</a>

Example usage:

{% highlight bash %}


./tweet.py -u username -p password -t your tweet goes here


{% endhighlight %}

If you want to parse the JSON data normally returned after submitting a new tweet simply add the -j flag.

If you are prompted for a username and password when running this script the username and password supplied using the -u and -p flags was incorrect.






