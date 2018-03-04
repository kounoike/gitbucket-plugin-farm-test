#!/bin/bash

GITBUCKET_VERSION=4.20.0

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

    [ -e ${PLUGIN_JAR_PATH} ]

    popd

    cp ${PLUGIN_ID}/${PLUGIN_SRC_DIR}/${PLUGIN_JAR_PATH} dist/
    cat <<EOS > json/${PLUGIN_ID}.json
{
    "id": "${PLUGIN_ID}",
    "name": "${PLUGIN_NAME}",
    "description": "${PLUGIN_DESCRIPTION}",
    "versions": [
        {
            "version": "${PLUGIN_VERSION}",
            "range": ">=${GITBUCKET_VERSION}",
            "url": "${FARM_BASE_URL}/${GITBUCKET_VERSION}/${PLUGIN_JAR_FILENAME}"
        }
    ],
    "default": ${PLUGIN_IS_DEFAULT}
}
EOS
    ls json
    cat json/${PLUGIN_ID}.json

done

ls dist
