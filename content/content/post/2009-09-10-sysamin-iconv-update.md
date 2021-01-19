---
date: "2009-09-10T10:40:59Z"
tags:
- linux
title: Sysamin - iconv update
wordpress_id: 777
wordpress_url: https://blog.oneiroi.co.uk/linux/sysamin-iconv-update
---
I had a major issue facing the iconv functionality of the <a href="https://blog.oneiroi.co.uk/sysadmin">sysadmin toolset</a> namely due to rushed coding.

When loading a file to be re-encoded the entire file was loaded into the buffer, encoded as whole and written out to the new file, this of course meant the  memory usage was roughly double the size of the file to be converted plus any overheads to do with the encoding itself.

Today I had need to convert a 1.3GB sql file, needles to say the script was crashing out with a memory error.

As such I have now completely re-written the function it now processes the file in 1kb 'chunks', moving the load to the CPU, this process is now very cpu intensive the the memory overhead is minimal (during test processed the 1.3GB file using 113kb of memory!!!).

[FLOWPLAYER=https://blog.oneiroi.co.uk/uploads/2009/09/sysadmin-iconv.mp4,487,417]

Also I have now added BOM (Byte order mark) detection:

[FLOWPLAYER=https://blog.oneiroi.co.uk/uploads/2009/09/sysadmin_oconv_bom.mp4,515,473]
