--- 
wordpress_id: 130
layout: post
title: ffmpeg MP4 does not stream qt-faststart
date: 2008-08-06 14:14:44 +01:00
tags: 
- ffmpeg
- qt-faststart
categories: 
- linux
wordpress_url: https://saiweb.co.uk/linux/ffmpeg-mp4-does-not-stream-qt-faststart
comments: true
---
ffmpeg comes with a tool to re-order the MP4 "atoms" (Seriously don't ask  what are MP4 atoms it's geek for the sake of geek).

find the file in ffmpeg_src/tools/qt-faststart.c

compile with gcc

{% highlight bash %}
gcc qt-faststart.c -o qt-faststart
{% endhighlight %}

And run.

{% highlight bash %}
/path/to/qt-faststart /path/to/src_vid.mp4 /path/to/output.mp4
{% endhighlight %}

NOTE: This only seems to work for h264 encoded videos (libx264).
