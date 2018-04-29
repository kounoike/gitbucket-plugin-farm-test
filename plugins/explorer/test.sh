#!/bin/bash

wget -O explore.json http://localhost:8080/root/explorer-repo/explore || exit 1

grep -q test.txt explore.json || exit 1

exit 0