echo "Create DG 8 <--> DG 8 setup"
../automation/script_setup_cluster.sh $1 $2 $3
oc process -f template-01-complete.yaml | oc apply -f -
oc process -f template-02-complete.yaml | oc apply -f -
oc process -f template-01-complete.yaml | oc apply -f -
oc project dg-test-lon; ../utils/script_approve_ip.sh 
oc project dg-test-nyc; ../utils/script_approve_ip.sh 
oc process -f template-03-complete.yaml | oc apply -f -
oc process -f template-04-complete.yaml | oc apply -f -
oc process -f cluster-dg-04.yaml | oc apply -f -
oc process -f cluster-dg-03.yaml | oc apply -f -
oc process -f mybatch.yaml | oc apply -f -