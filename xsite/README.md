DG Operator 8.3.5 Xsite test --> worked
===========================

1. oc process -f template-01-complete.yaml | oc apply -f -
2. oc process -f template-02-complete.yaml | oc apply -f -
3. Upgrade on the version both sites [below]
4. $ oc process -f cluster-dg-03.yaml | oc apply -f - | $ oc process -f cluster-dg-04.yaml | oc apply -f -
5. oc process -f template-03-complete.yaml | oc apply -f -
6. 34.72.108.39:11222/console vs 35.224.101.94:11222/console --> create caches with backup

From the templates in attach:
~~~
  spec:
    channel: 8.3.x
    installPlanApproval: Manual            <----
    name: datagrid
    source: redhat-operators
    sourceNamespace: openshift-marketplace 
    startingCSV: datagrid-operator.v8.3.5  <---- when setting startingCSV one must upgrade see notes
~~~


[upgrade]
~~~
$oc project dg-test-lon
$ oc get ip
NAME            CSV                        APPROVAL   APPROVED
install-z5qvk   datagrid-operator.v8.3.5   Manual     false
...
$ oc edit ip install-z5qvk --> approved true
installplan.operators.coreos.com/install-z5qvk edited
=====
$ oc project dg-test-nyc
Now using project "dg-test-nyc" on server "https://api.ci-ln-hhilk82-72292.origin-ci-int-gce.dev.rhcloud.com:6443".
$ oc get ip
NAME            CSV                        APPROVAL   APPROVED
install-5p822   datagrid-operator.v8.3.5   Manual     false
install-fkp9j   datagrid-operator.v8.3.5   Manual     false
$ oc edit ip install-5p822
installplan.operators.coreos.com/install-5p822 edited
~~~


Cache configuration:

~~~
  spec:
    clusterName: ${CLUSTER_NAME}
    name:  operator-cache-03
    template: >-
      <distributed-cache name="eu-customers" owners="1" mode="ASYNC" statistics="true">
        <encoding media-type="application/x-protostream"/>
        <state-transfer enabled="false"/>
        <memory>
          <binary eviction="MEMORY" size="400000000"/> <!-- 400 MB -->
        </memory>
        <expiration lifespan="600000"/> <!-- 10 min -->
          <backups>
          <backup site="SiteB"
                  strategy="ASYNC">
            <state-transfer chunk-size="600"
                            timeout="2400000"
                            max-retries="30"
                            wait-time="2000"
                            mode="AUTO"/>
          </backup>
        </backups>
      </distributed-cache>
~~~ 

VS
~~~
  spec:
    clusterName: ${CLUSTER_NAME}
    name:  operator-cache-03
    template: >-
      <distributed-cache name="eu-customers" owners="1" mode="ASYNC" statistics="true">
        <encoding media-type="application/x-protostream"/>
        <state-transfer enabled="false"/>
        <memory>
          <binary eviction="MEMORY" size="400000000"/> <!-- 400 MB -->
        </memory>
        <expiration lifespan="600000"/> <!-- 10 min -->
          <backups>
          <backup site="SiteA"
                  strategy="ASYNC">
            <state-transfer chunk-size="600"
                            timeout="2400000"
                            max-retries="30"
                            wait-time="2000"
                            mode="AUTO"/>
          </backup>
        </backups>
      </distributed-cache>
~~~tests with configmap
