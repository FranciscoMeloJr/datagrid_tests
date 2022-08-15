podname=$1
oc cp 5000CacheEntries  $podname:/opt/infinispan/server/data
