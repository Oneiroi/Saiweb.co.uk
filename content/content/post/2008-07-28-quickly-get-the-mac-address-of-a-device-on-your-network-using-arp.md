---
date: "2008-07-28T08:45:34Z"
tags:
- windows
- networking
title: Quickly get the MAC address of a device on your network using ARP
wordpress_id: 102
wordpress_url: https://blog.oneiroi.co.uk/windows/quickly-get-the-mac-address-of-a-device-on-your-network-using-arp
---
This is something I find myself having to do, more and more lately due to this VoIP roll out.

From windows (xp)


Start > run > cmd

Once the command window is open ping the IP address of the device (this forces your system to do an ARP request and store the device information in the cache, don't ask me why but microsoft decided it was a good idea not to lookup the information if it isn't allready in the cache!)

NOTE: Even if the device blocks ICMP, this should still work, run ettercap on your windows network to see just how many times you will see an ARP request along the lines of "WHO HAS xxx.xxx.xxx.xxx".

Now to get the MAC address type

{{< highlight bash >}}
arp -a xxx.xxx.xxx.xxx
{{< / highlight >}}

Where xxx.xxx.xxx.xxx is the IP address of the device you just pinged.


{{< highlight bash >}}
C:\Documents and Settings\buzz>arp  -a 10.99.1.10

Interface: XXX.XXX.XXX.XXX --- 0x3
  Internet Address      Physical Address      Type
  XXX.XXX.XXX.XXX            AA-BB-CC-DD-EE-FF     dynamic

{{< / highlight >}}

Please note this only works for a device on the same IP range.

If you run two ranges, i.e.

192.168.1.XXX

and

192.168.2.XXX

You will need to make the ARP request from a device bound to that range (servers are especially usefull here).
