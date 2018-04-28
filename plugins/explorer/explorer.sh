#!/bin/sh

PLUGIN_BUILD_ENABLED=true

PLUGIN_REPOSITORY_OWNER=gitbucket-plugins
PLUGIN_REPOSITORY_NAME=gitbucket-explorer-plugin

PLUGIN_ID=explorer
PLUGIN_NAME="Project explorer Plugin"
PLUGIN_DESCRIPTION="Explore Files from the file tree in the repository"
PLUGIN_VERSION=6.0.0
PLUGIN_TAG_NAME=${PLUGIN_VERSION}

PLUGIN_IS_DEFAULT=false

PLUGIN_PROJECT_URL=https://github.com/${PLUGIN_REPOSITORY_OWNER}/${PLUGIN_REPOSITORY_NAME}

PLUGIN_SRC_TGZ_URL=https://github.com/${PLUGIN_REPOSITORY_OWNER}/${PLUGIN_REPOSITORY_NAME}/archive/${PLUGIN_TAG_NAME}.tar.gz
PLUGIN_SRC_DIR=${PLUGIN_REPOSITORY_NAME}-${PLUGIN_TAG_NAME}

PLUGIN_JAR=target/scala-2.12/gitbucket-${PLUGIN_ID}-plugin-assembly-${PLUGIN_VERSION}.jar
