#!/bin/bash

PREFIX=${DOCKER_PREFIX:-blackbelt}

docker run -d --name monitoring-influxdb -p 8086:8086 -p 8083:8083 -p 2003:2003 -p 25826:25826 "${PREFIX}/influxdb"

