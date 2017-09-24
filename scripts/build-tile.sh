#!/usr/bin/env bash

set -e

if [ "$0" != "./scripts/build-tile.sh" ]; then
    echo "'build-tile.sh' should be run from repository root"
    exit 1
fi

echo "Debugging info"
pip show tile-generator

pushd tile

tile build

popd
