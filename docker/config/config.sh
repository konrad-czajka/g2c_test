#!/usr/bin/env sh

checkConsul() {
    LEADER="$(curl --silent http://127.0.0.1:10004/v1/status/leader | grep -E '^\"[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}:[0-9]{1,5}\"$' | wc -l)"

    if [ ${LEADER} == "0" ]; then
        logger -s "Waiting for consul"
        sleep 1
        checkConsul
    fi
}

if [ ! -f /tmp/configured ]; then
    checkConsul

    logger -s "Upload default configuration into consul"

    curl -X PUT --data-binary "@/git2consul/config.json" http://127.0.0.1:10004/v1/kv/git2consul/config

    touch /tmp/configured
    logger -s "Default configuration was uploaded"
fi
