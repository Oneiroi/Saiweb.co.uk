--- 
wordpress_id: 908
layout: post
title: "ESP Ghostscript 815.02: Unrecoverable error, exit code 255"
date: 2010-07-26 11:46:16 +01:00
tags: 
- image
- magic
- imagick
- exit
- unrecoverable
- "255"
- ghostscript
categories: 
- linux
wordpress_url: https://blog.oneiroi.co.uk/linux/esp-ghostscript-815-02-unrecoverable-error-exit-code-255
comments: true
---
<strong>ESP Ghostscript 815.02: Unrecoverable error, exit code 255</strong>

I got this issue today whilst running CentOS 5.4 x64 post investigation of images not being scaled when processing a specific PDF, the solution unfortunately is to build ghostscript and imagemagick from the latest sources.

{% highlight bash %}
wget https://ghostscript.com/releases/ghostscript-8.71.tar.gz
wget https://image_magick.veidrodis.com/image_magick/ImageMagick-6.6.3-0.tar.gz
{% endhighlight %}

Unpack, configure, make && make install

To fix compatibility with pear imagick

{% highlight bash %}
ln -s /usr/local/lib/libMagickCore.so /usr/lib64/libMagick.so.10
ln -s /usr/local/lib/libMagickWand.so /usr/lib64/libWand.so.10
ln -s /usr/local/bin/gs /usr/bin/gs
{% endhighlight %}
