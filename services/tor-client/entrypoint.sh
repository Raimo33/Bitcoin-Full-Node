#!/bin/sh
set -eu

: "${TOR_CONTROL_PASSWORD:?TOR_CONTROL_PASSWORD must be set}"

hashed_control_password="$(tor --hash-password "$TOR_CONTROL_PASSWORD" | tail -n 1)"

exec tor -f /etc/tor/torrc --HashedControlPassword "$hashed_control_password" "$@"
