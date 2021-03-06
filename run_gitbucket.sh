#!/bin/bash

. gitbucket_version.sh

echo EVENT_TYPE:${TRAVIS_EVENT_TYPE}

if [ "$GITBUCKET_USE_MASTER" = "yes" ]; then
    pushd $GITBUCKET_SRC_DIR
    sbt executable publishLocal
    nohup java -jar target/executable/gitbucket.war >$HOME/gitbucket.log 2>&1 < /dev/null &
    popd
else
    GITBUCKET_URL=https://github.com/gitbucket/gitbucket/releases/download/${GITBUCKET_VERSION}/gitbucket.war

    if [ ! -e $HOME/Downloads/gitbucket.war ]; then
        wget -q -O $HOME/Downloads/gitbucket.war $GITBUCKET_URL
    fi
    nohup java -jar $HOME/Downloads/gitbucket.war >$HOME/gitbucket.log 2>&1 < /dev/null &
fi


while ! grep "Started ServerConnector" $HOME/gitbucket.log; do
    sleep 1
done
