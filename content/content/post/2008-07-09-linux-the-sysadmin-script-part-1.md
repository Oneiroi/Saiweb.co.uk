---
date: "2008-07-09T16:10:47Z"
tags:
- linux
- bash-script
title: Linux - The sysadmin script - Part 1
wordpress_id: 76
wordpress_url: https://blog.oneiroi.co.uk/linux/linux-the-sysadmin-script-part-1
---
Prompted by the following remarks today ...

<a href="https://www.absolutech.co.uk">Kerm</a>: <em>";) there is always an abbreviation in the CLI as all sysadmins are lazy feckers"</em>

<em><a href="https://www.absolutech.co.uk">Kerm</a>: "Someone might think you actually do work occasionally, god forbid!"</em>

Sysadmins are <strong><span style="text-decoration: underline;">NOT</span></strong> inherently lazy, we just know how to save time, and are quite adept at doing so ...ok?

<strong>You cheeky sods!</strong>

So let me clear up one instance in which I take a lot of information, and make it quickly and easily accessible using a "<em>Lazy feckers</em>" abbreviation ...

<span style="text-decoration: underline;"><strong>Be warned this is a very jaded write up, read on at your own peril.</strong></span>

Right then, onto the point of this post, the sysadmin script part 1, this is going to cover how to check how many connections to a specific port you have on your server.

Trust me this becomes very useful when you have exhausted all other options when trying to figure out why your web server is running like a dog with no legs ...

{{< highlight bash >}}
netstat -ant
{{< / highlight >}}

After running the above on your SSH session you will see lines, and lines ... and yet more lines of network connection information, especially if you just run this on a busy server.

Example (colours added):

<span style="color: #ff0000;">tcp</span> <span style="color: #009900;">0</span> <span style="color: #ffcc00;">0</span> <span style="color: #00cccc;">***.***.***.***:25</span> <span style="color: #6633ff;">***.***.***.***:32794</span> <span style="color: #666666;">ESTABLISHED</span>

Key:

<span style="color: #ff0000;">PROTOCOL</span> <span style="color: #009900;">Tx</span> <span style="color: #ffcc00;">Rx</span> <span style="color: #00cccc;">LOCALHOST:PORT</span> <span style="color: #6633ff;">FOREIGN_HOST:PORT </span> <span style="color: #666666;">CONNECTION STATE</span>

From this information it's pretty easy to spot this is an inbound SMTP connection.

(If you can't see why, don't worry it's ok maybe it's <a href="https://www.theregister.co.uk/2008/07/04/bofh_2008_episode_24/">genetic</a>)

Now this may be handy, but other than taking all this information and dumping it into a spreadsheet (god knows you love those spreadsheets !!! ), how are you going to figure out how many connections are occurring from that external host?

How infact are you going to be able to easily see how many total connections to that port you have ?!?!

Bash script, now for some history, Bash is the Bourne Again Shell, or as I like to think of it, it is the verb for what I will do to your head if you ask me what BASH / SSH / Shell is again ...

Now create a directory:

{{< highlight bash >}}
mkdir ~/.sysadmin
cd ~/.sysadmin
{{< / highlight >}}

Note the prefixing dot, this will create a "hidden" directory in your home directory (~), the reason for this is so you don't have system admin script sat in your home directoy, as if you are like me, all sorts of crap moves in an out of that directory on a daily basis, and the last thing you want to do is to have to rummage through backups trying to find "<em>that script you wrote to diagnose connection problems a year ago</em>".

The point is these scripts will become part of your workflow, once written they will rarely need updating, and should never be called directly, (I mean we're lazy right? WTH do we want to be typing the full script path for? ... oh yeh it saves time!).

In this case:

{{< highlight bash >}}
vi ~/.sysadmin/buzz.sh
{{< / highlight >}}

You can of course call your script whatever you want, and use any text editor you want, if you don't like / know vi ...

{{< highlight bash >}}
#!/bin/bash
# Sysadmin script PART 1 https://blog.oneiroi.co.uk
# Provided under the MIT license (https://www.opensource.org/licenses/mit-license.php)
# © D.Busby
function usage {
echo "Usage: portcon port";
echo "i.e. portcon 80";
}
function portcon {
echo "----- Active Connections For Port $1 -----";
netstat -ant | grep "ABC.DEF.HIJ.KLM:$1 " | wc -l
netstat -ant | grep "ABC.DEF.HIJ.KLM:$1 " | awk '{ print $5 }'  | awk -F \: '{ print $1  }' | sort | uniq -c  | sort -n
}
if [ -z "$1" ]; then
usage;
exit
fi
$1 $2
{{< / highlight >}}

Ok so the above code is provided with two functions usage and portcon.

<strong>MAKE SURE YOU REPLACE "ABC.DEF.HIJ.KLM" WITH YOUR <span style="color: #00cccc;">LOCAL IP ADDRESS </span></strong>

CHMOD this file to allow execution.

{{< highlight bash >}}
chmod +x ~/.sysadmin/buzz.sh
{{< / highlight >}}

Now edit your bashrc file.

{{< highlight bash >}}
vi ~/.bashrc
{{< / highlight >}}

And add the following:

alias buzz='~/.sysadmin/buzz.sh'

Now exit (logout) your SSH session and log back in (or SU root &gt; SU your_user for testing).

{{< highlight bash >}}
[buzz@buzz_srv ~]$ buzz
Usage: portcon port
i.e. portcon 80
[buzz@buzz_srv ~]$
{{< / highlight >}}

Now run the portcon check ...

{{< highlight bash >}}
[buzz@buzz_srv ~]$ buzz portcon 80
----- Active Connections For Port 80 -----
505
1 ***.***.***.***
3 ***.***.***.***
3 ***.***.***.***
4 ***.***.***.***
4 ***.***.***.***
5 ***.***.***.***
11 ***.***.***.***
14 ***.***.***.***
16 ***.***.***.***
76 ***.***.***.***
373 ***.***.***.***{{< / highlight >}}

(Yes before you ask ***.***.***.*** does display the correct IP address, I have purposely removed them for security).

So, I have taken something that would of resulted in netstat output &gt; spreadsheet to formulas &gt; at a estimate 30mins a time analysis to something that now takes less than 5 seconds to type, and get the relevant output, for roughly the same initial effort (30 mins scripting time).

You could argue you can keep a spreadsheet pre-setup with the right formulas / pivot tables and just dump the data each time, well yes you could but that's no where near as quick as this ...

And no trying to convince me it is as quick and better than the script above, for
<ol>
	<li> You have to wait for excel to open the spreadsheet</li>
	<li> You have to copy paste the data</li>
	<li> You have to wait for excel to process the formulas</li>
</ol>
If you have a machine that can do that in time equal to or less than the time it takes the script above to output the data, the only thing I have to say is, <strong>stop spending such a budget on desktops and get a better server.
</strong>

Final Thoughts:

This write up is in jest, and is intended to be read as such, the code and methods provided above are factual. etc ...
