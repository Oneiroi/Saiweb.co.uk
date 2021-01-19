---
date: "2008-10-14T08:40:55Z"
tags:
- linux
- bash-script
- mac
title: Linux - The Sysadmin script - Part 2
wordpress_id: 231
wordpress_url: https://blog.oneiroi.co.uk/linux/linux-the-sysadmin-script-part-2
---
Part 2 has finally arrived .... don't all cheer at once now ...

In part two I will cover how to run an IP range scan using bash script, and if the host can be pinged retrieve the MAC address of the connected host.

Now bare in mind this script was written to run from a MAC running OSX Leopard.

{{< highlight bash >}}
#!/bin/bash
#colours
function colours {
CLEAR='\e[00m';
GREEN='\e[0;32m';
RED='\e[0;31m';
YELLOW='\e[1;33m';
}
#ipscan
function ipscan {
IPS_START=1;
IPS_END=254;
IPS_RANGE=192.168.1.
echo "Now running IPSCAN $IPS_RANGE$IPS_START - $IPS_RANGE$IPS_END"
for ((i=$IPS_START;i&lt;=$IPS_END;i+=1)); do
RESULT=`ping -c 1 -t 1 $IPS_RANGE$i | grep "bytes from"`;
if [ -z "$RESULT" ]; then
echo -e "$IPS_RANGE$i:$RED DEAD $CLEAR";
# If you comment out the above to report just the alive hosts, bash gets a bit funny about not processing anything here, so uncomment the below to keep it happy
#holder=$i;
else
MAC=`arp $IPS_RANGE$i | awk '{ print $4 }';`;
echo -e "$IPS_RANGE$i:$GREEN ALIVE $CLEAR ($MAC)";
fi
done
}
colours;
$1 $2
{{< / highlight >}}

To make this work on your Linux distro replace -t in the ping command with -W and check the awk entry for the arp output, a display of (no) means that no ARP entries could be found for the host, and change the IP range to that of your network.

That's it for this part, dump this is a file and chmod +x as useual and run with ./script.sh ipscan.
