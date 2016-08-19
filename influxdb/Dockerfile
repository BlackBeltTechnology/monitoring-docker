FROM frolvlad/alpine-glibc:alpine-3.3_glibc-2.23
MAINTAINER Robert Csakany "robert.csakany@blackbelt.hu"

ARG INFLUXDB_VERSION

ENV CONFIG_FILE="/config/config.toml"

RUN apk add --update --virtual=build-dependencies ca-certificates wget && \
    if [[ "${INFLUXDB_VERSION}" > "0.12" -a "${INFLUXDB_VERSION}" < "0.13" ]]; then tmp="/tmp/influxdb-${INFLUXDB_VERSION}"; else tmp="/tmp"; fi && \
    mkdir -p "${tmp}" && \
    cd "/tmp" && \
    if [[ "${INFLUXDB_VERSION}" > "0.13" ]]; then dlVersion=`echo "${INFLUXDB_VERSION}" | sed s/-.*//`; else dlVersion="${INFLUXDB_VERSION}"; fi && \
    wget "https://dl.influxdata.com/influxdb/releases/influxdb-${dlVersion}_linux_amd64.tar.gz" && \
    tar xvfz "influxdb-${dlVersion}_linux_amd64.tar.gz" -C "${tmp}" && \
    cp -r "/tmp/influxdb-${INFLUXDB_VERSION}/"* / && \
    rm -r "/tmp/influxdb-${INFLUXDB_VERSION}" && \
    apk del build-dependencies && \
    rm "/tmp/"*

RUN echo -e "#!/bin/sh\n" > "/usr/bin/influxdb.sh" && \
    # Dynamically change the value of 'max-open-shards' to what 'ulimit -n' returns
    echo 'sed -i "s/^max-open-shards.*/max-open-shards = $(ulimit -n)/" ${CONFIG_FILE}' >> "/usr/bin/influxdb.sh" && \
    echo '/usr/bin/influxd -config=${CONFIG_FILE} $@' >> "/usr/bin/influxdb.sh" && \
    chmod +x "/usr/bin/influxdb.sh"

ADD types.db /usr/share/collectd/types.db
ADD config.toml ${CONFIG_FILE}

# Admin server WebUI
EXPOSE 8083

# HTTP API
EXPOSE 8086

# Graphite API
EXPOSE 2003

# Raft port (for clustering, don't expose publicly!)
#EXPOSE 8090

# Protobuf port (for clustering, don't expose publicly!)
#EXPOSE 8099

VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/influxdb.sh"]

