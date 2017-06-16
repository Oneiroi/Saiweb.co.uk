--- 
wordpress_id: 128
layout: post
title: ffmpeg installation on RHEL 4
date: 2008-08-06 11:28:59 +01:00
tags: 
- ffmpeg
- h264
- libx264
- rhel4
- faac
- faad2
- lame
- libogg
- libtheora
- libvorbis
- xvid
categories: 
- linux
wordpress_url: https://blog.oneiroi.co.uk/linux/ffmpeg-installation-on-rhel-4
comments: true
---
Just try to find documentation on this ... absolute nightmare is an understatement, so here are my notes of the steps I took to compile ffmpeg with a selection of codecs:

{% highlight bash %}
up2date automake autoconf libtool
wget https://downloads.sourceforge.net/faac/faac-1.26.tar.gz
wget https://downloads.sourceforge.net/faac/faad2-2.6.1.tar.gz
wget https://superb-west.dl.sourceforge.net/sourceforge/lame/lame-3.98b6.tar.gz
wget https://downloads.xiph.org/releases/ogg/libogg-1.1.3.tar.gz
wget https://downloads.xiph.org/releases/theora/libtheora-1.0beta2.tar.gz
wget https://downloads.xiph.org/releases/vorbis/libvorbis-1.2.0.tar.gz
wget https://downloads.xvid.org/downloads/xvidcore-1.1.3.tar.gz
wget ftp://ftp.videolan.org/pub/videolan/x264/snapshots/x264-snapshot-20080805-2245.tar.bz2
{% endhighlight %}

<b><u>NOTE:</u></b> The above are current at the time of writing, check for more recent versions at the relevant sites.

Extract:

{% highlight bash %}
 for i in *.tar.gz; do tar -xzvf "$i"; done
 for i in *.tar.bz2; do tar -xjvf "$i"; done
{% endhighlight %}

cd to relevant directories and run the following:

faac &amp; faad2:  ./bootstrap &&amp; ./configure &&amp; make &&amp; make install
xvidcore: cd build/generic; ./configure &&amp; make &&amp; make install
libx264: ./configure --enable-shared --disable-asm &&amp; make &&amp; make install
The rest: ./configure &&amp; make &&amp; make install

<b>NOTE:</b> You must install libogg prior to libvorbis and libtheora

The following is required otherwise ffmpeg will display errors about being unable to find libraries:

i.e.

{% highlight bash %}
ffmpeg: error while loading shared libraries: libavdevice.so.52: cannot open shared object file
{% endhighlight %}

FIX: 

{% highlight bash %}
echo '/usr/local/lib' > /etc/ld.so.conf.d/buzz-saiweb.conf
ldconfig
{% endhighlight %}

You must run "ldconfig" any time you install a new lib you want to use with ffmpeg!

<b><u>Install FFMPEG</u></b>
{% highlight bash %}
svn checkout svn://svn.mplayerhq.hu/ffmpeg/trunk ffmpeg

./configure --enable-libmp3lame --enable-libvorbis --enable-libxvid --enable-shared --enable-libfaac --enable-libfaad --enable-gpl --enable-libtheora --enable-libx264

make

make install
{% endhighlight %}


<b>NOTE:</b> If you allready havea checkout of ffmpeg and run an update to get the latest code, make sure you run

{% highlight bash %}
make distclean
{% endhighlight %}

Prior to running the configure line.

et voila job done ....
