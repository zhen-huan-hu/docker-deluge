FROM docker.io/alpine:edge

RUN set -ex && \
    apk update && \
    apk add --no-cache --upgrade deluge

COPY ./entrypoint.sh /usr/local/bin
COPY ./core.conf /defaults/core.conf

RUN set -ex && \
    chmod 755 /usr/local/bin/entrypoint.sh && \
    chmod 644 /defaults/core.conf

ENV DELUGE_USER=
ENV DELUGE_PASSWORD=
ENV DELUGE_UMASK=0022
ENV TZ=America/Chicago

EXPOSE 58846 56881 56881/udp
VOLUME /config /downloads

ENTRYPOINT [ "/usr/local/bin/entrypoint.sh" ]