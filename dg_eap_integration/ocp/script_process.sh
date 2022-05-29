## Complete process 
oc process -f template-01-complete.yaml | oc apply -f -
oc process -f cluster-dg-01.yaml | oc apply -f -
oc project eap-test
#oc import-image jboss-eap-7/eap73-openjdk11-openshift-rhel8 --from=registry.redhat.io/jboss-eap-7/eap73-openjdk11-openshift-rhel8 --confirm
oc import-image jboss-eap-7/eap74-openjdk11-openshift-rhel8 --from=registry.redhat.io/jboss-eap-7/eap74-openjdk11-openshift-rhel8 --confirm

oc get is
#oc new-app eap73-openjdk11-openshift-rhel8~/home/fdemeloj/Downloads/cases/datagrid_tests/dg_eap_integration/ocp/tmp
oc new-app eap74-openjdk11-openshift-rhel8~/home/fdemeloj/Downloads/cases/datagrid_tests/dg_eap_integration/ocp/tmp

#oc logs -f bc/verify-cluster
oc logs -f bc/datagridtests
#oc start-build verify-cluster.war --from-file=tmp/verify-cluster.war (application under /tmp)
oc start-build datagridtests --from-file=tmp/verify-cluster.war

oc create configmap jboss-cli --from-file=postconfigure.sh=postconfigure.sh --from-file=actions.cli=actions.cli

oc set volume dc/datagridtests --add --name=jboss-cli -m /opt/eap/extensions -t configmap --configmap-name=jboss-cli --default-mode='0777'
 --> oc set volume dc/datagridtests --add --name=jboss-cli -m /opt/eap/extensions -t configmap --configmap-name=jboss-cli --default-mode='0777' --overwrite

oc expose svc/datagridtests

$ oc get svc


$ oc get routes

To access: Example /verify-cluster/counter

echo "Debugging issues"
#ISSUE::
## Issues 1: 
#03:41:45,181 ERROR [org.jboss.as.controller.management-operation] (Controller Boot Thread) WFLYCTL0013: Operation ("deploy") failed - address: ([("deployment" => "verify-cluster.war")]) - failure description: {"WFLYCTL0080: Failed services" => {"org.wildfly.clustering.infinispan.cache.web.\"verify-cluster.war\"" => "org.infinispan.commons.CacheException: Unable to invoke method public void org.infinispan.persistence.manager.PersistenceManagerImpl.start() on object of type PersistenceManagerImpl
#Caused by: org.infinispan.commons.CacheException: Unable to invoke method public void org.infinispan.persistence.manager.PersistenceManagerImpl.start() on object of type PersistenceManagerImpl
#Caused by: org.infinispan.commons.CacheException: Unable to start cache loaders
#Caused by: org.infinispan.persistence.spi.PersistenceException: org.infinispan.client.hotrod.exceptions.TransportException:: java.net.UnknownHostException: eap-infinispan.dgeap.svc.cluster.local
#Caused by: org.infinispan.client.hotrod.exceptions.TransportException:: java.net.UnknownHostException: eap-infinispan.dgeap.svc.cluster.local
#Caused by: java.net.UnknownHostException: eap-infinispan.dgeap.svc.cluster.local"}}

## Issues 2:
# Caused by: org.infinispan.client.hotrod.exceptions.TransportException:: java.lang.SecurityException: ISPN004031: The selected authentication mechanism 'SCRAM-SHA-512' is not among the supported server mechanisms: []



name: eap-infinispan
namespace: dgeap
default: svc.cluster
eap-infinispan.dgeap.svc.cluster:: <----

name: dg-cluster <--- oc get svc
namespace: eap-test
default: svc.cluster
dg-cluster.eap-test.svc.cluster:: <-----

---> updated configmap

