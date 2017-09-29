#!/bin/bash

set -e

PREFIX=${DOCKER_PREFIX:-blackbelt}
INFLUXDB_VERSION=${1:-1.3.6}

CWD="`dirname $0`"

if [ "${INFLUXDB_VERSION}" \> "0" ]
then
    cp "${CWD}/config-1.0.toml" "${CWD}/config.toml"
else
    cp "${CWD}/config-0.x.toml" "${CWD}/config.toml"
fi

docker build -t "${PREFIX}/influxdb" --build-arg "INFLUXDB_VERSION=${INFLUXDB_VERSION}" "${CWD}"
docker tag  "${PREFIX}/influxdb" "${PREFIX}/influxdb:${INFLUXDB_VERSION}" 

rm -f "${CWD}/config.toml"

if [ "x1" == "x${PUSH_DOCKER_IMAGE}" ]
then
    docker push "${PREFIX}/influxdb"
fi

