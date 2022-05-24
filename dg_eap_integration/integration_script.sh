#!/bin/bash
# Simple bash script to integrate DG and EAP 7 given the user and password
#script steps:
#1. mkdir DGIntegration [done]
#2. download DG 8 [done]
#3. downloaod EAP 7 [done]
#4. unzip both [done]
#5. run cli for dg 8 [done]
#6. copy standalone-full-ha.xml to standalone/configuration [done]
#7. copy the deployment verify-cluster.war [done]
#8. run both [done]

mkdir DGIntegration;
wget -P DGIntegration http://download.eng.rdu2.redhat.com/released/JBoss-middleware//eap7/7.4.0/jboss-eap-7.4.0.zip
wget -P DGIntegration http://download.eng.rdu2.redhat.com/released/JBoss-middleware/datagrid/8.3.1/redhat-datagrid-8.3.1-server.zip
## wget -P https://github.com/varsharain-a11y/distributable/blob/main/verify-cluster.war
## wget https://github.com/FranciscoMeloJr/datagrid_tests/tree/main/dg_eap_integration/verify-cluster.war
## wget -P https://github.com/FranciscoMeloJr/datagrid_tests/tree/main/dg_eap_integration/standalone-full-ha.xml

## sleep:
sleep 10s

### do the process
cd DGIntegration;
unzip jboss-eap-7.4.0.zip;
unzip redhat-datagrid-8.3.1-server.zip;
cp ../standalone-full-ha.xml jboss-eap-7.4/standalone/configuration/standalone-full-ha.xml

./redhat-datagrid-8.3.1-server/bin/cli.sh user create rhdgadmin -p password@2 -g admin
cp ../caches.xml redhat-datagrid-8.3.1-server/server/data/

cd redhat-datagrid-8.3.1-server
export RHDG=$PWD
echo $RHDG
./bin/server.sh &
cd ..
cd jboss-eap-7.4
export JBOSS_HOME=$PWD
echo $JBOSS_HOME
./bin/add-user.sh -u 'admin' -p 'admin' 
./bin/standalone.sh -c standalone-full-ha.xml &
cd ..
sleep 30s
cp ../verify-cluster.war jboss-eap-7.4/standalone/deployments
sleep 30s
curl http://127.0.0.1:8080/verify-cluster/counter
### Remove
#rm -r DGIntegration;
