#!/bin/bash

GITBUCKET_VERSION=4.20.0

pwd

echo $HOME

for target in plugins/*.sh; do
    echo $target
    . $target
    mkdir $PLUGIN_NAME
    
    pushd $PLUGIN_NAME
    
    wget $PLUGIN_TGZ_URL
    tar zxf $(basename $PLUGIN_TGZ_URL)
    cd $PLUGIN_SRC_DIR

    sed -i -e "s/gitbucketVersion *:= *\"[0-9.]*\"/gitbucketVersion := \"${GITBUCKET_VERSION}\"/" build.sbt
    sbt assembly

    ls target/scala-2.12

    popd
done

