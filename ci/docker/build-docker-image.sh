#!/usr/bin/env bash

echo "Building and publishing docker image"

if [ "$0" != "./ci/docker/build-docker-image.sh" ]; then
    echo "'docker.sh' should be run from repository root"
    exit 1
fi

docker build ci/docker -t cfplatformeng/splunk-ci --no-cache
docker push cfplatformeng/splunk-ci
