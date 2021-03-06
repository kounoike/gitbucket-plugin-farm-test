#!/bin/bash

FARM_BASE_URL=https://github.com/kounoike/gitbucket-plugin-farm-test/releases/download
BUILD_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")
. gitbucket_version.sh

buildPlugin() {
    target=$1

    . $target.sh

    # get source
    if [ $PLUGIN_TAG_NAME == "master" ]; then
        wget -q $PLUGIN_SRC_TGZ_URL
        tar zxf $(basename $PLUGIN_SRC_TGZ_URL)
        cd $PLUGIN_SRC_DIR
    else
        tgz_cache=$HOME/Downloads/${PLUGIN_ID}-${PLUGIN_TAG_NAME}.tar.gz
        wget -O $tgz_cache -q $PLUGIN_SRC_TGZ_URL
        tar zxf $tgz_cache
        cd $PLUGIN_SRC_DIR
    fi

    # change gitbucketVersion
    sed -i -e "s/\\s*gitbucketVersion\\s*:=.*/gitbucketVersion := \"${GITBUCKET_VERSION}\"/" build.sbt

    # change scalaVersion
    sed -i -e "s/\\s*scalaVersion\\s*:=.*/scalaVersion := \"${SCALA_VERSION}\"/" build.sbt

    # change sbt.version
    if [ -e project/build.properties ]; then
        sed -i -e "s/sbt.version\\s*=.*/sbt.version = ${SBT_VERSION}/" project/build.properties
    fi

    # build plugin
    if [ -e ../build.sh ]; then
        bash ../build.sh >&2 || return
    else
        sbt assembly >&2 || return
    fi

    # copy artifact
    PLUGINS_DIR=${HOME}/.gitbucket/plugins/
    if [ -e ${PLUGIN_JAR} ]; then
        [ -d ${PLUGINS_DIR} ] || mkdir -p ${PLUGINS_DIR}
        cp -f ${PLUGIN_JAR} ${PLUGINS_DIR}
        mv ${PLUGIN_JAR} ${TRAVIS_BUILD_DIR}/dist/
    else
        return
    fi

    # check plugin list api
    sleep 5 # wait for load plugin
    plugins=$(curl -sS http://localhost:8080/api/v3/gitbucket/plugins)
    echo $plugins | jq -e ".[] | select(.id == \"${PLUGIN_ID}\")" > /dev/null
    if [ $? != 0 ] ; then
        echo "plugin doesn't loaded?" >&2
        rm -f ${PLUGINS_DIR}/$(basename ${PLUGIN_JAR})
        return
    fi

    # test plugin
    if [ -e ../test.sh ]; then
        bash ../test.sh >&2 || return
    fi

    # make json flagment
    json=$( jq -c . <<EOS
{
    "id": "${PLUGIN_ID}",
    "name": "${PLUGIN_NAME}",
    "description": "${PLUGIN_DESCRIPTION}",
    "versions": [
        {
            "version": "${PLUGIN_VERSION}",
            "range": ">=${GITBUCKET_VERSION}",
            "url": "${FARM_BASE_URL}/${GITBUCKET_VERSION}/$(basename ${PLUGIN_JAR})",
            "jarFileName": "$(basename ${PLUGIN_JAR})"
        }
    ],
    "default": ${PLUGIN_IS_DEFAULT}
}
EOS
)
    echo "$json"
}

mkdir -p dist
json_array=()
fail_array=()

git config --global credential.helper "store --file $HOME/.git-credentials"
echo "http://root:root@localhost%3a8080" > ~/.git-credentials

# create repository for test
(
    curl -u root:root -H "Content-type: application/json" -X POST -d "{\"name\": \"repo\"}" http://localhost:8080/api/v3/user/repos || exit 1
    pushd repo
    git init .
    git add .
    git commit . -m "test"
    git remote add origin http://localhost:8080/git/root/repo
    git push -u origin master || exit 1
    popd
) >&2 || exit 1

cd plugins

for target in *; do
    echo $target
    pushd $target
    
    # check PLUGIN_BUILD_ENABLED
    . $target.sh
    [ "$PLUGIN_BUILD_ENABLED" != "true" ] && continue

    json=$(buildPlugin $target)

    echo "build output: $json"
    if [ -z "$json" ]; then
        fail_array+=( $target )
    else
        json_array+=( $json )
    fi
    popd
done

if [ ${#fail_array[*]} != 0 ]; then
    echo "Failed to build:${fail_array[*]}"
    exit 1
else
    echo "[$(IFS=,;echo "${json_array[*]}")]" > ${TRAVIS_BUILD_DIR}/dist/plugins.json
    exit 0
fi
