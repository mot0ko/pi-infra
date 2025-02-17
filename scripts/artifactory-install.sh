#!/bin/bash

export JFROG_HOME="$SERVER_DATADIR/artifactory"
echo "JFROG_HOME=$JFROG_HOME" >> /etc/environment

mkdir -p $JFROG_HOME/artifactory/var/etc/
cd $JFROG_HOME/artifactory/var/etc/
touch ./system.yaml
echo "shared:" >> ./system.yaml
echo "  database:" >> ./system.yaml
echo "    allowNonPostgresql: true" >> ./system.yaml

chown -R 1030:1030 $JFROG_HOME/artifactory/var
chmod -R 777 $JFROG_HOME/artifactory/var

docker run --name artifactory -v $JFROG_HOME/artifactory/var/:/var/opt/jfrog/artifactory -d -p 8081:8081 -p 8082:8082 releases-docker.jfrog.io/jfrog/artifactory-oss:latest
