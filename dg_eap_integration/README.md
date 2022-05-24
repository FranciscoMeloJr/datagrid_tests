## Integration script
The script integration_script downloads EAP, then DG, then set up the web cache integration, and then deploys a test app.
The result should be the app deployed and the cache integration working when accessing http://127.0.0.1:8080/verify-cluster/counter

### in OCP
Also in attachment the OCP templates to do the same in OCP 4 environment using EAP and DG operators: template-01-complete.yaml and cluster-dg-01.yaml.
The logs are for the OCP operatorion

#### Thanks
Thanks to Varsha Sharma's awesome testing application from https://github.com/varsharain-a11y/distributable/blob/main/verify-cluster.war
