#!/bin/bash

rofi_command="rofi -terminal kitty -theme ~/.config/rofi/themes/network.rasi -config ~/.config/rofi/config.rasi"

#### Options ###
# Variable passed to rofi
status="$(nmcli c | grep vpn)"
active_server="$(nmcli c | grep vpn | grep eth0 | cut -d " " -f1)"
if [ "$active_server" == "" ]; then
    active_server="$(nmcli c | grep vpn | grep wlan0 | cut -d " " -f1)"
fi
chosenserver="$(echo -e "$status" | $rofi_command -dmenu -p "VPN" -selected-row 0)"

# User-selected VPN server
server="$(echo $chosenserver | cut -d " " -f1)"
if [ "$server" != "" ]; then
    on=" Connect"
    off=" Disconnect"

    # If the active server is the selected server, only display off button (and vice versa)
    if [ "$active_server" = "$server" ]; then
        # Variable passed to rofi
        options="$off"
    else
        # Variable passed to rofi
        options="$on"
    fi

    # Toggle menu for selected VPN server
    chosen="$(echo -e "$options" | rofi -theme ~/.config/rofi/themes/togglemenu.rasi -config ~/.config/rofi/config.rasi -dmenu -p "VPN Connection" -selected-row 0)"

    # Turn vpn connection on or off depending on user choice
    if [ "$chosen" = "$on" ]; then
        # If there is a server we're already connected to, disconnect from it first
        if [ "$active_server" != "" ]; then
            nmcli connection down id $active_server && dunstify --replace 201 "VPN" "Switching from server: $active_server\nto server: $server"
            sleep 1
            dunstctl close-all
        fi
        nmcli connection up id $server && dunstify --replace 201 "VPN" "Connected to VPN Server: $server" 
    elif [ "$chosen" = "$off" ]; then
        nmcli connection down id $server && dunstify --replace 201 "VPN" "Disconnected from IPVanish VPN Server: $server"
    fi
fi