#!/bin/bash

_supress() {
  eval "$1() { \$(which $1) \"\$@\" 2>&1 | awk NF | grep -v \"$2\"; }"
}

rofi_command="rofi -terminal kitty -theme ~/.config/rofi/themes/network.rasi -config ~/.config/rofi/config.rasi"

#### Options ###
# Variable passed to rofi
status="$(nmcli c | grep vpn)"
active_server="$(nmcli c | grep vpn | grep enp | cut -d " " -f1)"
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
            ERROR=$(nmcli connection down id $active_server 2>&1 > /dev/null) && dunstify --replace 201 "VPN" "Switching from server: $active_server\nto server: $server"
            sleep 1
            dunstctl close-all
        fi
        ERROR=$(nmcli connection up id $server 2>&1 > /dev/null) && dunstify --replace 201 "VPN" "Connected to VPN Server: $server"
    elif [ "$chosen" = "$off" ]; then
        ERROR=$(nmcli connection down id $server 2>&1 > /dev/null) && dunstify --replace 201 "VPN" "Disconnected from IPVanish VPN Server: $server"
    fi
fi

echo $ERROR
# If error is not empty, display what it says, otherwise just exit
if [ ! -z "$ERROR" ]; then
    dunstify -u critical -t 10000 "Error" "$ERROR"
fi