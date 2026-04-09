# syntax=docker/dockerfile:1

FROM alpine:3.23 AS final

RUN set -ex && \
    apk update && \
    apk add --no-cache --upgrade \
        bash \
        deluge

COPY --chmod=755 ./entrypoint.sh /app/entrypoint.sh

COPY --chmod=644 ./core.conf /app/defaults/core.conf

ENV DELUGE_USER= \
    DELUGE_PASSWORD= \
    DELUGE_UMASK=0022 \
    TZ=America/Chicago

EXPOSE 58846 56881 56881/udp

WORKDIR /config

VOLUME /downloads

CMD ["/bin/bash", "/app/entrypoint.sh"]
