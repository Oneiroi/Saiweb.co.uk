--- 
wordpress_id: 74
title: Windows Killing A Process Without Taskmanager
date: 2008-07-04 10:45:08 +01:00
tags: 
- xp
- windows
- taskkill
- tasklist
tags: 
- windows
wordpress_url: https://blog.oneiroi.co.uk/windows/windows-killing-a-process-without-taskmanager
---
So you have domain admin rights, but that server just wont play with remote desktop ... you suspect a hung process what do you do?

Have someone log into the console (if they can) ?

Or surely there is another way ...

Windows XP (Surprisingly) has a command line tool set for just such an event, in this case the two commands. (Via command line Start > Run CMD)

"<a href="https://technet.microsoft.com/en-gb/library/bb491010(TechNet.10).aspx">TASKLIST</a>"

and

"<a href="https://technet.microsoft.com/en-gb/library/bb491009(TechNet.10).aspx">TASKKILL</a>"

Just run off the list of processes using TASKLIST and kill the "offending" process with TASKKILL, if you can not figure out how to do that by reading the documentation via the links above, then I really do not recommend you use this method.
