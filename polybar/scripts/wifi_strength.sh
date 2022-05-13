#!/usr/bin/env bash

CONNECTED="$(iwgetid -r)"
#sig_strength=$(nmcli dev wifi list | awk '/\*/{if (NR!=1) {print $7}}')
if [ "$CONNECTED" != "" ]; then
    echo "直 "
else
    echo "睊 "
fi
