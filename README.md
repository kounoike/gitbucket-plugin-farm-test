# gitbucket-plugin-farm

This repository makes possible to install plugins from remote repository and less cost for version compatibility.

# for plugin developper

## adding new plugin

This farm requires that plugin uses [sbt-gitbucket-plugin](https://github.com/gitbucket/sbt-gitbucket-plugin). Please use it.

Please create PR it contains `plugins/_plugin_name_/_plugin_name_.sh`

`_plugin_name_.sh` contains:

- `PLUGIN_ID`
- `PLUGIN_NAME`
- `PLUGIN_DESCRIPTION`
- `PLUGIN_VERSION`
- `PLUGIN_TAG_NAME`
- `PLUGIN_IS_DEFAULT`
- `PLUGIN_REPOSITORY_OWNER`
- `PLUGIN_REPOSITORY_NAME`
- `PLUGIN_PROJECT_URL`
- `PLUGIN_SRC_TGZ_URL`
- `PLUGIN_SRC_DIR`
- `PLUGIN_JAR`

## update your plugin

Please create PR with update `PLUGIN_VERSION`, `PLUGIN_TAG_NAME` etc.

# for GitBucket developper

When new GitBucket version released, please change `gitbucket_version.sh` and make same tag.
