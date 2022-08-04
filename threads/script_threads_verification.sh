podname=dg-cluster-nyc-0
pid=163
template=cluster-dg-01.yaml
oc process -f $template | oc apply -f -
oc delete pod $podname
sleep 25
cd ../heap-dump-in-container/jcmd_heap/script_set_on_pod/
./set_jcmd_insidepod.sh $podname
oc exec $podname -- /opt/infinispan/diag/bin/jcmd $pid VM.flags
oc exec $podname -- /opt/infinispan/diag/bin/jcmd $pid VM.flags -all | grep ParallelGCThreads
oc exec $podname -- /opt/infinispan/diag/bin/jcmd $pid VM.flags -all | grep ConcGCThreads
oc get pod -o json | grep cpu