Testing JFR file and custom image

Custom image:
~~~
    expose:
      type: LoadBalancer
    image: quay.io/fdemeloj1/dgjcmd:latest
~~~

JFR file:
~~~
      extraJvmOpts: '-Xlog:gc*=info:file=/tmp/gc.log:time,level,tags,uptimemillis:filecount=10,filesize=1m
              -Dcom.redhat.fips=false -XX:StartFlightRecording=duration=200s,filename=flight.jfr'
~~~

Reference: https://cloud.redhat.com/blog/gitops-deployment-and-image-management