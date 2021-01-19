--- 
wordpress_id: 766
title: Generating file manifests and then checking them
date: 2009-09-07 10:50:26 +01:00
tags: []

tags: 
- linux
- bash-script
wordpress_url: https://blog.oneiroi.co.uk/linux/linux-generating-file-manifests-and-then-checking-them
---
This issue has come about whilst having to migrate a positively huge number of files, and have to check the integrity of the transfer.

<strong>Build the manifest</strong>

{% highlight bash %}
find /path/to/folder -type f -print0 | xargs --null md5sum > /path/to/manifest
{% endhighlight %}
<ul>
	<li>-type f : This flag tells find to only return files</li>
	<li>-print0: This flag tells find to null terminate strings, this allows us to take files with spaces</li>
	<li>--null: This flag tells xargs to accept null terminated strings</li>
	<li><strong>NOTE: PUT THE MANIFEST OUTSIDE THE FOLDER YOU ARE INDEXING!</strong></li>
</ul>
<strong>Checking the manifest</strong>

{% highlight bash %}
md5sum --check /path/to/manifest | grep FAILED
{% endhighlight %}

The above will return all failed checks, if you want a simple count (maybe for automated reporting) just add  | wc -l

<strong>FAQ</strong>

<span style="text-decoration: underline;">How big is the manifest?</span>

This depends entirely on the length of your filepaths, taking UTF-8 as an encoding example each char is 8bits or 1byte, each manifest line consists of the md5hash, a space and the filepath as the filepath length varies there is no exact way to estimate the filesize of the manifest.

However each line is always 32 + 1 + len(path) bytes.

The more sub directories you have the larger the manifest size will be.

<span style="text-decoration: underline;">How long does the manifest take to build?</span>

This depends on the number of files you have to index, along with any other factors such as network shares, in test runs 2819 files indexed in 1.493 seconds.
