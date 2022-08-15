podname=$1
filename=1MillionCacheEntries
oc cp 1MillionCacheEntries $podname:/opt/infinispan/server/data
oc exec $podname -- /opt/infinispan/bin/cli.sh -f /opt/infinispan/server/data/1MillionCacheEntries