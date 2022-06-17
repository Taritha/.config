#!/usr/bin/env bash

[ $(pidof redshift) ] && dunstify -u normal "Nightmode" "Nightmode turned off" || dunstify -u normal "Nightmode" "Nightmode turned on"
[ $(pidof redshift) ] && pkill redshift || redshift &" redshift"