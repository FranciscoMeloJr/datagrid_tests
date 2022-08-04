Test setting cpu request:limits for 6:2 to confirm threads generated

~~~
  spec:
    configMapName: "${CLUSTER_NAME}-custom-config" 
    container:
      cpu: 6:2
      extraJvmOpts: '-Xlog:gc*=info:file=/tmp/gc.log:time,level,tags,uptimemillis:filecount=10,filesize=1m
              -Dcom.redhat.fips=false -Dio.netty.allocator.type=unpooled'
      memory: 3Gi
~~~

Cluster bot doesn't have resources or limits those resources


