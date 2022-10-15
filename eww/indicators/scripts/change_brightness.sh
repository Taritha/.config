#!/bin/sh

killed=false
for pid in $(pidof -x change_brightness.sh); do
    if [ $pid != $$ ]; then
        kill -9 $pid
        killed=true
    fi
done >/dev/null


while [ killed = false ]; do
    sleep 1
done

# Converts eww slider value to a float to change volume
floatval=$1
int=${floatval%.*}

python ~/.config/eww/control_center/scripts/change_brightness.py -set $int
