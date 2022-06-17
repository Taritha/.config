#!/usr/bin/env bash

def_mic="$(pactl get-default-source)"
muted="$(pactl get-source-mute $def_mic)"

if [[ "$muted" == "Mute: no" ]]; then
    floatval=$1
    # Casts float to int
    int=${floatval%.*}
    pactl set-source-volume "$def_mic" "$int"%
fi
