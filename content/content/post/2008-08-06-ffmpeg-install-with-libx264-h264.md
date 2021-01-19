---
date: "2008-08-06T09:04:12Z"
tags:
- linux
title: ffmpeg install with libx264 (h264)
wordpress_id: 122
wordpress_url: https://blog.oneiroi.co.uk/linux/ffmpeg-install-with-libx264-h264
---
The information for this is VERY very sparse, so here is a summary of what I have found.

<b><u>Install libx264</u></b>

Get the libx264 package from here: <a href="https://www.videolan.org/developers/x264.html">https://www.videolan.org/developers/x264.html</a>

Extracts the bz2 file 

{{< highlight bash >}}
tar -xjvf /path/to/x264-snapshot-20080805-2245.tar.bz2
{{< / highlight >}}

And now the useual

{{< highlight bash >}}
cd /path/to/x264-dir
./configure --enable-shared
make
make install
ldconfig
{{< / highlight >}}

Get a nice error message:

{{< highlight bash >}}
[root@dev01 x264-snapshot-20080805-2245]# ./configure
No suitable assembler found.  Install 'yasm' to get MMX/SSE optimized code.
If you really want to compile without asm, configure with --disable-asm.
{{< / highlight >}}

You do want MMX/SSE at somepoint for the time being I am disabling this though (lack of time to find a valid RHEL source). so I added the disable asm line.

<b><u>Install ffmpeg</u></b>

For this I use subversion.

{{< highlight bash >}}
cd /path/to/where/I/want/sources
svn checkout svn://svn.mplayerhq.hu/ffmpeg/trunk ffmpeg
cd /path/to/where/I/want/sources/ffmpeg
./configure --enable-libx264 --enable-gpl --enable-shared
make
make install
{{< / highlight >}}

et voila ffmpeg is now installed with libx264 (h264).

<hr />

<u><b>error while loading shared libraries: libavdevice.so.52: cannot open shared object file: No such file or directory</b></u>

To fix this:

{{< highlight bash >}}
vi /etc/ld.so.conf.d/custom-libs.conf
{{< / highlight >}}

Add the line : /usr/local/lib

And run ldconfig.

<b>UPDATE: </b> I am writing a full set of notes blog entry for installing ffmpeg with codecs on RHEL4
