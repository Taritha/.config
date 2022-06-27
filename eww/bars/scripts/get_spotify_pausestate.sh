#!/bin/bash

while sleep 0.5s; do
    STATUS="$(playerctl --player='spotify' status)"
    if [[ "$STATUS" == "Playing" ]]; then
        echo ""
    elif [[ "$STATUS" == "Paused" ]]; then
        echo "契"
    else
        echo "栗"
    fi
done