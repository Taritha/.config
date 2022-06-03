#!/bin/bash

rofi_command="rofi -theme themes/togglemenu.rasi"
directory="/usr/share/icons/Inverse-black-dark"

#### Options ###
off=" Switch off"
on=" Switch on"
adv=" Device Control/Settings"
powstatus="$(bluetoothctl show | grep Powered | cut -d ':' -f2)"

if [ $powstatus = "yes" ]; then
    status=" Bluetooth | Powered On"
    options="$off\n$adv"
else
    status=" Bluetooth | Powered Off"
    options="$on\n$adv"
fi

chosen="$(echo -e "$options" | $rofi_command -dmenu -p "$status" -selected-row 0)"
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
        dunstify --replace 200 "Bluetooth" " Bluetooth Settings Menu"
esac

