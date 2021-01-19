--- 
wordpress_id: 968
title: "matplotlib ImportError: No module named ma"
date: 2010-10-15 15:07:12 +01:00
tags: 
- mac
- osx
- matplotlib
- ma
- "no"
- module
- named
tags: 
- mac
- python
wordpress_url: https://blog.oneiroi.co.uk/mac/matplotlib-importerror-no-module-named-ma
---
ImportError: No module named ma

Fix is to edit the following files:

{% highlight bash %}sudo vi /Library/Python/2.6/site-packages/matplotlib-0.91.1-py2.6-macosx-10.6-universal.egg/matplotlib/numerix/ma/__init__.py
sudo vi /Library/Python/2.6/site-packages/matplotlib-0.91.1-py2.6-macosx-10.6-universal.egg/matplotlib/numerix/npyma/__init__.py{% endhighlight %}

On my installed on lines 16 and 7 respectively replace


{% highlight python %}
from numpy.core.ma import *
{% endhighlight %}

with

{% highlight python %}
from numpy.ma import *
{% endhighlight %}

and done.
