#!/usr/bin/env bash

muted="$(pamixer --get-mute)"

toggle() {
    if [ $muted == "false" ]; then
        pamixer -t
        dunstify -u normal "Volume" "Volume muted"
    else
        pamixer -t
        dunstify -u normal "Volume" "Volume umuted"
    fi
}

status() {
    if [ $muted == "false" ]; then
        echo ""
    else
        echo "ﱝ"
    fi
}

if [[ $1 == "--toggle" ]]; then
    toggle
elif [[ $1 == "--status" ]]; then
    status
fi