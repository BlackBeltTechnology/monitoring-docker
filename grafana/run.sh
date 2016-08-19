#!/bin/bash
PREFIX=${DOCKER_PREFIX:-blackbelt}

docker run -d --name monitoring-grafana -p 3000:3000 "${PREFIX}/grafana"

