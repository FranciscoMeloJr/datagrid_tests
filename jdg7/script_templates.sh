oc new-project jdg7-demo
for resource in cache-service-template.yaml \
  datagrid-service-template.yaml
do
  oc create -n openshift -f \
  https://raw.githubusercontent.com/jboss-container-images/jboss-datagrid-7-openshift-image/7.3-v1.9/services/${resource}
done

oc new-app cache-service -p APPLICATION_USER=username -p APPLICATION_PASSWORD=passcode
oc new-app datagrid-service -p APPLICATION_USER=username -p APPLICATION_PASSWORD=passcode -p NUMBER_OF_INSTANCES=3 -e AB_PROMETHEUS_ENABLE=true