--- 
wordpress_id: 869
layout: post
title: Dissecting the hack - packed r57shell
date: 2010-05-26 12:00:46 +01:00
tags: 
- php
- python
- dissecting
- hack
- r57
- r57shell
categories: 
- hacking
- php
- python
wordpress_url: https://blog.oneiroi.co.uk/hacking/dissecting-the-hack-r57shell
comments: true
---
<span style="color: #ff0000;"><strong>Before you read any further note, I will not be including the original hack file, simply due to peoples stupidity in putting this on a production environment to play with, if you use the code you do so at your own risk, and by reading this blog entry / using the code provided you agree to accept all liability upon yourself for your own actions. Don't be an idiot.</strong></span>

Around 10 days ago I came across this seemingly innocuous little file.

What I am going to cover in this entry is dissecting the 'payload' and not so much the web app in question or methods used to compromise it,

Whereas I will not at this time provide the original file, I will provide you with the md5 and sha1 hashes of the file so you can check it's not lurking on your systems:

md5: 9ee3e6523d154114460d320477a8665a
sha1: 9c64fecea5620d70a716bbd74f6e89612a4a79c7

The bit we are interested in is the last line of the file:

{% highlight php %}
eval(gzinflate(base64_decode('DATA')));
{% endhighlight %}

Were you to run this line you would get

{% highlight php %}
eval(gzinflate(base64_decode('DATA2')));
{% endhighlight %}

<a href="https://blog.oneiroi.co.uk/uploads/2010/05/sense-this-picture-makes-none.jpg"><img src="https://blog.oneiroi.co.uk/uploads/2010/05/sense-this-picture-makes-none-240x300.jpg" alt="" title="sense-this-picture-makes-none" width="240" height="300" class="aligncenter size-medium wp-image-870" /></a>

Confused yet? now I can appreciate the thinking behind packing a payload to avoid detection, but in this case the payload is packed 12 times, and no before you ask I did not manually run each returned statement to find this out. 

Enter Python-Fu:

<a href="https://blog.oneiroi.co.uk/uploads/2010/05/getbritf.jpg"><img src="https://blog.oneiroi.co.uk/uploads/2010/05/getbritf-236x300.jpg" alt="" title="getbritf" width="236" height="300" class="aligncenter size-medium wp-image-871" /></a>


{% highlight python %}
#!/usr/bin/env python
# blog.oneiroi.co.uk payload unpack script 26/05/2010
# copy the eval(gzinflate()) line to payload.raw, place in same directory as this file.

"""
Copyright (C) 2010 Buzz blog.oneiroi.co.uk.co.uk

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
    
    Additional Terms as Per section 7

    Attribution:

    Redistribution/Reuse of this code is permitted under the GNU v3 license, as an additional term ALL code must carry the original Author(s) credit in comment form.
"""

import base64, zlib, re, sys

def main():
	print 'Running ...'
	f = open('payload.raw')
	php = f.read()
	f.close()
	iteration = 0
	while re.search('eval\(gzinflate\(base64_decode\(\'',php):
		iteration += 1
		print 'Iteration: %d' % iteration
		raw = re.sub('eval\(gzinflate\(base64_decode\(\'','',php)
		raw = re.sub('\'\)\)\);','',raw)
		
		gstring = base64.b64decode(raw.strip())
		php = zlib.decompressobj().decompress('x\x9c' + gstring)
		#print payload
		#sys.exit()
	print php
if __name__ == '__main__':
	main()
{% endhighlight %}

Copy the first payload lines into a file named payload.raw, take the above code and copy it into a file named dissect.py.

When dissect.py is run you will get the following output:

{% highlight bash %}
python ./dissect.py
Running ...
Iteration: 1
Iteration: 2
Iteration: 3
Iteration: 4
Iteration: 5
Iteration: 6
Iteration: 7
Iteration: 8
Iteration: 9
Iteration: 10
Iteration: 11
Iteration: 12
<?php
...
{% endhighlight %} 

As such you may want to run it using the following command:

{% highlight bash %}
python ./dissect.py > r57.php
{% endhighlight %}

<a href="https://blog.oneiroi.co.uk/uploads/2010/05/ggwit.jpg"><img src="https://blog.oneiroi.co.uk/uploads/2010/05/ggwit-257x300.jpg" alt="" title="ggwit" width="257" height="300" class="aligncenter size-medium wp-image-872" /></a>

And what you will find after unpacking 12 times in total, the "payload" is the r57shell, this script is an information gathering tool and pseudo shell, meaning it will run any command on the host server that php can, providing in most cases ssh esq access to the exploited host, allowing you to do pretty much anything you wanted at this point, some of the features also include /etc/passwd /etc/shadow dumping, aswell as searching for a tirade of common file *.sql* admin* etc, it's a one stop script for information gathering on a LAMP/WAMP based host.

<strong>
Defense: modify php.ini to disable eval(), exec, shell_exec and all none essential functions.
</strong>

And of course, ensure your web apps are patched and up to date as well as the host they are running on. 


