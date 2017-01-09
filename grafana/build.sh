#!/bin/bash

set -e

PREFIX=${DOCKER_PREFIX:-blackbelt}
GRAFANA_VERSION=${1:-4.0.2-1481203731}

CWD="`dirname $0`"

docker build -t "${PREFIX}/grafana" --build-arg "GRAFANA_VERSION=${GRAFANA_VERSION}" "${CWD}"
docker tag  "${PREFIX}/grafana" "${PREFIX}/grafana:${GRAFANA_VERSION}" 
if [ "x1" == "x${PUSH_DOCKER_IMAGE}" ]
then
    docker push "${PREFIX}/grafana"
fi
