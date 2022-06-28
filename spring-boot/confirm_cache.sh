## This script confirms the cache sessions was created::
## input: none
cachename="sessions"
podname=$(oc get pods --no-headers | awk 'NR==2 {print $1}')
#oc exec -it $podname -- cat /opt/infinispan/server/data/caches.xml 
oc exec -it $podname -- cat /opt/infinispan/server/data/caches.xml  |  if grep -ril $cachename; then
    echo "Cache " $cachename " Properly created"
else
    echo "Cache " $cachename " not properly created"
fi