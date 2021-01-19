---
date: "2010-03-03T16:05:56Z"
tags:
- linux
title: RedHat Cluster OID's
wordpress_id: 836
wordpress_url: https://blog.oneiroi.co.uk/linux/redhat-cluster-oids
---
Following on from the python bindings post I found myself with a real problem,

the netsnmp bindings I could not for the life of me get to take the redhat cluste MIB files, so what did that leave me with, walking the entire parent cluster OID, manually matching the returned OID's to their MIB names based on the value returned as I couldn't find a decent mib browser or script to convert them ...

At any rate here is a subset of OID's for polling the redhat cluster service using snmp, please note that are more OID's but these vary on your cluster config.

Python code:

{{< highlight python >}}
rhc_oid = '.1.3.6.1.4.1.2312.8'
        data_oids = {
                                'rhcMIBVersion':'.1.1',
                                'rhcClusterName':'.2.1',
                                'rhcClusterStatusCode':'.2.2',
                                'rhcClusterStatusDesc':'.2.3',
                                'rhcClusterVotesNeededForQuorum':'.2.4',
                                'rhcClusterVotes':'.2.5',
                                'rhcClusterQuorate':'.2.6',
                                'rhcClusterNodesNum':'.2.7',
                                'rhcClusterNodesNames':'.2.8',
                                'rhcClusterAvailNodesNum':'.2.9',
                                'rhcClusterAvailNodesNames':'.2.10',
                                'rhcClusterUnavailNodesNum':'.2.11',
                                'rhcClusterUnavailNodesNames':'.2.12',
                                'rhcClusterServicesNum':'.2.13',
                                'rhcClusterServicesNames':'.2.14',
                                'rhcClusterRunningServicesNum':'.2.15',
                                'rhcClusterRunningServicesNames':'.2.16',
                                'rhcClusterStoppedServicesNum':'.2.17',
                                'rhcClusterStoppedServicesNames':'.2.18',
                                'rhcClusterFailedServicesNum':'.2.19',
                                'rhcClusterFailedServicesNames':'.2.20'}

        for item in data_oids:
                oid = '%s%s' % (rhc_oid,data_oids[item])
                print item,oid
{{< / highlight >}}
