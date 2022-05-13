#!/bin/bash

rofi_command="rofi -theme themes/icons.rasi -p "power""

#### Options ###
power_off=""
reboot="勒"
lock=""
suspend="鈴"
log_out="﫼"
# Variable passed to rofi
options="$power_off\n$reboot\n$suspend\n$lock\n$log_out"

chosen="$(echo -e "$options" | $rofi_command -dmenu -p "Power Options" -selected-row 0)"
case $chosen in
    $power_off)
        systemctl poweroff
        ;;
    $reboot)
        systemctl reboot
        ;;
    $lock)
        betterlockscreen -l dim
        ;;    
    $suspend)
	    systemctl suspend
        ;;
    $log_out)
        bspc quit
        ;;
esac

