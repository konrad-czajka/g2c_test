#!/usr/bin/env sh

# For working consul instance it shall return about 50 lines, for disabled it shall include one line with error message
IS_SERVER="$(consul info -rpc-addr=127.0.0.1:10153 | wc -l)"

if [ $IS_SERVER == "1" ]; then
    logger -s "Start in SERVER mode"
    /bin/consul agent -bootstrap -config-dir=/config -data-dir=/data/server
else
    logger -s "Start in client mode"
    /bin/consul agent -retry-join "127.0.0.1:10151" -retry-interval=5s -config-dir=/config -data-dir=/data/client
fi