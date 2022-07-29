#!/bin/bash
## script to put jcmd inside $name of the pod
#$oc get pod
podname=$1
oc exec $podname -- mkdir -p /opt/infinispan/diag/bin
oc cp jcmd  $podname:/opt/infinispan/diag/bin
oc exec $podname -- ln -s /usr/lib/jvm/jre/lib /opt/infinispan/diag/lib #oc exec dg-cluster-nyc-0 -- bash -c 'echo "$JAVA_HOME"'

# add version.txt as well
oc cp version.txt  $podname:/opt/infinispan/version.txt
oc exec $podname -- cat /opt/infinispan/version.txt

# executing to confirm:
oc exec $podname -- /opt/infinispan/diag/bin/jcmd