Troubleshooting: 
~~~
[fdemeloj@fdemeloj ocp]$ oc exec -it datagridtests-3-mzsxd -- ls -lrt /opt/eap/extensions
total 0
lrwxrwxrwx. 1 root 1000670000 23 May 25 04:39 postconfigure.sh -> ..data/postconfigure.sh
lrwxrwxrwx. 1 root 1000670000 18 May 25 04:39 actions.cli -> ..data/actions.cli
[fdemeloj@fdemeloj ocp]$ oc exec -it datagridtests-3-mzsxd -- cat - /opt/eap/extensions/actions.cli
^Ccommand terminated with exit code 130
[fdemeloj@fdemeloj ocp]$ oc exec -it datagridtests-3-mzsxd -- cat /opt/eap/extensions/actions.cli
embed-server --std-out=echo --admin-only --server-config=standalone-openshift.xml 
/socket-binding-group=standard-sockets/remote-destination-outbound-socket-binding=remote-rhdg-server:add(host=rhdg8-cluster.eap-test.svc.cluster.local,port=11222)
batch
/subsystem=infinispan/remote-cache-container=rhdg:add(default-remote-cluster=data-grid-cluster,\
        properties={infinispan.client.hotrod.use_auth=true,infinispan.client.hotrod.sasl_properties.javax.security.sasl.qop=auth,infinispan.client.hotrod.sasl_mechanism=SCRAM-SHA-512,infinispan.client.hotrod.auth_username=developer,infinispan.client.hotrod.auth_server_name=eap-infinispan,infinispan.client.hotrod.auth_password=Cx2ak@E9fGcaSfs4,infinispan.client.hotrod.use_ssl=false,infinispan.client.hotrod.auth_realm=default})
/subsystem=infinispan/remote-cache-container=rhdg/remote-cluster=data-grid-cluster:add(socket-bindings=[remote-rhdg-server])
run-batch
batch
/subsystem=infinispan/cache-container=web/invalidation-cache=infinispan:add()
/subsystem=infinispan/cache-container=web/invalidation-cache=infinispan/store=hotrod:add( remote-cache-container=rhdg,\
                fetch-state=false,\
                purge=false,\
                passivation=false,\
                shared=true)
/subsystem=infinispan/cache-container=web/invalidation-cache=infinispan/component=transaction:add(mode=BATCH)
/subsystem=infinispan/cache-container=web/invalidation-cache=infinispan/component=locking:add(isolation=REPEATABLE_READ)
/subsystem=infinispan/cache-container=web:write-attribute(name=default-cache,value=infinispan)
run-batch
stop-embedded-server[fdemeloj@fdemeloj ocp]$ oc exec -it datagridtests-3-mzsxd -- cat /opt/eap/extensions/postconfigure.sh
$JBOSS_HOME/bin/jboss-cli.sh --file=$JBOSS_HOME/extensions/actions.cli
~~~


Creating remote cache container rhdg:
~~~
05:04:30,781 INFO [org.jboss.as.clustering.infinispan] (ServerService Thread Pool -- 81) WFLYCLINF0029: Started remote cache container 'rhdg'.
~~~

Get the CRs:
~~~
$ oc api-resources | grep infinispan
backups                                                   infinispan.org                        true         Backup
batches                                                   infinispan.org                        true         Batch
caches                                                    infinispan.org                        true         Cache
infinispans                                               infinispan.org                        true         Infinispan
restores                                                  infinispan.org                        true         Restore
~~~

Tasks:
1. update the socket-bindings --> update configmap
2. update user (and put user on DG via credentials) ---> update cache yaml
3. add HotRod details ---> update cache yaml

Editing configmap::

oc delete cm/jboss-cli
oc create configmap jboss-cli --from-file=postconfigure.sh=postconfigure.sh --from-file=actions.cli=actions.cli
oc set volume dc/datagridtests --add --name=jboss-cli -m /opt/eap/extensions -t configmap --configmap-name=jboss-cli --default-mode='0777' --overwrite
oc scale dc/datagridtests --replicas=0
oc scale dc/datagridtests --replicas=2


###Tests:
1. Set cm with details on DG 8
2. /socket-binding-group=standard-sockets/remote-destination-outbound-socket-binding=remote-rhdg-server:add(host=10.129.2.14,port=11222)