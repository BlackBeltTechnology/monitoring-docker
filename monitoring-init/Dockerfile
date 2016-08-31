FROM alpine:3.3
MAINTAINER József Börcsök "jozsef.borcsok@blackbelt.hu"
MAINTAINER Robert Csakany "robert.csakany@blackbelt.hu"

RUN apk add --update bash curl grep && rm -rf /var/cache/apk/* && \
    mkdir -p /logs

ADD dashboards.tar.gz /tmp
ADD init.sh /tmp/init.sh

VOLUME [ "/logs" ]

ENTRYPOINT [ "/bin/bash", "/tmp/init.sh" ]

