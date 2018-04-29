#!/bin/bash

wget -O explore.json http://localhost:8080/root/repo/explore || exit 1
cat explore.json

grep -q README.md explore.json || exit 1

exit 0