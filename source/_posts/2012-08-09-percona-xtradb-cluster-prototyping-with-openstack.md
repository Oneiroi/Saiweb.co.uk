---
title: "Percona XtraDB Cluster - Prototyping with Openstack"
date: 2012-08-09 13:38
tags:
- percona
- xtradb
- cluster
- openstack
---

Per my [Google+](https://plus.google.com/u/1/117561367404774597588) ramblings; recently I began experimenting with [Percona XtraDB Cluster](https://www.percona.com/software/percona-xtradb-cluster/).

After an initial read the setup process [seemed very simple](https://plus.google.com/117561367404774597588/posts/YjLkYkMJRvN), and as it would turn out it was; I later moved onto some simple [resillience testing](https://plus.google.com/117561367404774597588/posts/ZqLVySmp5kn) of my 4 node p.o.c. cluster.

I'm still a little unsure on the [circular topology](https://serverfault.com/questions/403104/percona-xtradb-cluster-node-recovery/403118) I ended up using; but it appears absolutely fine so long as the following conditions are met.

1. At least one node is always available.
2. Nodes are recovered only if their peer is available to sync from.
    a. Requiring a startup order.

This is not such a bad thing, as if all nodes were to suddenly go down; I can't think of a situation where you would want it all to recover "automagically" you would want to inspect to ensure data integrity and recover from a "known good" version of your data.

<strong>Openstack as an experimentation platform</strong>

[Openstack](https://openstack.org) i I've found perfect for rapid prototyping of hostinsg platform architectures, in none geek building virtual models of servers and services; ensuring sure they all go together properly before committing to the build plan.

The best part being the VM's are "Throw away", something goes inexplicably wrong with a vm prototype? assuming you used snapshots at each step it's easy enough to roll back.

For reference I used Fedora 17 and the [wiki reference setup](https://fedoraproject.org/wiki/Getting_started_with_OpenStack_on_Fedora_17) of openstack for prototyping.

Note in this case you may be better off using [OpenVZ](https://wiki.openvz.org/Main_Page); whilst openstack does not at the time of writing support this directly, the openstack DBaaS (Database as a Service) project [Red Dwarf](https://wiki.openstack.org/DatabaseAsAService) leverages OpenVZ to provide DBaaS, (Something I'd like to get auto handeling clusters via XtraDB clustering, given the time ...).

<strong>XtraDB cluster p.o.c. platform</strong>

My platform consists of 4 nodes; although I am sured [an odd number](https://serverfault.com/questions/403104/percona-xtradb-cluster-node-recovery/403118) of nodes is preferable to reduce the risk of split-brain behaviour occuring.





