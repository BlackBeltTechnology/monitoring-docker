FROM frolvlad/alpine-glibc:alpine-3.4
MAINTAINER József Börcsök "jozsef.borcsok@blackbelt.hu"
MAINTAINER Robert Csakany "robert.csakany@blackbelt.hu"

ARG INFLUXDB_VERSION

ENV CONFIG_FILE="/config/config.toml"

RUN set -e \
    && apk add --update --virtual=build-dependencies ca-certificates wget \
    && if [[ "${INFLUXDB_VERSION}" > "0.12" -a "${INFLUXDB_VERSION}" \< "0.13"  -o "${INFLUXDB_VERSION}" > "1.3.5" ]]; then tmp="/tmp/influxdb-${INFLUXDB_VERSION}"; else tmp="/tmp"; fi \
    && mkdir -p "${tmp}" \
    && if [[ "${INFLUXDB_VERSION}" > "0.13" ]]; then DOWNLOAD_VERSION=`echo "${INFLUXDB_VERSION}" | sed s/-.*//`; else DOWNLOAD_VERSION="${INFLUXDB_VERSION}"; fi \
    && TGZ_FILE_NAME="influxdb-${DOWNLOAD_VERSION}_linux_amd64.tar.gz" \
    && wget -O "/tmp/${TGZ_FILE_NAME}" "https://dl.influxdata.com/influxdb/releases/${TGZ_FILE_NAME}" \
    && tar xvfz "/tmp/${TGZ_FILE_NAME}" -C "${tmp}" \
    && cp -r /tmp/influxdb-*/* / \
    && apk del build-dependencies \
    && rm -rf "/tmp/"*

RUN set -e \
    && echo -e "#!/bin/sh\n" > "/usr/bin/influxdb.sh" \
    # Dynamically change the value of 'max-open-shards' to what 'ulimit -n' returns
    && echo 'sed -i "s/^max-open-shards.*/max-open-shards = $(ulimit -n)/" ${CONFIG_FILE}' >> "/usr/bin/influxdb.sh" \
    && echo '/usr/bin/influxd -config=${CONFIG_FILE} $@' >> "/usr/bin/influxdb.sh" \
    && chmod +x "/usr/bin/influxdb.sh"

ADD types.db /usr/share/collectd/types.db
ADD config.toml ${CONFIG_FILE}

# Admin server WebUI
EXPOSE 8083

# HTTP API
EXPOSE 8086

# Graphite API
EXPOSE 2003

# CollectD
EXPOSE 25826/udp

# Raft port (for clustering, don't expose publicly!)
#EXPOSE 8090

# Protobuf port (for clustering, don't expose publicly!)
#EXPOSE 8099

VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/influxdb.sh"]

