#!/bin/bash

. gitbucket_version.sh

GITBUCKET_URL=https://github.com/gitbucket/gitbucket/releases/download/${GITBUCKET_VERSION}/gitbucket.war

wget -q -O $HOME/gitbucket.war $GITBUCKET_URL

nohup java -jar $HOME/gitbucket.war >$HOME/gitbucket.log 2>&1 < /dev/null &

sleep 10
cat $HOME/gitbucket.log
