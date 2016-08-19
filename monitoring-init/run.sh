#!/bin/bash

PREFIX=${DOCKER_PREFIX:-blackbelt}

docker run -ti -e INFLUXDB_HOST=192.168.88.254 -e GRAFANA_HOST=192.168.88.254 --rm   "${PREFIX}/monitoring"

