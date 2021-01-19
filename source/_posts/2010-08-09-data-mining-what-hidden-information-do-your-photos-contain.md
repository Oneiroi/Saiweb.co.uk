--- 
wordpress_id: 921
layout: post
title: Data Mining - What hidden information do your photos contain?
date: 2010-08-09 13:02:08 +01:00
tags: 
- exif
- jpeg
- gps
- data
- mining.
categories: 
- hacking
wordpress_url: https://blog.oneiroi.co.uk/hacking/data-mining-what-hidden-information-do-your-photos-contain
comments: true
---
Time was when a photo was just a captured moment in time, /end nostalgia

Nowadays though what people do not realize is the shear amount of "extra" information is embedded in "that picture you just uploaded to flikr/facebook/photo bucket" especially if you are uploading from a "smart phone" as more and more people are now.

Most photos now contain GPS data embedded in them, this information will survive a resize / upload process, at the time of writing images tested from Facebook appear to have the exif data stripped out (thumbs up for facebook maybe), and it appears php GD by default replaces all EXIF data with it's own (bug maybe?).

For non sanitized images however you can discern a wealth of information such as:
<ol>
	<li>Make of camera</li>
	<li>Model of camera</li>
	<li>Software version</li>
	<li>Unix timestamp of time taken</li>
	<li>DateTime stamp of time taken</li>
	<li>Focal length used</li>
	<li>Shutter speed</li>
	<li>if flash used</li>
</ol>
And if GPS is embedded:
<ol>
	<li>Longitude</li>
	<li>Latitude</li>
	<li>Altitude</li>
	<li>GPS timestamp</li>
	<li>Direction facing when photo taken</li>
</ol>
There is yet more data such as the colour profile used, and image resolutions, in my tests photos taken from my iPhone 4 were within 10 meters of where I was actually standing when I took the picture, and in which direction I was facing when I took them.

<strong>So one more thing to note in your applications "data sanity" is to strip EXIF tags from uploaded images, lest your contributors private details be leaked from your application.</strong>

For example:
<ol>
	<li>User uploads photo for competition</li>
	<li>Site uses resized photo on competition page to allow visitor voting</li>
	<li>malicious user, saves image from site (or just uses the copy from thier browser cache), gets gps data from photo</li>
	<li>malicious user now knows exact whereabouts photo was taken aswell as the time.</li>
</ol>
And it doesn't have to be a malicious user, it could be anyone/anything, if you want to check your images for EXIF data you can use my tool here: <a href="https://blog.oneiroi.co.uk/tools/exif_data.php">https://blog.oneiroi.co.uk/tools/exif_data.php</a>

No data is stored, and images are deleted immediately after processing, you use this at your own risk however, if you misuse the tool you accept all liability for the legal action to follow, you have been warned.
