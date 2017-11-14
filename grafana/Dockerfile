FROM frolvlad/alpine-glibc:alpine-3.6
MAINTAINER József Börcsök "jozsef.borcsok@blackbelt.hu"
MAINTAINER Robert Csakany "robert.csakany@blackbelt.hu"

ARG GRAFANA_VERSION

ENV GRAFANA_HOME="/opt/grafana" \
    UID="${UID:-60000}"

ENV TGZ_FILE_NAME="grafana-${GRAFANA_VERSION}.linux-x64.tar.gz"

RUN set -e \
    && apk add --update --virtual=build-dependencies ca-certificates wget \
    && wget -O "/tmp/${TGZ_FILE_NAME}" "https://s3-us-west-2.amazonaws.com/grafana-releases/release/${TGZ_FILE_NAME}" \
    && apk del build-dependencies

RUN set -e \
    && mkdir -p "/opt" \
    && tar -xzf "/tmp/${TGZ_FILE_NAME}" -C "/opt" \
    && mv /opt/* "${GRAFANA_HOME}" \
    && ln -s "${GRAFANA_HOME}/bin/grafana-server" "/usr/bin/grafana-server" \
    && rm "/tmp/"* \
    && adduser -HD -u "${UID}" -h "${GRAFANA_HOME}" -s "/bin/sh" -G "users" "grafana" \
    && mkdir -p "/var/lib/grafana" \
    && mkdir -p "/var/log/grafana" \
    && chown -R "grafana" "${GRAFANA_HOME}" \
    && chown "grafana" "/var/log/grafana" \
    && chown "grafana" "/var/lib/grafana"

USER grafana
WORKDIR "${GRAFANA_HOME}"

VOLUME ["${GRAFANA_HOME}/conf"]
VOLUME ["/var/lib/grafana"]
VOLUME ["/var/log/grafana"]

EXPOSE 3000

ENTRYPOINT ["/usr/bin/grafana-server", "cfg:default.paths.logs=/var/log/grafana", "cfg:default.paths.data=/var/lib/grafana"]
