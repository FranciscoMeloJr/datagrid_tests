## This script confirms the cache sessions was created::
## input: none

routename=$(oc get route | awk 'NR==2 {print $2}')
curl -X GET http://$routename/redhat/update-cache/sessions/cacheKey1/cacheValue1
curl -X GET http://$routename/redhat/get-cache-value/sessions/cacheKey1

routename=$(oc get route | awk 'NR==3 {print $2}')
curl -X GET http://$routename:2022/redhat/update-cache/sessions/cacheKey1/cacheValue1
