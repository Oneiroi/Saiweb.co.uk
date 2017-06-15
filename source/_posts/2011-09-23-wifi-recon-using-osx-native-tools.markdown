--- 
wordpress_id: 1122
layout: post
title: WiFi recon using OSX native tools
date: 2011-09-23 10:13:12 +01:00
tags: 
- osx
- wifi
- pentesting
- pcap
- airport
categories: 
- hacking
- mac
wordpress_url: https://saiweb.co.uk/hacking/wifi-recon-using-osx-native-tools
comments: true
---
So you wanted to get your aircrak suite on under OSX, getting airodump etc to work I can tell you will be a nightmare (infact just dont use a VM with a USB wifi for that, however there is an alternative ...), after a lot of searching there is a native tool under OSX that will let you cap packets, list networks etc.

Credit goes to <a href="https://forum.aircrack-ng.org/index.php?topic=293.msg34031#msg34031">d3in0s</a> for his awesome forum post.

{% highlight bash %}
/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport
Usage: airport <interface> <verb> <options>

	<interface>
	If an interface is not specified, airport will use the first AirPort interface on the system.

	<verb is one of the following:
	prefs	If specified with no key value pairs, displays a subset of AirPort preferences for
		the specified interface.

		Preferences may be configured using key=value syntax. Keys and possible values are specified below.
		Boolean settings may be configured using 'YES' and 'NO'.

		DisconnectOnLogout (Boolean)
		JoinMode (String)
			Automatic
			Preferred
			Ranked
			Recent
			Strongest
		JoinModeFallback (String)
			Prompt
			JoinOpen
			KeepLooking
			DoNothing
		RememberRecentNetworks (Boolean)
		RequireAdmin (Boolean)
		RequireAdminIBSS (Boolean)
		RequireAdminNetworkChange (Boolean)
		RequireAdminPowerToggle (Boolean)
		WoWEnabled (Boolean)

	logger	Monitor the driver's logging facility.

	sniff	If a channel number is specified, airportd will attempt to configure the interface
		to use that channel before it begins sniffing 802.11 frames. Captures files are saved to /tmp.
		Requires super user privileges.

	debug	Enable debug logging. A debug log setting may be enabled by prefixing it with a '+', and disabled
		by prefixing it with a '-'.

		AirPort Userland Debug Flags
			DriverDiscovery
			DriverEvent
			Info
			SystemConfiguration
			UserEvent
			PreferredNetworks
			AutoJoin
			IPC
			Scan
			802.1x
			Assoc
			Keychain
			RSNAuth
			WoW
			AllUserland - Enable/Disable all userland debug flags

		AirPort Driver Common Flags
			DriverInfo
			DriverError
			DriverWPA
			DriverScan
			AllDriver - Enable/Disable all driver debug flags

		AirPort Driver Vendor Flags
			VendorAssoc
			VendorConnection
			AllVendor - Enable/Disable all vendor debug flags

		AirPort Global Flags
			LogFile - Save all AirPort logs to /var/log/airport.log

<options> is one of the following:
	No options currently defined.

Examples:

Configuring preferences (requires admin privileges)
	sudo airport en1 prefs JoinMode=Preferred RememberRecentNetworks=NO RequireAdmin=YES

Sniffing on channel 1:
	airport en1 sniff 1


LEGACY COMMANDS:
Supported arguments:
 -c[<arg>] --channel=[<arg>]    Set arbitrary channel on the card
 -z        --disassociate       Disassociate from any network
 -I        --getinfo            Print current wireless status, e.g. signal info, BSSID, port type etc.
 -s[<arg>] --scan=[<arg>]       Perform a wireless broadcast scan.
				   Will perform a directed scan if the optional <arg> is provided
 -x        --xml                Print info as XML
 -P        --psk                Create PSK from specified pass phrase and SSID.
				   The following additional arguments must be specified with this command:
                                  --password=<arg>  Specify a WPA password
                                  --ssid=<arg>      Specify SSID when creating a PSK
 -h        --help               Show this help
{% endhighlight %}
Credit goes to <a href="https://forum.aircrack-ng.org/index.php?PHPSESSID=osr5e11icl40hib1f57qkh0u35&topic=293.msg34031#msg34031">d3in0s post</a> showing true forum awesomeness. 

{% highlight bash %}
/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I
     agrCtlRSSI: -40
     agrExtRSSI: 0
    agrCtlNoise: -92
    agrExtNoise: 0
          state: running
        op mode: station 
     lastTxRate: 54
        maxRate: 54
lastAssocStatus: 0
    802.11 auth: open
      link auth: wpa2-psk
          BSSID: <removed>
           SSID: <removed>
            MCS: -1
        channel: 6
/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -s
                            SSID BSSID             RSSI CHANNEL HT CC SECURITY (auth/unicast/group)
                          <removed> <removed> -41  6       N  -- WPA(PSK/AES,TKIP/TKIP) WPA2(PSK/AES,TKIP/TKIP)
{% endhighlight %}

Doing a frame cap.

{% highlight bash %}

/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport en1 sniff 6
Capturing 802.11 frames on en1.
{% endhighlight %}

You will see your airport icon changes to <a href="https://blog.oneiroi.co.uk/uploads/2011/09/Screen-shot-2011-09-23-at-11.20.28.png"><img src="https://blog.oneiroi.co.uk/uploads/2011/09/Screen-shot-2011-09-23-at-11.20.28.png" alt="" title="Screen shot 2011-09-23 at 11.20.28" width="45" height="24" class="aligncenter size-full wp-image-1126" /></a> now hit ctrl+c to stop the cap

{% highlight bash %}
^CSession saved to /tmp/airportSniff813ZrA.cap.
{% endhighlight %}

