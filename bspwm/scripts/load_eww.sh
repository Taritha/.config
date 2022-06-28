#!/bin/sh

if [[ "$1" == "--kill" ]]; then
    killall eww &
fi


if [ $(pidof -s eww) ]; then

    if [ $(pidof -s cava) ]; then
        killall cava 
    fi
    if [ $(pidof -s zscroll) ]; then
        killall zscroll
    fi
    if [ $(pidof -s playerctl) ]; then
        killall playerctl
    fi

    eww --config ~/.config/eww/indicators/ reload
    eww --config ~/.config/eww/control_center/ reload
    eww --config ~/.config/eww/info_center/ reload
    eww --config ~/.config/eww/bars/ reload
# Start eww again
else
    eww --config ~/.config/eww/indicators/ daemon &
    eww --config ~/.config/eww/control_center/ daemon &
    eww --config ~/.config/eww/bars/ daemon &
    eww --config ~/.config/eww/info_center/ daemon &
    eww --config ~/.config/eww/info_center/ open info-center &
    eww --config ~/.config/eww/bars/ open topbar &
    eww --config ~/.config/eww/bars/ open botbar &
    eww --config ~/.config/eww/bars/ open audiobar &
    eww --config ~/.config/eww/bars/ open netbar &
fi