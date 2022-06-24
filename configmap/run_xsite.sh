oc process -f template-01-complete.yaml | oc apply -f -
oc process -f template-02-complete.yaml | oc apply -f -
# get ips
oc project dg-test-nyc
oc get ip
oc edit ip install-z5qvk

oc project dg-test-nyc
oc get ip
oc edit ip install-5p822

#confirm the upgrades
oc get csv #<--- succeded for each project
oc get csv #<--- succeded

# create clusters with caches:
oc process -f cluster-dg-03.yaml | oc apply -f - ; oc process -f cluster-dg-04.yaml | oc apply -f -

# create new caches:
$ oc process -f template-03-complete.yaml | oc apply -f - ; 
$ oc process -f template-04-complete.yaml | oc apply -f -

oc describe cache
oc describe infinispan
oc describe infinispan dg-cluster-lon >> infinispan.lon

# get data from cluster
$ oc project dg-test-nyc
#Now using project "dg-test-nyc" on server "https://api.ci-ln-hhilk82-72292.origin-ci-int-gce.dev.rhcloud.com:6443".
$ oc describe infinispan dg-cluster-nyc >> infinispan.nyc

