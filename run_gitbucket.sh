#!/bin/bash

GITBUCKET_URL=$( curl -s https://api.github.com/repos/gitbucket/gitbucket/releases/latest 
  | jq -r '.assets[] | select(.name == "gitbucket.war") | .url ')

wget -O gitbucket.war $GITBUCKET_URL

nohup java -jar gitbucket.war >$HOME/gitbucket.log 2>&1 < /dev/null &

sleep 10
cat $HOME/gitbucket.log

popd
