#!/bin/bash

GRAFANA_HOST=${GRAFANA_HOST:-grafanasrv}
GRAFANA_PORT=${GRAFANA_PORT:-3000}
GRAFANA_USERNAME=${GRAFANA_USERNAME:-admin}
GRAFANA_PASSWORD=${GRAFANA_PASSWORD:-admin}
GRAFANA_DS_NAME=${GRAFANA_DS_NAME:-graphitedb}

GRAFANA_BASE_URL="http://${GRAFANA_USERNAME}:${GRAFANA_PASSWORD}@${GRAFANA_HOST}:${GRAFANA_PORT}"
GRAFANA_API_URL="${GRAFANA_BASE_URL}/api/"

INFLUXDB_HOST=${INFLUXDB_HOST:-influxsrv}
INFLUXDB_PORT=${INFLUXDB_PORT:-8086}
INFLUXDB_DS_USERNAME=${INFLUXDB_DS_USERNAME:-root}
INFLUXDB_DS_PASSWORD=${INFLUXDB_DS_PASSWORD:-root}

INFLUXDB_API_URL="http://${INFLUXDB_HOST}:${INFLUXDB_PORT}"

DASHBOARD_FILEMASK='/tmp/dashboards/*.json'

LOGS_DIR="/logs"
COMPLETED_FILE="${LOGS_DIR}/completed"

#COOKIEJAR=$(mktemp)
#trap 'unlink ${COOKIEJAR}' EXIT

RED="\033[01;31m"
YELLOW="\033[00;33m"
GREEN="\033[01;32m"
NO_COLOR="\033[0m"
BLUE="\033[01;34m"

function success {
  echo -e "${GREEN}""$*""${NO_COLOR}"
}

function info {
  echo -e "${BLUE}""$*""${NO_COLOR}"
}

function error {
  echo -e "${RED}""$*""${NO_COLOR}" 1>&2
}

function check_datasource {
  curl --silent "${GRAFANA_API_URL}datasources" | grep "\"name\":\"$1\"" --silent
}

function create_datasource {
  curl --silent -X POST -H 'Content-Type: application/json;charset=UTF-8' \
    --data-binary "{\"name\":\"$1\",\"type\":\"influxdb\",\"url\":\"${INFLUXDB_API_URL}\",\"access\":\"proxy\",\"database\":\"$1\",\"user\":\"${INFLUXDB_DS_USERNAME}\",\"password\":\"${INFLUXDB_DS_PASSWORD}\",\"isDefault\":true}" \
    "${GRAFANA_API_URL}datasources" 2>&1 | grep 'Datasource added' --silent
}

function check_and_create_datasource {
  if check_datasource "${GRAFANA_DS_NAME}"
  then
    info "Datasource already exists"
  else
    if create_datasource "${GRAFANA_DS_NAME}"
    then
      success "Created datasource: ${GRAFANA_DS_NAME}"
    else
      error "Unable to create datasource: ${GRAFANA_DS_NAME}"
    fi
  fi
}

function ensure_grafana_dashboards {
  if [ ! -z "${DASHBOARD_FILEMASK}" ]; then
    for DASHBOARD_FILE in `find ${DASHBOARD_FILEMASK} -type f`; do
      info "Uploading $DASHBOARD_FILE..."
      ensure_grafana_dashboard $DASHBOARD_FILE
    done
  fi
}

function ensure_grafana_dashboard {
  DASHBOARD_PATH=$1
  TEMP_DIR=$(mktemp -d)
  TEMP_FILE="${TEMP_DIR}/dashboard"

  # Need to wrap the dashboard json, and make sure the dashboard's "id" is null for insert
  echo '{"dashboard":' > $TEMP_FILE
  cat $DASHBOARD_PATH | sed -E 's/^  "id": [0-9]+,$/  "id": null,/' >> $TEMP_FILE
  echo ', "overwrite": true }' >> $TEMP_FILE

  curl --silent -X POST -H 'Content-Type: application/json;charset=UTF-8' \
       --data "@${TEMP_FILE}" \
       "${GRAFANA_API_URL}dashboards/db" > /dev/null 2>&1
  unlink $TEMP_FILE
  rmdir $TEMP_DIR
}

function waiting_to_start {
  status='000'
  while [ "x${status}" != "x200" ]
  do
    info "Trying to connect to: ${GRAFANA_BASE_URL}" 
    sleep 2;
    status=`curl -s -o /dev/null -w "%{http_code}" "${GRAFANA_BASE_URL}"`
  done
}

if [ ! -f "${COMPLETED_FILE}" ]
then
    waiting_to_start
    check_and_create_datasource
    ensure_grafana_dashboards
    touch "${COMPLETED_FILE}"
else
    info "Already initialized, nothing to do"
fi

