#!/bin/bash

rofi_command="rofi -terminal kitty -theme themes/icons.rasi -p "power""

#### Options ###
power_off=""
reboot=""
lock=""
suspend="⏾"
hibernate="⏼"
log_out="﫼"
# Variable passed to rofi
options="$power_off\n$reboot\n$suspend\n$hibernate\n$lock\n$log_out"

chosen="$(echo -e "$options" | $rofi_command -dmenu -p "Power Options" -selected-row 0)"
case $chosen in
    $power_off)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
    $suspend)
	    systemctl suspend
        ;;
    $hibernate)
        systemctl hibernate
        ;;
    $lock)
        betterlockscreen -l dim
        ;;
    $log_out)
        bspc quit
        ;;
esac

