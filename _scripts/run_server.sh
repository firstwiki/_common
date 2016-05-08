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

bundle exec jekyll serve --watch --config _config.yml${CFG} $INCREMENTAL "$@"
