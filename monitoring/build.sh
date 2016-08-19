#!/bin/bash

PREFIX=${DOCKER_PREFIX:-blackbelt}

CWD="`dirname $0`"

docker build -t "${PREFIX}/monitoring"  "${CWD}"

