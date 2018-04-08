#!/bin/bash

GITBUCKET_URL=https://github.com/gitbucket/gitbucket/releases/download/latest/gitbucket.war

wget $GITBUCKET_URL

nohup java -jar gitbucket.war >$HOME/gitbucket.log 2>&1 < /dev/null &

sleep 10
cat $HOME/gitbucket.log

popd
