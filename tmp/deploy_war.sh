#import image
oc import-image jboss-eap-7/eap74-openjdk8-openshift-rhel7 --from=registry.redhat.io/jboss-eap-7/eap74-openjdk8-openshift-rhel7:7.4.4-2 --confirm

## add the image with the 
mkdir /path/tmp/deployment
#get the verify-cluster and put in /path/tmp/deployment
oc new-app eap73-openjdk11-openshift-rhel8~/path/tmp/deployment --name=verify-cluster

# oc start-build APPLICATION_NAME --from-file=/tmp/verify-cluster.war (application under /tmp)
oc start-build verify-cluster --from-file=/path/tmp/deployment/verify-cluster.war


#### List the deploymet container
#$ oc get dc
#NAME                             REVISION   DESIRED   CURRENT   TRIGGERED BY
#eap74-openjdk8-openshift-rhel7   1          1         1         config,image(eap74-openjdk8-openshift-rhel7:7.4.4-2)
#verify-cluster                   2          1         1         config,image(verify-cluster:latest)

##Create the actions.cli and postconfigure.sh
$ oc create configmap jboss-cli --from-file=postconfigure.sh=postconfigure.sh --from-file=actions.cli=actions.cli
configmap/jboss-cli created

#$ oc get cm
#NAME                          DATA      AGE
#jboss-cli                     2         103s


### oc set volume setting the config map to the DC:
$ oc set volume dc/verify-cluster --add --name=jboss-cli -m /opt/eap/extensions -t configmap --configmap-name=jboss-cli --default-mode='0777'
deploymentconfig.apps.openshift.io/verify-cluster volume updated


### expose
$ oc expose svc/verify-cluster
route.route.openshift.io/verify-cluster exposed
