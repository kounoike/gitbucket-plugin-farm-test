#!/bin/bash

. gitbucket_version.sh

BUILD_BASE_DIR=$(pwd)

mkdir dist
mkdir json

for target in plugins/*.sh; do
    echo $target
    . $target
    mkdir $PLUGIN_ID
    
    pushd $PLUGIN_ID
    
    wget $PLUGIN_TGZ_URL
    tar zxf $(basename $PLUGIN_TGZ_URL)
    cd $PLUGIN_SRC_DIR

    sed -i -e "s/gitbucketVersion *:= *\"[0-9.]*\"/gitbucketVersion := \"${GITBUCKET_VERSION}\"/" build.sbt
    sbt assembly

    [ -e ${PLUGIN_JAR} ]
    mv ${PLUGIN_JAR} ${BUILD_BASE_DIR}/dist/

    cat <<EOS > ${BUILD_BASE_DIR}/json/${PLUGIN_ID}.json
{
    "id": "${PLUGIN_ID}",
    "name": "${PLUGIN_NAME}",
    "description": "${PLUGIN_DESCRIPTION}",
    "versions": [
        {
            "version": "${PLUGIN_VERSION}",
            "range": ">=${GITBUCKET_VERSION}",
            "url": "${FARM_BASE_URL}/${GITBUCKET_VERSION}/$(basename ${PLUGIN_JAR})"
        }
    ],
    "default": ${PLUGIN_IS_DEFAULT}
}
EOS
    popd

done
