---
date: "2008-12-08T22:34:43Z"
tags:
- linux
title: cp -f prompting
wordpress_id: 338
wordpress_url: https://blog.oneiroi.co.uk/linux/cp-f-prompting
---
<img src="https://blog.oneiroi.co.uk/uploads/2008/12/chibi_angry_small.jpg" alt="So ... angry ... *rage*" title="chibi_angry_small" width="90" height="115" class="size-full wp-image-343" />

Another annoyance caused I suppose in an attempt to stop new linux users obliterating their installations within 5 minutes of install ...

I liken this to shouting widly at someone jamming their hand in a furnace wondering how long before the smell of burning flesh awakens them to the fact they are being just plain stupid ...

seems in this case the developers of RedHat and by extension CentOS have taken pity on what must be the "one armed masses" and started handing out the equivelent of "easy bake ovens" ...

{{< highlight bash >}}
cp -rf /src/folder/* /dest/folder/
cp: overwrite `/dest/folder/index.php'?
{{< / highlight >}}

Now the -f (force) flag should copy without prompting, it's the sysadmins equivelent of shouting at the bloody thing, but then the people with the "easy bake ovens" are at play and given this command the equivelent of "clippy" poping up asking are you sure with every **censored** copy, the reason it is still prompting is due to an alias ...

{{< highlight bash >}}
[root@test_srv /src/folder]# alias
alias cp='cp -i'
{{< / highlight >}}

What genius decided to make an optional flag run by default ?

-i is 'interactive' aka ALWAYS PROMPT, and evidently overrides -f 

To remove this:

{{< highlight bash >}}
unalias cp
{{< / highlight >}}

And if you're really paranoid, to put it back:

{{< highlight bash >}}
alias cp='cp -i';{{< / highlight >}}

