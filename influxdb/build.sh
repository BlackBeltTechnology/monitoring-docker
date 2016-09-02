#!/bin/bash

set -e

PREFIX=${DOCKER_PREFIX:-blackbelt}
INFLUXDB_VERSION=${1:-0.13.0-1}

CWD="`dirname $0`"

docker build -t "${PREFIX}/influxdb" --build-arg "INFLUXDB_VERSION=${INFLUXDB_VERSION}" "${CWD}"
docker tag  "${PREFIX}/influxdb" "${PREFIX}/influxdb:${INFLUXDB_VERSION}" 

if [ "x1" == "x${PUSH_DOCKER_IMAGE}" ]
then
    docker push "${PREFIX}/influxdb"
fi

