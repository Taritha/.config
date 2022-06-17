#!/usr/bin/env bash

[ $(pidof redshift) ] && dunstify -u normal "Nightmode" "Nightmode switched off" || dunstify -u normal "Nightmode" "Nightmode switched on"
[ $(pidof redshift) ] && pkill redshift || redshift &" redshift"