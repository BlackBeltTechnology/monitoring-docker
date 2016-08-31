FROM frolvlad/alpine-glibc:alpine-3.3_glibc-2.23
MAINTAINER József Börcsök "jozsef.borcsok@blackbelt.hu"
MAINTAINER Robert Csakany "robert.csakany@blackbelt.hu"

ARG GRAFANA_VERSION

ENV GRAFANA_HOME="/opt/grafana" \
    UID="${UID:-60000}"

RUN apk add --update --virtual=build-dependencies ca-certificates wget && \
    cd "/tmp" && \
    wget "https://grafanarel.s3.amazonaws.com/builds/grafana-${GRAFANA_VERSION}.linux-x64.tar.gz" && \
    tar -xzf "grafana-${GRAFANA_VERSION}.linux-x64.tar.gz" && \
    mkdir -p "/opt" && \
    mv "/tmp/grafana-${GRAFANA_VERSION}" "${GRAFANA_HOME}" && \
    apk del build-dependencies && \
    ln -s "${GRAFANA_HOME}/bin/grafana-server" "/usr/bin/grafana-server" && \
    rm "/tmp/"* && \
    adduser -HD -u "${UID}" -h "${GRAFANA_HOME}" -s "/bin/sh" -G "users" "grafana" && \
    mkdir -p "/var/lib/grafana" && \
    mkdir -p "/var/log/grafana" && \
    chown -R "grafana" "${GRAFANA_HOME}" && \
    chown "grafana" "/var/log/grafana" && \
    chown "grafana" "/var/lib/grafana"

USER grafana

WORKDIR "${GRAFANA_HOME}"

VOLUME ["${GRAFANA_HOME}/conf"]
VOLUME ["/var/lib/grafana"]
VOLUME ["/var/log/grafana"]

EXPOSE 3000

ENTRYPOINT ["/usr/bin/grafana-server", "cfg:default.paths.logs=/var/log/grafana", "cfg:default.paths.data=/var/lib/grafana"]

