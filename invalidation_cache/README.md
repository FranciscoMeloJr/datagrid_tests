Creating invalidation cache on dg yaml latest does not go well


File | Content
--------- | ---------
template* | template to create via DG yaml
success_cache_invalidation.json* | cache created via DG cli

With that all said, however, I think you are facing a problem on the creation of invalidation caches themselves and I think I could reproduce it:


    create a sync invalidation cache on the DG via cli:


oc rsh dg-cluster-nyc-0 <--- rsh to the pod
sh-4.4$ cd bin/
sh-4.4$ ./cli.sh 
[disconnected]> connect
[dg-cluster-nyc-0-53500@//containers/default]> ls
caches
counters
configurations
schemas
tasks
[dg-cluster-nyc-0-53500@//containers/default]> cd caches <---go to caches
[dg-cluster-nyc-0-53500@//containers/default/caches]> ls
___script_cache
configMap-cache-02
operator-cache-02
operator-cache-01
operator-cache-03
configMap-cache-01
[dg-cluster-nyc-0-53500@//containers/default/caches]> create cache --template=org.infinispan.INVALIDATION_SYNC mycache2<-------------------------------------- create mycache2
[dg-cluster-nyc-0-53500@//containers/default/caches]> ls
operator-cache-01
configMap-cache-01
operator-cache-03
operator-cache-02
___script_cache
configMap-cache-02
mycache2 <-------------------------------------- here created


    Get the yaml of mycache2 - particularly the spec


$ oc get cache mycache-2-h45mr -o json
{
    "apiVersion": "infinispan.org/v2alpha1",
    "kind": "Cache",
...
        "name": "mycache-2-h45mr",
        "namespace": "dg-test-nyc",
...
    "spec": {
        "clusterName": "dg-cluster-nyc",
        "name": "mycache2",
        "template": "invalidationCache:\n  locking:\n    acquireTimeout: \"15000\"\n    concurrencyLevel: \"1000\"\n    striping: \"false\"\n  mode: SYNC\n  remoteTimeout: \"17500\"\n  statistics: \"true\"\n"
    },


     Create the same <--- (absolutely same) cache via dg yaml (copying the spec above):


apiVersion: template.openshift.io/v1
kind: Template
metadata:
  name: rhdg8-caches
  annotations:
    description: Template to configure caches inside a RHDG cluster on OCP.
    tags: infinispan,datagrid,operator
    iconClass: icon-datagrid
    openshift.io/provider-display-name: Red Hat, Inc.
    openshift.io/support-url: https://access.redhat.com
objects:
- apiVersion: infinispan.org/v2alpha1
  kind: Cache
  metadata:
    name: ${CLUSTER_NAME}-operator-cache-98
    namespace: ${CLUSTER_NAMESPACE}
    labels:
      type: middleware
  spec:
    clusterName: ${CLUSTER_NAME}
    name:  operator-cache-98
    template: |
      invalidationCache:
        locking:
          acquireTimeout: "15000"
          concurrencyLevel: "1000"
          striping: "false"
        mode: SYNC
        remoteTimeout: "17500"
        statistics: "true"

Results:

[fdemeloj@fdemeloj invalidation_cache]$ oc get cache dg-cluster-nyc-operator-cache-98 -o json
{
    "apiVersion": "infinispan.org/v2alpha1",
    "kind": "Cache",
    "metadata": {
        "annotations": {
            "kubectl.kubernetes.io/last-applied-configuration": "{\"apiVersion\":\"infinispan.org/v2alpha1\",\"kind\":\"Cache\",\"metadata\":{\"annotations\":{},\"labels\":{\"type\":\"middleware\"},\"name\":\"dg-cluster-nyc-operator-cache-98\",\"namespace\":\"dg-test-nyc\"},\"spec\":{\"clusterName\":\"dg-cluster-nyc\",\"name\":\"operator-cache-98\",\"template\":\"invalidationCache:\\n  locking:\\n    acquireTimeout: \\\"15000\\\"\\n    concurrencyLevel: \\\"1000\\\"\\n    striping: \\\"false\\\"\\n  mode: SYNC\\n  remoteTimeout: \\\"17500\\\"\\n  statistics: \\\"true\\\"\\n\"}}\n"
        },
        "creationTimestamp": "2022-07-19T02:57:13Z",
        "generation": 1,
        "labels": {
            "type": "middleware"
        },
        "name": "dg-cluster-nyc-operator-cache-98",
        "namespace": "dg-test-nyc",
        "resourceVersion": "49160",
        "uid": "8c50325b-a824-4b11-82ef-709ca5491278"
    },
    "spec": {
        "clusterName": "dg-cluster-nyc",
        "name": "operator-cache-98",
        "template": "invalidationCache:\n  locking:\n    acquireTimeout: \"15000\"\n    concurrencyLevel: \"1000\"\n    striping: \"false\"\n  mode: SYNC\n  remoteTimeout: \"17500\"\n  statistics: \"true\"\n"
    },
    "status": {
        "conditions": [
            {
                "message": "unable to create cache with template: unexpected HTTP status code (400): unexpected error creating cache, response: ISPN000327: Cannot find a parser for element 'invalidation-cache' in namespace ''. Check that your configuration is up-to date for Infinispan '13.0.10.Final-redhat-00001' and if you have the proper dependency in the classpath",
                "status": "False",
                "type": "Ready"
            }
        ]
    }
}

In fact there is no way to create an invalidation cache in dg operator via yaml - tested via:

    template: >-
      <invalidation-cache name="invbd" mode="SYNC" statistics="true" remote-timeout="17500">
      <transaction locking="PESSIMISTIC" mode="FULL_XA"/> 
      <locking concurrency-level="1000" acquire-timeout="15000" striping="false"/> 
      </invalidation-cache>
VS
    template: >-
      <invalidation-cache name="mycache2" mode="SYNC" remote-timeout="17500" statistics="true">
          <locking concurrency-level="1000" acquire-timeout="15000" striping="false"/>
      </invalidation-cache>
VS
    template: |
      invalidationCache:
        locking:
          acquireTimeout: "15000"
          concurrencyLevel: "1000"
          striping: "false"
        mode: SYNC
        remoteTimeout: "17500"
        statistics: "true"
