#!/bin/sh

killed=false
for pid in $(pidof -x volume.sh); do
    if [ $pid != $$ ]; then
        kill -9 $pid
        killed=true
    fi
done >/dev/null

if ! $killed; then
    eww -c $HOME/.config/eww/indicators/ update volume-hidden=true
    eww -c $HOME/.config/eww/indicators/ open volume-indicator
fi

eww -c $HOME/.config/eww/indicators/ update volume-level=$(pamixer --get-volume)
eww -c $HOME/.config/eww/indicators/ update volume-muted=$(pamixer --get-mute)
eww -c $HOME/.config/eww/indicators/ update volume-hidden=false
sleep 2
eww -c $HOME/.config/eww/indicators/ update volume-hidden=true
sleep 1
eww -c $HOME/.config/eww/indicators/ close volume-indicator
unset killed