#!/bin/sh

if [[ "$1" == "--kill" ]]; then
    killall -9 eww &
fi

# If eww is already running, reload it
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

    eww --config ~/.config/eww/indicators/ reload & 
    eww --config ~/.config/eww/control_center/ reload &
    eww --config ~/.config/eww/info_center/ reload &
    eww --config ~/.config/eww/bars/ reload &
# Otherwise, reload it agaain
else
    # eww --config ~/.config/eww/indicators/ daemon &
    eww --config ~/.config/eww/control_center/ daemon &
    # eww --config ~/.config/eww/bars/ daemon &
    # eww --config ~/.config/eww/info_center/ daemon &
    eww --config ~/.config/eww/bars/ open topbar && sleep 0.25
    eww --config ~/.config/eww/bars/ open audiobar && sleep 0.5
    eww --config ~/.config/eww/bars/ open netbar && sleep 0.5
    eww --config ~/.config/eww/info_center/ open info-center
fi