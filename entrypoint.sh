#!/bin/sh

set -eu

mkdir -p /config/log /config/plugins

if [ ! -f /config/core.conf ]; then
    install -m 600 /app/defaults/core.conf /config/core.conf
fi

if [ -n "${DELUGE_USER:-}" ] && [ -n "${DELUGE_PASSWORD:-}" ]; then
    if [ ! -s /config/auth ] || ! grep -Fxq "${DELUGE_USER}:${DELUGE_PASSWORD}:10" /config/auth; then
        install -m 600 <(echo "${DELUGE_USER}:${DELUGE_PASSWORD}:10") /config/auth
    else
        echo "Account already exists. Ignore environment variables DELUGE_USER and DELUGE_PASSWORD."
    fi
elif [ ! -s /config/auth ]; then
    echo "No account exists. Environment variables DELUGE_USER and DELUGE_PASSWORD must be set once."
    exit 1
fi

[ -n "${DELUGE_UMASK:-}" ] && umask ${DELUGE_UMASK}

exec deluged \
    --do-not-daemonize \
    --config=/config \
    --logfile=/config/log/daemon.log \
    --loglevel=warning