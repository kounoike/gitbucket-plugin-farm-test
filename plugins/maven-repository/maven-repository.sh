#!/bin/sh

PLUGIN_BUILD_ENABLED=true

PLUGIN_REPOSITORY_OWNER=takezoe
PLUGIN_REPOSITORY_NAME=gitbucket-maven-repository-plugin

PLUGIN_ID=maven-repository
PLUGIN_NAME="Maven Repsitory Plugin"
PLUGIN_DESCRIPTION="Host Maven repository on GitBucket."
PLUGIN_VERSION=1.2.1
PLUGIN_TAG_NAME=${PLUGIN_VERSION}

PLUGIN_IS_DEFAULT=false

PLUGIN_PROJECT_URL=https://github.com/${PLUGIN_REPOSITORY_OWNER}/${PLUGIN_REPOSITORY_NAME}

PLUGIN_SRC_TGZ_URL=https://github.com/${PLUGIN_REPOSITORY_OWNER}/${PLUGIN_REPOSITORY_NAME}/archive/${PLUGIN_TAG_NAME}.tar.gz
PLUGIN_SRC_DIR=${PLUGIN_REPOSITORY_NAME}-${PLUGIN_TAG_NAME}

PLUGIN_JAR=target/scala-2.12/gitbucket-${PLUGIN_ID}-plugin-assembly-${PLUGIN_VERSION}.jar