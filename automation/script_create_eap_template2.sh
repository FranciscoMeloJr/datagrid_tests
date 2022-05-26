### Using template
oc delete project eap-demo
oc project default
oc process -f create-namespace.yaml | oc apply -f -
oc project eap-demo
oc new-app --template=eap74-basic-s2i -p EAP_IMAGE_NAME=jboss-eap74-openjdk8-openshift:latest -p EAP_RUNTIME_IMAGE_NAME=jboss-eap74-openjdk8-runtime-openshift:latest -p IMAGE_STREAM_NAMESPACE="myproject" -p SOURCE_REPOSITORY_URL="https://github.com/jboss-developer/jboss-eap-quickstarts" -p SOURCE_REPOSITORY_REF="7.4.x"