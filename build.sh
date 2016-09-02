#!/bin/bash

CWD=`dirname $0`

"${CWD}/influxdb/build.sh"

"${CWD}/grafana/build.sh"
