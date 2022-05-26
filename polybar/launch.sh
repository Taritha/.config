#!/bin/sh

# Terminate any already running bars
killall -9 polybar
killall -9 cava.sh
killall -9 cava
# If all the bars have ipc enabled, use
# polybar-msg cmd quit

# Wait until all polybar processes have shut down
while pgrep -u UID -x polybar >/dev/null; do sleep 1; done

# Launch polybar using default config at location ~/.config/polybar/config
polybar -r main -c ~/.config/polybar/config &
polybar -r drawdisplay -c ~/.config/polybar/config &
polybar -r networking -c ~/.config/polybar/config &
polybar -r audio -c ~/.config/polybar/config &