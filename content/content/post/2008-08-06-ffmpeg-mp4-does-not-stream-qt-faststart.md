---
date: "2008-08-06T14:14:44Z"
tags:
- linux
title: ffmpeg MP4 does not stream qt-faststart
wordpress_id: 130
wordpress_url: https://blog.oneiroi.co.uk/linux/ffmpeg-mp4-does-not-stream-qt-faststart
---
ffmpeg comes with a tool to re-order the MP4 "atoms" (Seriously don't ask  what are MP4 atoms it's geek for the sake of geek).

find the file in ffmpeg_src/tools/qt-faststart.c

compile with gcc

{{< highlight bash >}}
gcc qt-faststart.c -o qt-faststart
{{< / highlight >}}

And run.

{{< highlight bash >}}
/path/to/qt-faststart /path/to/src_vid.mp4 /path/to/output.mp4
{{< / highlight >}}

NOTE: This only seems to work for h264 encoded videos (libx264).
