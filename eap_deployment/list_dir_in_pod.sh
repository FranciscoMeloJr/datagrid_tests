#oc exec -it example-eap7-jdk11-tag-0 -- ls -lrt /opt/eap/modules/system/layers/base/org/jboss/ironjacamar/
oc exec -it $1 -- ls -lrt $2

#$ ./list_dir_in_pod.sh eap74-openjdk8-openshift-rhel7-1-z7sqv /opt/eap/modules/system/layers/base/org/jboss/ironjacamar/
#total 0
#drwxrwxr-x. 3 jboss root 18 Apr  4 10:34 jdbcadapters
#drwxrwxr-x. 3 jboss root 18 Apr  4 10:34 impl
#drwxrwxr-x. 3 jboss root 18 Apr  4 10:34 api