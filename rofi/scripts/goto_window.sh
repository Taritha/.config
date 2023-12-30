#!/bin/env bash

rofi_command="rofi -terminal kitty -theme /home/taritha/.config/rofi/themes/centermenu.rasi -config /home/taritha/.config/rofi/config.rasi"

# Lists all window IDs and their titles
ids=($(bspc query -N -n .window))
options="$(xtitle "${ids[@]}" | awk '{ print ++i" - "$0 }')"

# Exits if there are no open windows
[[ -n "$options" ]] || exit

if [ "$1" != "" ]; then
    # Changes array delimiter to newline for this op (before turning it back into space)
    SAVEIFS=$IFS
    IFS=$'\n'

    # Focuses on window specified in argument
    id_index=($(echo -e "$options" | grep "$1"))
    IFS=$SAVEIFS

    # If there are several instances of a program window open, let the user choose which to go to
    if [[ ${#id_index[@]} == 1 ]]; then
        id_index="$(echo "$id_index" | cut -d- -f1)"

    # Show the user only the windows of the command line program
    elif [[ ${#id_index[@]} -gt 1 ]]; then
        id_index="$(echo -e "$options" | grep "$1" | $rofi_command -dmenu -p "Go to" -selected-row 0 | cut -d- -f1)"

    else
        # If there are no instances of said program, open a new instance
        case "$1" in
            thunar)
                thunar &
            ;;
            Add) 
                kitty pacseek &
            ;;
            Firefox)
                firefox &
            ;;
            Evolution)
                evolution &
            ;;
            Slack)
                slack &
            ;;
            Discord)
                discord &
            ;;
            Steam)
                steam-runtime &
            ;;
            Lutris)
                lutris &
            ;;
            Spotify)
                spotify &
            ;;
            System)
                hardinfo &
            ;;
        esac

        # Exit script 
        exit 0
    fi
else
    # Focuses on user-selected window
    id_index="$(echo -e "$options" | $rofi_command -dmenu -p "Go to" -selected-row 0 | cut -d- -f1)"
fi

bspc node "${ids[$((id_index - 1))]}" -f