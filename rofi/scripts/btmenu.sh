#!/bin/bash

rofi_command="rofi -theme themes/togglemenu.rasi"

#### Options ###
off=" Off"
on=" On"
adv=" Advanced Settings"

status=" Status:$(bluetoothctl show | grep Powered)"
options="$status\n$on\n$off\n$adv"

chosen="$(echo -e "$options" | $rofi_command -dmenu -p "Bluetooth" -selected-row 0)"
case $chosen in
    $on)
        bluetoothctl power on
        dunstify --replace 200 "Bluetooth" " Bluetooth switched on"
        ;;    
    $off)
        bluetoothctl power off
        dunstify --replace 200 "Bluetooth" " Bluetooth switched off"
        ;;
    $adv)
        blueberry
        dunstify --replace 200 "Bluetooth" " Advanced settings menu"
esac

