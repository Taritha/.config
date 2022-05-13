#!/usr/bin/env bash

STATUS="$(bluetoothctl show | grep Powered | cut -d ":" -f2)"

if [ "$STATUS" != " yes" ]; then
    echo " "
else
    echo " "
fi
