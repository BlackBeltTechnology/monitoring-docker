FROM alpine:3.4
MAINTAINER J�zsef B�rcs�k "jozsef.borcsok@blackbelt.hu"
MAINTAINER Robert Csakany "robert.csakany@blackbelt.hu"

RUN apk add --update bash curl grep && rm -rf /var/cache/apk/* && \
    mkdir -p /logs

ADD dashboards.tar.gz /tmp
ADD init.sh /tmp/init.sh

VOLUME [ "/logs" ]

ENTRYPOINT [ "/bin/bash", "/tmp/init.sh" ]

