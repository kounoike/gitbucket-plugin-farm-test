#!/bin/bash

echo "test!"
exit 1

npm install && npm run-script release && sbt assembly