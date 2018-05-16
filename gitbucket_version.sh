GITBUCKET_VERSION=4.24.1
SCALA_VERSION=2.12.6
SBT_VERSION=1.1.5

if [ "${TRAVIS_EVENT_TYPE}" = "cron" ]; then
    GITBUCKET_USE_MASTER=yes
    GITBUCKET_TGZ_URL=https://github.com/gitbucket/gitbucket/archive/master.tar.gz
    GITBUCKET_SRC_DIR=$(pwd)/gitbucket-master

    if [ ! -e $HOME/master.tar.gz ]; then
        wget -O $HOME/master.tar.gz $GITBUCKET_TGZ_URL
        tar zxf $HOME/master.tar.gz
    fi

    pushd $GITBUCKET_SRC_DIR
         GITBUCKET_VERSION=$(sed -ne 's/val GitBucketVersion *= *"\(.*\)"/\1/p' build.sbt)
    popd
else
    GITBUCKET_USE_MASTER=no
fi