---
date: "2008-11-12T12:25:22Z"
tags:
- linux
- apache
- bash-script
title: Linux - The Sysadmin script - Part 3
wordpress_id: 257
wordpress_url: https://blog.oneiroi.co.uk/linux/linux-the-sysadmin-script-part-3
---
<strong>PART 3 IS INACCURATE, THE BELOW SCRIPT IS FOR REFERENCE ONLY, IT HAS BEEN REPLACED IN <a href="https://blog.oneiroi.co.uk/uncategorized/linux-the-sysadmin-script-part-4">PART 4</a></strong>

In part 3, I am going to cover a bash function that will allow you to profile the memory usage of any application by name.

By adding the function below into your script you can execute a command such as: sysadmin appmem apache

{{< highlight bash >}}
function appmem {
if [ -z "$1" ]; then
echo "Usage: sysadmin appmem app_name i.e. (sysadmin appmem apache)";
else
if [ -x '/usr/bin/pmap' ]; then
APID=(`ps aux | grep "$1" | grep -v 'grep' | grep -v "$0" | awk '{print $2}'`);
COUNT=0;
AMEM=0
for PID in ${APID[@]}
do
TMP=$((`pmap -x $PID | grep "total" | awk '{print $3}'`));
AMEM=$(($AMEM+$TMP));
COUNT=$(($COUNT+1));
done
AMEM=$(($AMEM/1024));
echo -e "$YELLOW ----- MEMORY USAGE REPORT FOR '$1' ----- $CLEAR";
echo "PID Count: $COUNT";
echo "Mem usage: $AMEM MB";
echo "Mem/PID: $(($AMEM/$COUNT)) MB";
echo -e "$RED"
echo -e "For more information run: pmap -x $PID $CLEAR";
else
echo 'Could not execute /usr/bin/pmap ... aborting';
exit;
fi
fi
}
{{< / highlight >}}
Sample output:

{{< highlight bash >}}
<span style="color: #ffcc00;">----- MEMORY USAGE REPORT FOR 'apache' -----</span>
PID Count: 6
Mem usage: 1134 MB
Mem/PID: 189 MB
<span style="color: #ff0000;">
For more information run: pmap -x 123456</span>
{{< / highlight >}}

You can of course replace 'apache' with the application or daemon name you want to profile the memory usage of.

This script does require that pmap is installed, if the script can not find it, it will abort.

As always any problems, post a comment.

UPDATE: Apparently I need to point out that if you haven't read <a href="https://blog.oneiroi.co.uk/linux/linux-the-sysadmin-script-part-2">PART 2</a>! then the colored output will not work ... That's why this entry is titled part 3, it does assume a degree of competence on your part in realizing part's 1 and 2 may just be required reading ...

<strong>NOTE: The above provides a complete memory footprint of the indvidual PID, the same as VIRT in top.</strong>

<strong> VIRT -- Virtual Image (kb)
* The total amount of virtual memory used by the task. It includes all code, data and shared libraries plus pages that have been swapped out.
* VIRT = SWAP + RES </strong>
