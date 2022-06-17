#!/usr/bin/env bash

# Gets name of default input
def_mic="$(pactl get-default-source)"
muted="$(pactl get-source-mute $def_mic)"

if [ "$muted" = "Mute: no" ]; then
    vol="$(pactl get-source-volume $def_mic | awk '{print $5}' | tr -d '%')"

    if [[ ${vol} -gt 50 ]]; then
        echo ""
    elif [[ ${vol} -lt 50 ]]; then
        echo ""
    fi
else
    echo ""
fi