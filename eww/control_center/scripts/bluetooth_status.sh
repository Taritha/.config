#!/usr/bin/env bash

STATUS="$(bluetoothctl show | grep Powered | awk '{print $2}')"
toggle() {
    if [ $STATUS == "yes" ]; then
        bluetoothctl power off
        dunstify -u normal "Bluetooth" "Bluetooth powered off"
    else
        bluetoothctl power on
        dunstify -u normal "Bluetooth" "Bluetooth powered on"
    fi
}

icon() {
    # off
    if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
    then
        echo ""
    else
        # on
        if [ $(echo info | bluetoothctl | grep 'Device' | wc -c) -eq 0 ]
        then
            echo ""
            # connected
        else
            echo ""
        fi
    fi
}

status() {
    # off
    if [ $(bluetoothctl show | grep "Powered: yes" | wc -c) -eq 0 ]
    then
        echo ""
    else
        # on
        if [ $(echo info | bluetoothctl | grep 'Device' | wc -c) -eq 0 ]
        then
            echo ""
            # connected
        else
            echo ""
        fi
    fi
}

dmenu() {
    bash ~/.config/rofi/scripts/btmenu.sh
}

if [[ $1 == "--toggle" ]]; then
    toggle
elif [[ $1 == "--status" ]]; then
    status
elif [[ $1 == "--icon" ]]; then
    icon
elif [[ $1 == "--dmenu" ]]; then
    dmenu
fi