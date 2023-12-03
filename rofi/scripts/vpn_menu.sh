#!/bin/bash

rofi_command="rofi -terminal kitty -theme /home/taritha/.config/rofi/themes/network.rasi -config /home/taritha/.config/rofi/config.rasi"

#### Options ###
status="$(nmcli c | grep vpn)"
# Variable passed to rofi
options="$status"

chosen="$(echo -e "$options" | $rofi_command -dmenu -p "Select VPN Server" -selected-row 0)"
case $chosen in
    $on)
        nmcli connection up id ipvanish-US-Denver-den-a11 && dunstify --replace 201 "VPN" "Connected to IPVanish VPN Server: US-Denver-den-a11"
        ;;    
    $off)
        nmcli connection down id ipvanish-US-Denver-den-a11 && dunstify --replace 201 "VPN" "Disconnected from IPVanish VPN Server: US-Denver-den-a11"
        ;;
esac

