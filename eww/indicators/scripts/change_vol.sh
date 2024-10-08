#!/bin/sh

killed=false
for pid in $(pidof -x change_vol.sh); do
    if [ $pid != $$ ]; then
        kill -9 $pid
        killed=true
    fi
done >/dev/null


if ! killed; then
    sleep 0.1
fi
# Converts eww slider value to a float to change volume
floatval=$1
int=${floatval%.*}

pamixer --set-volume $int
eww -c ~/.config/eww/bars update volume=$(pamixer --get-volume)