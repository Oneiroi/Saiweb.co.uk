--- 
wordpress_id: 788
layout: post
title: "Linux Generating file manifests and then checking them Improved"
date: 2009-09-29 14:14:06 +01:00
tags: 
- linux
- sysadmin
- md5
- python
- manifest
- progress
- indication
- indicator
- cli
categories: 
- linux
- python
wordpress_url: https://saiweb.co.uk/linux/linux-generating-file-manifests-and-then-checking-them-improved
comments: true
---
Following on from <a href="https://www.saiweb.co.uk/linux/linux-generating-file-manifests-and-then-checking-them">Linux – Generating file manifests and then checking them</a> I was always getting the same questions ...

How long left on the manifest Buzz ?
How long left on the verification Buzz ?

And I <strong>HATE</strong> having to turn around an say ... I don't know ...

The problem with the usual command line method is that it give no indication of progress, and by extension no indication that it was infact running and not 'hung' ...

As such I have now added the 'manifest' command set to the <a href="https://www.saiweb.co.uk/sysadmin">Sysadmin toolset</a>

The manifest command take two data types, the first is a folder path from which to build the file manifest from, the manifest itself is also compatible with the "md5sum --check" function.

[FLOWPLAYER=https://content.screencast.com/users/D.Busby/folders/Jing/media/dd41bc92-17d3-4c34-8d46-80188f13aff2/00000337.mp4,900,300]

The second is the path to the manifest itself, in this case the manifest command will verify each file against it's entry in the manifest:

[FLOWPLAYER=https://content.screencast.com/users/D.Busby/folders/Jing/media/2d3eb196-87ef-4464-982b-5b9481c000fe/00000338.mp4,900,300]

At each point the command give you an indication of it's current status, however this does come at a small cost, the script has no concept of the size of you console and as such will always render out the same number of character meaning if you console is not wide enough it will not render correctly, in the videos I have the console on a high resolution monitor as can be seen each video itself is 900 pixels wide.

This process is CPU intensive (20-45% on one core of a intel core2duo 2.8GHZ) and uses around 140KB of memory.
