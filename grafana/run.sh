#!/bin/bash
PREFIX=${DOCKER_PREFIX:-blackbelt}

# docker volume create grafana-config
# docker volume create grafana-data
# docker volume create grafana-log

docker run -d --name grafana -v grafana-config:/opt/grafana/conf -v grafana-data:/var/lib/grafana -v grafana-log:/var/log/grafana -p 3000:3000 "${PREFIX}/grafana"

