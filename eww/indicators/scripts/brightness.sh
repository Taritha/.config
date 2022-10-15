#!/bin/sh

killed=false
for pid in $(pidof -x brightness.sh); do
    if [ $pid != $$ ]; then
        kill -9 $pid
        killed=true
    fi
done >/dev/null

if ! $killed; then
    eww -c $HOME/.config/eww/indicators/ open brightness-indicator
fi

eww -c $HOME/.config/eww/indicators/ update brightness-level=$(python ~/.config/eww/control_center/scripts/get_brightnesslevel.py)
sleep 3
eww -c $HOME/.config/eww/indicators/ close brightness-indicator
unset killed