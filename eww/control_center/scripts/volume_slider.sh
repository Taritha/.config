#!/usr/bin/env bash

if [[ "$(pamixer --get-mute)" == "false" ]]; then
    vol="$(pamixer --get-volume)"

    if [[ ${vol} == 0 ]]; then
        echo "ﱝ"
    elif [[ ${vol} -lt 33 ]]; then
        echo ""
    elif [[ ${vol} -lt 66 ]]; then
        echo ""
    elif [[ ${vol} -le 100 ]]; then
        echo ""
    else
        echo "ﱝ"
    fi
else
    echo "ﱝ"
fi