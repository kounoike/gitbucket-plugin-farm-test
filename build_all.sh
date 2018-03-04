#!/bin/bash

GITBUCKET_VERSION=4.20.0

pwd
echo $HOME

mkdir dist
mkdir json

for build_target in plugins/*.sh; do
    echo $build_target
    . $build_target
    mkdir $PLUGIN_NAME
    
    pushd $PLUGIN_NAME
    
    wget $PLUGIN_TGZ_URL
    tar zxf $(basename $PLUGIN_TGZ_URL)
    cd $PLUGIN_SRC_DIR

    sed -i -e "s/gitbucketVersion *:= *\"[0-9.]*\"/gitbucketVersion := \"${GITBUCKET_VERSION}\"/" build.sbt
    sbt assembly

    ls build_target/scala-2.12

    popd

    cp ${build_target}/${PLUGIN_SRC_DIR}/${PLUGIN_JAR_PATH} dist/
    cat <<EOS > json/${build_target}.json
{
    name: ${PLUGIN_NAME},
    version: ${PLUGIN_VERSION},
    filename: ${PLUGIN_JAR_FILENAME}
}
EOS
    cat json/${build_target}.json

done

