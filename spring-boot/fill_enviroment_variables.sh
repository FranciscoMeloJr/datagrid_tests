CLUSTER_NAME=infinispan-test

### Show environment variable content
USER=$(oc get secret infinispan-test-generated-secret -o jsonpath="{.data.identities\.yaml}" | base64 --decode | awk 'NR==2 {print $3}')
PASSCODE=$(oc get secret infinispan-test-generated-secret -o jsonpath="{.data.identities\.yaml}" | base64 --decode | awk 'NR==3 {print $2}')

SERVICE_HOSTNAME=$(oc get service infinispan-test -o go-template --template='{{.metadata.name}}.{{.metadata.namespace}}.svc.cluster.local{{println}}')

echo "Variables:"
export CLUSTER_NAME="infinispan-test"
echo "variable CLUSTER_NAME will be " $CLUSTER_NAME
echo "variable SERVICE_HOSTNAME will be " $SERVICE_HOSTNAME
echo "variable USER will be " $USER
echo "variable PASSCODE will be " $PASSCODE