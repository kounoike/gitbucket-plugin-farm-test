#!/bin/bash

### build gitbucket-master because plugin list API doesn't released yet

GITBUCKET_TGZ_URL=https://github.com/gitbucket/gitbucket/archive/master.tar.gz
GITBUCKET_SRC_DIR=gitbucket-master

wget $GITBUCKET_TGZ_URL

tar zxf $(basename $GITBUCKET_TGZ_URL)

pushd $GITBUCKET_SRC_DIR

sbt executable
nohup java -jar target/scala-2.12/gitbucket*.war &

popd

