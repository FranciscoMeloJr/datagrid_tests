## Create project and operator:
oc process -f template-01-complete.yaml | oc apply -f - 
./script_approve_ip.sh
## Create infinispan:
oc process -f cluster-dg-01.yaml | oc apply -f -
## Get secret:
oc get secret infinispan-test-generated-secret -o jsonpath="{.data.identities\.yaml}" | base64 --decode

## Get secret:
oc get secret infinispan-test-cert-secret -o jsonpath='{.data.tls\.crt}' | base64 --decode > tls.crt

## Get service:
SERVICE_HOSTNAME=$(oc get service infinispan-test -o go-template --template='{{.metadata.name}}.{{.metadata.namespace}}.svc.cluster.local{{println}}')

## Create cache:
oc process -f mybatch.yaml | oc apply -f -

## Confirm cache creation:
./confirm_cache.sh

## Git clone
git clone -b openshift https://github.com/alexbarbosa1989/hotrodspringboot

## Export Java:
export JAVA_HOME=/home/fdemeloj/Downloads/cases/java-11-openjdk-11.0.15.0.9-3.portable.jdk.el.x86_64/

echo "Variables:"
export CLUSTER_NAME="infinispan-test"
echo "variable CLUSTER_NAME will be " $CLUSTER_NAME
echo "variable SERVICE_HOSTNAME will be " $SERVICE_HOSTNAME

### Create a new project:
oc new-project springboot-test

### Crate secret from truststore.jks file:
oc create secret generic truststore-secret --from-file=truststore.jks

### Deploy:
cd hotrodspringboot
mvn clean fabric8:deploy -Popenshift

## Get pods:
oc get pods

## Add secret in /mnt/secrets,
oc set volume dc/hotrodspringboot --add --name=truststore-secret -m /mnt/secrets/ -t secret --secret-name=truststore-secret --default-mode='0755'

## Get routes
routename=$(oc get routes --no-headers | awk '{print $2}')

curl -X GET http://$routename/redhat/update-cache/sessions/cacheKey1/cacheValue1