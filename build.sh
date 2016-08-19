#!/bin/bash
cd ./influxdb/ && ./build.sh && cd ../grafana/ && ./build.sh && cd ../monitoring-init/ && ./build.sh && cd ..


