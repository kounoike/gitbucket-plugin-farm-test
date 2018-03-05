# gitbucket-plugin-farm

This repository makes possible to install plugins from remote repository and less cost for version compatibility.

# for plugin developper

## adding new plugin

This farm requires that plugin uses [sbt-gitbucket-plugin](https://github.com/gitbucket/sbt-gitbucket-plugin). Please use it and create tag with plugin version.

Please create PR to this repository. it contains `plugins/_plugin_name_/_plugin_name_.sh`

`_plugin_name_.sh` contains some variable settings:

|var_name|description|example|
|-----------|------------|----------|
|`PLUGIN_BUILD_ENABLED`|true if build this plugin on farm|true|
|`PLUGIN_ID`     |`PluginId` in `Plugin.scala`|gist|
|`PLUGIN_NAME`|`PluginName` in `Plugin.scala`|Gist Plugin|
|`PLUGIN_DESCRIPTION`|`description` in `Plugin.scala`|Provides Gist feature on GitBucket.|
|`PLUGIN_VERSION`|plugin version|4.12.0|
|`PLUGIN_TAG_NAME`|git tag name for this version|4.12.0|
|`PLUGIN_IS_DEFAULT`|true if this plugin as default install|false|
|`PLUGIN_REPOSITORY_OWNER`|github project owner|gitbucket|
|`PLUGIN_REPOSITORY_NAME`|github project name|gitbucket-gist-plugin|
|`PLUGIN_PROJECT_URL`|github project page url|`https://github.com/${PLUGIN_REPOSITORY_OWNER}/${PLUGIN_REPOSITORY_NAME}`|
|`PLUGIN_SRC_TGZ_URL`|plugin source tar.gz URL(from release page)|`https://github.com/${PLUGIN_REPOSITORY_OWNER}/${PLUGIN_REPOSITORY_NAME}/archive/${PLUGIN_TAG_NAME}.tar.gz`|
|`PLUGIN_SRC_DIR`|tar.gz archived source directory name|`${PLUGIN_REPOSITORY_NAME}-${PLUGIN_TAG_NAME}`|
|`PLUGIN_JAR`|output jar file path|`target/scala-2.12/gitbucket-${PLUGIN_ID}-plugin-assembly-${PLUGIN_VERSION}.jar`|

## update your plugin

Please create new tag in your repository and create PR to this repository with update `PLUGIN_VERSION`, `PLUGIN_TAG_NAME` etc.

# for GitBucket developper

When new GitBucket version released, please change `gitbucket_version.sh` and make same tag.
