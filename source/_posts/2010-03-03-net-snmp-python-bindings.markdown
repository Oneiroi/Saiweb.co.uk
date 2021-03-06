--- 
wordpress_id: 833
layout: post
title: net-snmp python bindings
date: 2010-03-03 14:26:09 +00:00
tags: 
- python
- snmp
- net-snmp
- bindings
categories: 
- python
wordpress_url: https://blog.oneiroi.co.uk/python/net-snmp-python-bindings
comments: true
---
<strong>UPDATE 28/06/10:</strong> added --libdir=/usr/lib64 --enable-shared otherwise shared libs are not built at all!

Having spent a few hours trying to get this working on CentOS 5.4 x64 I am posting this blog entry for others to reference:

Download and complie net-snmp >= 5.4.2.1 <a href="https://net-snmp.sourceforge.net/">https://net-snmp.sourceforge.net/</a>

{% highlight bash %}./configure --with-python-modules --libdir=/usr/lib64 --enable-shared
make && make install
cd /path/to/net-snmp-src/python/
python ./setup.py build
python ./setup.py test{% endhighlight %}

You may get ImportError: libnetsnmp.so.20, this is due to x64 build creating as /usr/lib64/libnetsnmp.so.10

{% highlight bash %}ln -s /usr/lib64/libnetsnmp.so.10.0.3 /usr/lib64/libnetsnmp.so.20
python ./setup.py install{% endhighlight %}


And you are done, you can now use the netsnmp python bindings, I'd recomend seeing the examples here: <a href="https://www.ibm.com/developerworks/aix/library/au-netsnmpnipython/">https://www.ibm.com/developerworks/aix/library/au-netsnmpnipython/</a>
