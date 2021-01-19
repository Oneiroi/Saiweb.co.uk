---
date: "2014-05-16T00:00:00Z"
tags:
- ids
- ips
- security
- visualization
- kibana
- logstash
- suricata
- arm
- utilite
title: Suricata Logstash Kibana Utilite Pro ARM
---

I'm currently in the process of overhauling my pesonal work network, this includes deployment of an inline IPS as part of the project.

# Hardware List

* Freescale i.MX6 quad-core Cortex-A9 @ 1.2GHz
* 2GB DDR3 @ 1066 Mhz
* 32Gb mSata
* 1 x SanDisk Ultra 64GB Class 10 MicroSD
* 2 x 1GB NIC (Intel Corporation I211 Gigabit Network Connection)
* 1 x Internal Wifi 802.11b/g/n 
* 1 x USB Alfa AWUS036NHR

[Complete Utilite Pro Spec](https://utilite-computer.com/web/utilite-pro-specifications) 

Ships with Ubuntu 12:04 LTS

You can of course change the OS on the Utlite pro to things such as [Kali](https://www.kali.org/penetration-testing/ultimate-pentesting-pwnbox-2013-utilite/) and [Arch assault](https://archassault.org/) the caveat being if you want to install on the mSATA and not run from the sdcard you're going to need to use the serial connection.

My USB -> Serial adapter has a male connector, the connector for the Utilite also provides a male DB9 connection ... so an adapter is on order.

# Topology


```
[LAN Router] --- [ Utilite Pro ] --- [ ISP Router ]
```

So as can be seen here I'm sitting the device inline, with the intent to have it route traffic between the LAN and WAN, as an asside I also plan to use the WiFi to provide Wireless access disbaling the ISP equipment, also to allow segmented guest access for visitors etc / captive portal, but that's a far off from solid plan at the moment

# Suricata

The packages available from the ubuntu arm repos are 1.x and I want the new 2.x builds (Archassault however took my feedback and have [built the 2.x packages](https://twitter.com/ArchAssault/status/463332656101355521)) so in the interim to receiving the required equipment to install [Arch on arm](https://archlinuxarm.org/platforms/armv7/freescale/utilite) all the prototyping will need to use the unbuntu install.

## Building Suricata 2.x on ubuntu 12.04 ARM

```
wget https://www.openinfosecfoundation.org/download/suricata-2.0.tar.gz
tar -zxvf suricata-2.0.tar.gz
cd suricata-2.0
```

Adapting from the intructions [here](https://redmine.openinfosecfoundation.org/projects/suricata/wiki/Ubuntu_Installation).


### Install core requirements

```
apt-get -y install libpcre3 libpcre3-dbg libpcre3-dev \
build-essential autoconf automake libtool libpcap-dev libnet1-dev \
libyaml-0-2 libyaml-dev zlib1g zlib1g-dev libcap-ng-dev libcap-ng0 \
make libmagic-dev
```

### Install IPS configuration requirements

```
apt-get -y install libnetfilter-queue-dev libnetfilter-queue1 libnfnetlink-dev libnfnetlink0i
```

### Install logstash output format (eve.json) requirements

```
apt-get -y install libjansson-dev libjansson4
```

###  configure and build suricata

I want everything to run on the sdcard at this time as I plan to replace the OS and thus everything on the mSATA ;-)

```
mkdir -p /sdcard/suricata/{usr,etc,var}
./configure --enable-nfqueue --prefix=/sdcard/suricata/usr --sysconfdir=/sdcard/suricata/etc --localstatedir=/sdcard/suricata/var
make && make install-full
```

### --build-info

After complete of the above your build info should look like


```
root@utilite:/sdcard/suricata/usr/bin# ./suricata --build-info
This is Suricata version 2.0 RELEASE
Features: NFQ PCAP_SET_BUFF LIBPCAP_VERSION_MAJOR=1 AF_PACKET HAVE_PACKET_FANOUT LIBCAP_NG LIBNET1.1 HAVE_HTP_URI_NORMALIZE_HOOK HAVE_LIBJANSSON 
SIMD support: none
Atomic intrisics: 1 2 4 8 byte(s)
32-bits, Little-endian architecture
GCC version 4.6.3, C version 199901
compiled with -fstack-protector
compiled with _FORTIFY_SOURCE=2
L1 cache line size (CLS)=64
compiled with LibHTP v0.5.10, linked against LibHTP v0.5.10
Suricata Configuration:
  AF_PACKET support:                       yes
  PF_RING support:                         no
  NFQueue support:                         yes
  IPFW support:                            no
  DAG enabled:                             no
  Napatech enabled:                        no
  Unix socket enabled:                     yes
  Detection enabled:                       yes

  libnss support:                          no
  libnspr support:                         no
  libjansson support:                      yes
  Prelude support:                         no
  PCRE jit:                                no
  libluajit:                               no
  libgeoip:                                no
  Non-bundled htp:                         no
  Old barnyard2 support:                   no
  CUDA enabled:                            no

  Suricatasc install:                      yes

  Unit tests enabled:                      no
  Debug output enabled:                    no
  Debug validation enabled:                no
  Profiling enabled:                       no
  Profiling locks enabled:                 no
  Coccinelle / spatch:                     no

Generic build parameters:
  Installation prefix (--prefix):          /sdcard/suricata/usr
  Configuration directory (--sysconfdir):  /sdcard/suricata/etc/suricata/
  Log directory (--localstatedir) :        /sdcard/suricata/var/log/suricata/

  Host:                                    armv7l-unknown-linux-gnueabi
  GCC binary:                              gcc
  GCC Protect enabled:                     no
  GCC march native enabled:                yes
  GCC Profile enabled:                     no
```

You can now run Surticata in IDS mode: 

```
LD_LIBRARY_PATH=/sdcard/suricata/usr/lib /sdcard/suricata/usr/bin/suricata -c /sdcard/suricata/etc/suricata//suricata.yaml -i ethN
```

**NOTE** The intention is to run in IPS mode, however IDS is suitable to complete the integration with logstash and kibana

### Get some event data

Configure your SSHD for keyonly authentication, and harden to your preferences and then just expose SSH to the internet for a few hours; I'm not kidding here within ~12 hours I'd logged well over 1K attempted logins enough for suricata to log some `ET COMPROMISED Known Compromised or Hostile Host Traffic group` events.

### Setup ARM Java

```
apt-get install openjdk-7-jre
```

### Logstash

```
wget https://download.elasticsearch.org/logstash/logstash/logstash-1.4.1.tar.gz
tar -zxvf logstash-1.4.1.tar.gz
cd logstash-1.4.1
mkdir -p etc/conf.d
cat >> etc/conf.d/suricata.conf << EOF
input {
  file { 
    path => ["/sdcard/suricata/var/log/suricata/eve.json"]
    codec =>   json 
    type => "SuricataIDPS-logs"
  }

}

filter {
  if [type] == "SuricataIDPS-logs" {
    date {
      match => [ "timestamp", "ISO8601" ]
    }
  }

  if [src_ip]  {
    geoip {
      source => "src_ip" 
      target => "geoip" 
      database => "/sdcard/logstash-1.4.1/vendor/geoip/GeoLiteCity.dat" 
      add_field => [ "[geoip][coordinates]", "%{[geoip][longitude]}" ]
      add_field => [ "[geoip][coordinates]", "%{[geoip][latitude]}"  ]
    }
    mutate {
      convert => [ "[geoip][coordinates]", "float" ]
    }
  }
}

output {
  elasticsearch {
    embedded => true
  }
}
EOF
bin/logstash -f etc/conf.d/suricata.conf
```

This will take some time to start up, note that if you want to load in an existing log set, add `start_position => "beginning"` to the file {} declaration before starting logstash, after the back loading has completed I recomend you to remove this line, as it defaults to "end" and logstash tracks it's position in the file if you leave this as beginning however it will always start at the beginning of the log and take a long time to startup needlessly


#### ArgumentError: cannot import class java.lang.reflect.Modifier' asModifier'

[something screwy occurs within jruby](https://twitter.com/icleus/status/459725121574277122) 

##### Install oracle java

Download ejre-7u55-fcs-b13-linux-arm-vfp-hflt-client_headless-17_mar_2014.tar.gz from [here](https://www.oracle.com/technetwork/java/embedded/downloads/javase/index.html?ssSourceSiteId=otncn)

"ARMv6/7 Linux - Headless - Client Compiler EABI, VFP, SoftFP ABI, Little Endian1"

```
tar -zxvf ejre-7u55-fcs-b13-linux-arm-vfp-sflt-client_headless-17_mar_2014.tar.gz
update-alternatives --install "/usr/bin/java" "java" "/path/to/ejre1.7.0_55/bin/java" 1
update-alternatives --config java
...
There are 2 choices for the alternative java (providing /usr/bin/java).

  Selection    Path                                            Priority   Status
------------------------------------------------------------
* 0            /usr/lib/jvm/java-7-openjdk-armel/jre/bin/java   1043      auto mode
  1            /path/to/ejre1.7.0_55/bin/java                    1         manual mode
  2            /usr/lib/jvm/java-7-openjdk-armel/jre/bin/java   1043      manual mode

Press enter to keep the current choice[*], or type selection number: 
 
```

Select 1 or whatever index you are shown

### Kibana


Kibana is really just a web interface, so [download it](https://download.elasticsearch.org/kibana/kibana/kibana-3.1.0.tar.gz) and install your preffered webserver to run it from nGinx / Apache / Lighthttpd etc ...

```
cd /path/to/kibana/apps/dashboards/
curl -o suricata2.json https://gist.githubusercontent.com/regit/8849943/raw/15f1626090d7bb0d75bca33807cfaa4199b767b4/Suricata%20dashboard
```

In your browser now go to https://your_device/path/to/kibana/#/dashboard/file/suricata2.json

{{< figure src="/images/suricata.png" >}}
