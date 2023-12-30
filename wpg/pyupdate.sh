#! /bin/sh

autorandr --change &
pywalfox update &
pywal-discord &
spicetify -q refresh &
bspc wm -r &
~/.config/bspwm/scripts/load_eww.sh & # Reload ewww

# Checks if spotify is running and restarts it if it is
spotstatus=$(ps -A | grep -w spotify)

if [ -z "$spotstatus" ]; then
    echo "Congratulations! Nothing."
else
    playerctl --player="spotify" pause

    # Gets Xwindow ID of Spotify window
    ids=($(bspc query -N -n .window))
    options="$(xtitle ${ids[@]} | awk '{ print ++i" - "$0 }')"
    id_index="$(echo -e "$options" | grep 'Spotify Premium' | sed 's/[^0-9]*//g')"
    desktop="$(xwininfo -wm -id "${ids[$((id_index - 1))]}" | grep desktop | cut -d" " -f10)"
    desktop=$((desktop+1))

    # Restarts Spotify and opens it on desktop it was originally on
    killall -9 spotify
    sleep 1
    bspc rule -a "*" -o desktop="^$desktop";
    spotify
fi

sleep 0.25

# Clear logger for dunst functionality
~/.config/eww/control_center/scripts/logger.zsh clear &

# Gets current wallpaper directory from ~/.fehbg
paperpath=$(readlink -f ~/.config/wpg/.current)

# Update lockscreen to use same wallpaper as desktop
dunstify -u critical "Betterlockscreen" "Updating lock screen wallpaper effects..."
betterlockscreen -u "${paperpath}" --fx dim,blur --display 1 && dunstify -u critical "Betterlockscreen" "Update complete"

# Wait 1s and then close notifications
sleep 1
dunstctl close-all &
