#!/bin/bash

GITBUCKET_VERSION=4.20.0

mkdir dist
mkdir json

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

    cp ${PLUGIN_NAME}/${PLUGIN_SRC_DIR}/${PLUGIN_JAR_PATH} dist/
    cat <<EOS > json/${PLUGIN_NAME}.json
{
    "name": "${PLUGIN_NAME}",
    "version": "${PLUGIN_VERSION}",
    "filename": "${PLUGIN_JAR_FILENAME}"
}
EOS
    ls json
    cat json/${PLUGIN_NAME}.json

done

ls dist
