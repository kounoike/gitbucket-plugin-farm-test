#!/bin/bash

BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
echo $BUILD_DATE

. gitbucket_version.sh

mkdir dist
mkdir json

cd plugins

for target in *; do
    echo $target
    pushd $target
    . $target.sh
    
    wget $PLUGIN_SRC_TGZ_URL
    tar zxf $(basename $PLUGIN_SRC_TGZ_URL)
    cd $PLUGIN_SRC_DIR

    sed -i -e "s/gitbucketVersion *:= *\"[0-9.]*\"/gitbucketVersion := \"${GITBUCKET_VERSION}\"/" build.sbt
    sbt assembly

    mv ${PLUGIN_JAR} ${TRAVIS_BUILD_DIR}/dist/

    cat <<EOS > ${TRAVIS_BUILD_DIR}/json/${PLUGIN_ID}.json
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
