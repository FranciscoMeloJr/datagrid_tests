# dockerfile jcmd+ - sudo podman build --authfile=${HOME}/.docker/config.json -f Dockerfile . --tag customdg8build
FROM registry.redhat.io/datagrid/datagrid-8-rhel8:1.3-8.1655310541
COPY version.txt /opt/infinispan/version.txt
RUN mkdir -p /opt/infinispan/diag/bin
COPY lib/jcmd /opt/infinispan/diag/bin
RUN ln -s $JAVA_HOME/lib /opt/infinispan/diag

# setting alias in bashrc:
RUN echo 'alias jcmd="/opt/infinispan/diag/bin/./jcmd"' >> ~/.bashrc