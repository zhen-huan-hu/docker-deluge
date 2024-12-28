#!/bin/sh

set -eu

mkdir -p /config/log /config/plugins

if [ ! -f /config/core.conf ]; then
    install -m 600 /defaults/core.conf /config/core.conf
fi

if [ -n "${DELUGE_USER}" ] && [ -n "${DELUGE_PASSWORD}" ]; then
    install -m 600 <(echo "${DELUGE_USER}:${DELUGE_PASSWORD}:10") /config/auth
elif [ ! -f /config/auth ]; then
    install -m 600 <(echo "admin:password:10") /config/auth
fi

[ -n "${DELUGE_UMASK}" ] && umask ${DELUGE_UMASK}

exec deluged \
    --do-not-daemonize \
    --config=/config \
    --logfile=/config/log/daemon.log \
    --loglevel=warning