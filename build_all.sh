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
    
    # check PLUGIN_BUILD_ENABLED
    [ "$PLUGIN_BUILD_ENABLED" != "true" ] && continue

    # get source
    wget $PLUGIN_SRC_TGZ_URL
    tar zxf $(basename $PLUGIN_SRC_TGZ_URL)
    cd $PLUGIN_SRC_DIR

    # change gitbucketVersion
    sed -i -e "s/\\s*gitbucketVersion\\s*:=.*/gitbucketVersion := \"${GITBUCKET_VERSION}\"/" build.sbt

    # change scalaVersion
    sed -i -e "s/\\s*scalaVersion\\s*:=.*/scalaVersion := \"${SCALA_VERSION}\"/" build.sbt

    # change sbt.version
    if [ -e project/build.properties ]; then
        sed -i -e "s/sbt.version\\s*=.*/sbt.version = ${SBT_VERSION}/" project/build.properties
    fi

    # build plugin
    sbt assembly

    # copy artifact
    mv ${PLUGIN_JAR} ${TRAVIS_BUILD_DIR}/dist/

    # make json flagment
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
