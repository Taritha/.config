#!/usr/bin/env bash

# Gets name of default input
def_mic="$(pactl get-default-source)"
muted="$(pactl get-source-mute $def_mic)"

toggle() {
    if [[ "$muted" == "Mute: no" ]]; then
        pactl set-source-mute $def_mic toggle
        dunstify -u normal "Microphone" "Mic volume muted"
    else
        pactl set-source-mute $def_mic toggle
        dunstify -u normal "Microphone" "Mic volume umuted"
    fi
}

status() {
    if [[ "$muted" == "Mute: no" ]]; then
        echo ""
    else
        echo ""
    fi
}

if [[ $1 == "--toggle" ]]; then
    toggle
elif [[ $1 == "--status" ]]; then
    status
fi