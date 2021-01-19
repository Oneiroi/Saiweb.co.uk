---
title: "pi2 cluster - docker swarm"
date: 2015-05-29 17:52
tags:
- raspberrypi2
- pi2
- cluster
- docker
- swarm
- arch 
---

I am currently working on overhauling my network and devices once again, so finally (maybe) I'll actually get around to producing a commodity cluster, this post focuses on getting docker up and running on the RaspberryPi2

# Hardware

* 5 x RasPi2 
* 1 x Utilite Pro

Docusing on the Pi2's here as I've not rebuild the utilite at this moment in time.

# Installing Arch linux

Why are we using Arch and not raspbian? simply because of time constraints, Arch has ARM packages for docker (and openvswitch) and this will save sometime going on.

As I'll be imaging multiple SD cards I wront a [bash script to save some time](https://gist.githubusercontent.com/Oneiroi/405834baecb5c732c982/raw/6243d812d0802a224c65e4e2a91fd246769cbb3e/rpi2_cluster_prep_sdcard.sh)

This assumes you have allready done the partitioning per the [arch installation document](https://archlinuxarm.org/platforms/armv7/broadcom/raspberry-pi-2)

*WARNING* Make sure you do not blindly use my script, the device paths may be different and you do not want to be wiping out the wrong device.

# Installing Docker

`pacman -S docker`

## Caveats of docker on ARM

Most docker images are x86 or x86_64 so when you use `docker pull` and try to `docker run` you're going to have a bad time ...

```
docker run swarm
FATA[0001] Error response from daemon: Cannot start container caff048f6af28eca4648078ac1452b9464dcc16f5273a3b3d0912b1c00e0423f: [8] System error: exec format error
```

# Running swarm without running swarm

The swarm docker images will not run on ARM, so what do we do ? 

Simple we build the swarm binary from [source](https://github.com/docker/swarm)

`pacman -S golang godep`

Check the github readme via the link above to get swarm to compile 

## Start the swarm

On one node `go/bin/swarm create` and record the token

Now on every node

```
go/bin/swarm --addr NNN.NNN.NNN.NNN:2375 token://the_token_from_create
```

Now we need to start the manager, this can be on any node or even on a sperate machine such as your laptop / desktop.

```
go/bin/swarm manage -H tcp://NNN.NNN.NNN.NNN:2376 token://the_token_from_create
```

## Check the swarm

Again this can be run from any docker client.

```
docker -H tcp://XXX.XXX.XXX.230:2376 info
Containers: 1
Strategy: spread
Filters: affinity, health, constraint, port, dependency
Nodes: 5
 alarmpi: XXX.XXX.XXX.227:2375
  └ Containers: 0
  └ Reserved CPUs: 0 / 4
  └ Reserved Memory: 0 B / 970.7 MiB
  └ Labels: executiondriver=native-0.2, kernelversion=3.18.14-1-ARCH, operatingsystem=Arch Linux ARM, storagedriver=aufs
 alarmpi: XXX.XXX.XXX.229:2375
  └ Containers: 0
  └ Reserved CPUs: 0 / 4
  └ Reserved Memory: 0 B / 970.7 MiB
  └ Labels: executiondriver=native-0.2, kernelversion=3.18.14-1-ARCH, operatingsystem=Arch Linux ARM, storagedriver=aufs
 alarmpi: XXX.XXX.XXX.226:2375
  └ Containers: 0
  └ Reserved CPUs: 0 / 4
  └ Reserved Memory: 0 B / 970.7 MiB
  └ Labels: executiondriver=native-0.2, kernelversion=3.18.14-1-ARCH, operatingsystem=Arch Linux ARM, storagedriver=aufs
 alarmpi: XXX.XXX.XXX.230:2375
  └ Containers: 1
  └ Reserved CPUs: 0 / 4
  └ Reserved Memory: 0 B / 970.7 MiB
  └ Labels: executiondriver=native-0.2, kernelversion=3.18.14-1-ARCH, operatingsystem=Arch Linux ARM, storagedriver=aufs
 alarmpi: XXX.XXX.XXX.228:2375
  └ Containers: 0
  └ Reserved CPUs: 0 / 4
  └ Reserved Memory: 0 B / 970.7 MiB
  └ Labels: executiondriver=native-0.2, kernelversion=3.18.14-1-ARCH, operatingsystem=Arch Linux ARM, storagedriver=aufs
```

So there we have it, 20 available ARM cores all running in a docker swarm, seems simple doesn't it? finding the correct information to make this all work however was a trial in itself.

## TODO

* Rebuild utilite-pro, make part of the docker swarm (brining the core count to 24)
* Force docker to use TLS
* Try to get ceph compiling (throwing issues about not finding any high precision timers)

```
common/Cycles.h:76:2: error: #error No high-precision counter available for your OS/arch
```

* [Unanswered userlist quesiton on this issue](https://lists.ceph.com/pipermail/ceph-users-ceph.com/2015-January/045880.html)
* [Github pull fixing this issue for PowerPC only](https://github.com/ceph/ceph/pull/4507)
* [This blog post gives some hope on finding a fix](https://blog.regehr.org/archives/794)

```
asm volatile ("mrc p15, 0, %0, c15, c12, 1" : "=r" (cc));
```

* Write up notes on getting Logstash 1.5.0 and docker on ARM to play nice together
* Complete setup of openvswitch 
* Explore deployment of [cuckoo sandbox](https://www.cuckoosandbox.org/)
* Explore Hadoop components
* Write up notes on distccd setup (this really speeds up compilation time)
* Write up systemd entries for swarm (allow automatic swarm cluster startup on reboot).

## Photos

I'm uploading photos and screenshots of the cluster as progress is made [here](https://photos.google.com/album/AF1QipOi6l8z-eGgjpFUuoij80-48SCruDvi2k9FgIMY)

# Why Pi2?

We can't all get our hands on a [HP moonshot](https://www8.hp.com/uk/en/products/servers/moonshot/), I debated for some what to use, the Pi2 won out due to 

* Price
* Form factor
* No. cores
* Readily available distros and packages
* Readily available accessories (cases, etc..)
* Low power consumption (5 pi2, 1 utilite-pro, mikrotik switch, USB thumbdrives, and USB HD's, all runnign just under 33 watts)
* ARM architecture

