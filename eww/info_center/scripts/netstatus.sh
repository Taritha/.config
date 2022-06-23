#! /bin/sh


INTERFACE="$1"
STATUS="$(nmcli dev status | grep -w "$INTERFACE" | grep -wv "p2p" | awk '{ print $3 }')"

echo $STATUS