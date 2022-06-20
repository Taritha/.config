#! /bin/sh

EWW="eww --config $HOME/.config/eww/control_center/"
FILE="$HOME/.cache/eww_launch_cc.txt"

# Run eww daemon if it isn't already running
if [[ ! `pidof eww` ]]; then
    ~/.config/eww/control_center daemon
    sleep 1
fi

## Open control center
run_eww() {
    ${EWW} open control-center
}

stop_eww() {
    killall cava && killall zscroll
    ${EWW} close control-center
}


# Launch or close widgets accordingly
if [[ ! -f "$FILE" ]]; then
    touch "$FILE"
    run_eww
else
    stop_eww
    rm "$FILE"
fi