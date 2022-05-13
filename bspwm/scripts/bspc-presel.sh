#!/bin/bash

usage() {
    cat <<EOM
usage: $(basename $0) [help] [direction amount]
    help        Displays this message
    direction   Should be "north", "south", "west" or "east" and sets the direction of the preselection
    amount      Should be a floating point number between 0.0 and 1.0. Controls the size of the steps the preselection will be adjusted with
EOM
    exit 0
}

[ "$1" = "help" ] && usage


# Get preselection ratio. Will be null if the current node has no preselection.
ratio=$(bspc query -T -n focused | jq -r ".presel.splitRatio")
{_,shift +}
if [ "$ratio" == "null" ]; then
    # If null, make preselection
    bspc node -p $1
else
    # If not null, modify preselection

    # Get split direction
    dir=$(bspc query -T -n focused | jq -r ".presel.splitDir")

    # Check direciton, set sign depending on direction
    case $dir in
        west) 
            if [ "$1" == "west" ]; then
                sign="-"
            elif [ "$1" == "east" ]; then
                sign="+"
            fi
        ;;
        east) 
            if [ "$1" == "east" ]; then
                sign="+"
            elif [ "$1" == "west" ]; then
                sign="-"
            fi
        ;;
        north) 
            if [ "$1" == "north" ]; then
                sign="-"
            elif [ "$1" == "south" ]; then
                sign="+"
            fi
        ;;
        south) 
            if [ "$1" == "south" ]; then
                sign="+"
            elif [ "$1" == "north" ]; then
                sign="-"
            fi
        ;;
        *)
            usage
        ;;
    esac

    # If sign is empty, the preselection direction was invalid (orthogonal to existing preselection)
    [[ -z $sign ]] && exit 0

    # Calculate the new ratio
    ratio=$(echo "$ratio $sign $2" | bc)

    # Set ratio
    bspc node -o $ratio
fi