---
date: "2010-02-01T11:41:58Z"
tags:
- uncategorized
title: '/bin/sh: bad interpreter'
wordpress_id: 816
wordpress_url: https://blog.oneiroi.co.uk/uncategorized/bin-sh-bad-interpreter
---
For security newer distros of RHEL and their derivatives an mounting /tmp with the noexec option.

Now if you have ever had to clean up a compromised web app you can see why this makes a lot of sense, and if not here's a quick example.

Yours/Clients web app becomes compromised, running kernel has a buffer overflow that can lead to privilege escalation, attack writes out their code and compiles in /tmp, then runs said app from /tmp creating a pseudo root level shell, aka you've just been root kitted.

However there are legitimate reasons for using /tmp to compile, well I say legitimate, what I in fact mean is things like pecl, which you use to install extensions like APC require this ...

workaround:

{{< highlight bash >}}
export TMPDIR='/a/paTh/your/user/can/write/to'
{{< / highlight >}}

Failing that:

<strong>service httpd stop</strong>

<strong>DO NOT ALLOW ANY WEBAPP ACCESS WHILE NOEXEC IS IN USE!</strong>

{{< highlight bash >}}
mount -o,remount,rw,exec /tmp
pecl install apc
mount -o,remount,rw,noexec /tmp
{{< / highlight >}}


<strong>DO NOT REMOVE THE NOEXEC OPTION IN /ETC/FSTAB PERMANENTLY YOU WILL REGRET DOING SO</strong>
