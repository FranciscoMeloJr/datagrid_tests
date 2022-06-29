## Get the first cluster name via oc get infinispa crs:
clustername=$(oc get infinispan | awk 'NR==2 {print $1}')

## Show conditions
oc get infinispan $clustername -o jsonpath="{.status.conditions}"

# [map[status:True type:PreliminaryChecksPassed] map[message:View: infinispan-test-0-33011,infinispan-test-1-52904 status:True type:WellFormed]][fdemeloj@fdemeloj utils]$ 
