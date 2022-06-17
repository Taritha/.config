#!/usr/bin/env bash

STATUS=$(dunstctl is-paused)

toggle() {
    if [ $STATUS == "false" ]; then
        dunstctl set-paused true
    else
        dunstctl set-paused false
        notify-send --urgency=normal "Notification Toggle" "Notifications have been re-enabled"
    fi
}

status() {
    if [ $STATUS == "false" ]; then
        echo ""
    else
        echo ""
    fi
}

if [[ $1 == "--toggle" ]]; then
    toggle
    elif [[ $1 == "--status" ]]; then
    status
fi