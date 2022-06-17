#!/usr/bin/env bash

[ $(pidof picom) ] && dunstify -u normal "Composition" "Compositor switched off. Happy gaming!" || dunstify -u normal "Composition" "Compositor switched on"
[ $(pidof picom) ] && pkill picom || picom -b --experimental-backend --config ~/.config/picom/picom.conf &