#!/bin/bash

### build gitbucket-master because plugin list API doesn't released yet

GITBUCKET_TGZ_URL=https://github.com/gitbucket/gitbucket/archive/master.tar.gz
GITBUCKET_SRC_DIR=gitbucket-master

wget $GITBUCKET_TGZ_URL

tar zxf $(basename $GITBUCKET_TGZ_URL)

pushd $GITBUCKET_SRC_DIR

#sbt executable
#nohup java -jar target/scala-2.12/gitbucket*.war >$HOME/gitbucket.log 2>&1 < /dev/null &
nohup sbt jetty:start >$HOME/gitbucket.log 2>&1 < /dev/null &

sleep 10
cat ~/gitbucket.log

popd

