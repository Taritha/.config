#!/usr/bin/env bash
STATUS=$(nmcli | grep wlan0: | awk 'FNR == 1 {print $2}')
toggle() {
    if [[ "$STATUS" == "connected" ]]; then
        nmcli radio wifi off
        notify-send --icon=window-close --urgency=normal "Wi-Fi toggle" "Wi-Fi has been turned off"
    else
        nmcli radio wifi on
        notify-send --icon=checkmark --urgency=normal "Wi-Fi toggle" "Wi-Fi has been turned on"
    fi
}

status() {
    if [[ "$STATUS" == "connected" ]]; then
        echo "直"
    else
        echo "睊"
    fi
}

# For some reason, rofi doesn't like being called by eww directly
dmenu() {
    bash ~/.config/rofi/scripts/rofi-wifi-menu.sh
}

if [[ $1 == "--toggle" ]]; then
    toggle
elif [[ $1 == "--status" ]]; then
    status
elif [[ $1 == "--dmenu" ]]; then
    dmenu
fi