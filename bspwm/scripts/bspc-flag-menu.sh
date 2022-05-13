#!/bin/bash
usage() {
    cat <<EOM
usage: $(basename $0) [help] 
    help    Displays this message
EOM
    exit 0
}

[ "$1" = "help" ] && usage


flags=( marked locked sticky private )

# String for all the current flags of the node
set_flags=""

# Iterate over the available flags
for flag in "${flags[@]}"
do
    # Check if flag is set
    if ( bspc query -N -n focused.$flag > /dev/null ); then
        # If flag strign is empty, set it to the current flag
        if [ -z $set_flags ]; then
            set_flags="$flag"
        # If not empty, append the current flag to the existing ones
        else
            set_flags="$set_flags|$flag"
        fi
    fi
done

# Create prompt
prompt="Toggle_flags"

[[ -z $set_flags ]] || prompt="${prompt}_($set_flags)"

# Get user choice
choice=$(printf "%s\n" "${flags[@]}" | rofi -theme themes/appsmenu.rasi -dmenu -i -p "$prompt")

# Exit if no choice
[[ -z $choice ]] && exit 0

# Set flag
bspc node -g $choice