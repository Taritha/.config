#!/bin/bash
rofi_command="rofi -theme /home/taritha/.config/rofi/themes/infomenu.rasi -config /home/taritha/.config/rofi/config.rasi"

awk '/[a-z]/ && last {print "<small>",$0,"\t","\t",last,"</small>"} {last=""} /^#/{last=$0}' ~/.config/sxhkd/sxhkdrc |
    column -t -s $'\t' |
    $rofi_command -dmenu -p "Keybinds" -i -markup-rows -no-show-icons