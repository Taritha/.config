#! /bin/sh

status="$(nmcli c | grep vpn)"
active_server="$(nmcli c | grep vpn | grep eth0 | cut -d " " -f1)"


if [ "$1" == "--status" ]; then
    if [ "$active_server" = "" ]; then
        echo ""
    else
        echo ""
    fi
elif [ "$1" == "--display" ]; then
    if [ "$active_server" = "" ]; then
        dunstify --replace 201 "VPN" "Not currently connected to any VPN Server"
    else
        dunstify --replace 201 "VPN" "Currently connected to IPVanish VPN Server: $active_server"
    fi
elif [ "$1" == "--toggle" ]; then
    bash ~/.config/rofi/scripts/fwmenu.sh
fi