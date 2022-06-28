#! /bin/sh

if [[ "$1" == "--power" ]]; then
    bash /home/taritha/.config/rofi/scripts/powermenu.sh
elif [[ "$1" == "--settings" ]]; then
    bash ~/.config/rofi/scripts/menu.sh
elif [[ "$1" == "--goto" ]]; then
    bash /home/taritha/.config/rofi/scripts/goto_window.sh $2
fi