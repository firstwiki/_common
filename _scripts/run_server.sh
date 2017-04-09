#!/bin/bash

if [ -f _common/_config_common.yml ]; then
    CFG=",_common/_config_common.yml"
elif [ -f _config_common.yml ]; then
    CFG=",_config_common.yml"
fi

INCREMENTAL="--incremental"
if [ "$1" == "--full" ]; then
    shift
    INCREMENTAL=""
fi

# weird bug in jekyll
rm -f _site/run_server.sh _site/_common/run_server.sh

bundle exec jekyll serve --watch --config _config.yml${CFG} $INCREMENTAL "$@"
