#!/bin/bash

rofi_command="rofi -theme /home/taritha/.config/rofi/themes/network.rasi -config /home/taritha/.config/rofi/config.rasi"

#### Options ###
# Variable passed to rofi
status="$(nmcli c | grep vpn)"
chosenserver="$(echo -e "$status" | $rofi_command -dmenu -p "VPN" -selected-row 0)"

# User-selected VPN server
server=$( echo $chosenserver | cut -d " " -f1 )
if [ "$server" != "" ]; then

    on=" Connect"
    off=" Disconnect"

    # Variable passed to rofi
    options="$on\n$off"

    # Toggle menu for selected VPN server
    chosen="$(echo -e "$options" | rofi -theme /home/taritha/.config/rofi/themes/togglemenu.rasi -config /home/taritha/.config/rofi/config.rasi -dmenu -p "VPN Connection" -selected-row 0)"

    # Turn vpn connection on or off depending on user choice
    if [[ "$chosen" == "$on" ]]; then
        nmcli connection up id $server && dunstify --replace 201 "VPN" "Connected to VPN Server: $server" 
    elif [[ "$chosen" == "$off" ]]; then
        nmcli connection down id $server && dunstify --replace 201 "VPN" "Disconnected from IPVanish VPN Server: $server"
    fi
fi