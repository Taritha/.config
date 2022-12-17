#! /bin/sh

pywalfox update &
pywal-discord &
spicetify update &
bspc wm -r &

# Checks if spotify is running and restarts it if it is
spotstatus=$(ps -A | grep -w spotify)

if [ -z "$spotstatus" ]; then
    echo "Congratulations! Nothing."
else
    # Gets Xwindow ID of Spotify window
    ids=($(bspc query -N -n .window))
    options="$(xtitle "${ids[@]}" | awk '{ print ++i" - "$0 }')"
    id_index="$(echo -e "$options" | grep Spotify)"
    desktop="$(xwininfo -wm -id "${ids[$((id_index - 1))]}" | grep desktop | cut -d" " -f10)"
    desktop=$((desktop+1))

    # restarts Spotify and opens it on desktop it was originally on
    killall -9 spotify
    sleep 1
    bspc rule -a "*" -o desktop="^$desktop"; # Sacrificial rule to be consumed by the computer Gods for their transgressions
    bspc rule -a "*" -o desktop="^$desktop";
    spotify
fi

sleep 0.25

# reload eww
/home/taritha/.config/bspwm/scripts/load_eww.sh &

sleep 0.25

# Gets current wallpaper directory from ~/.fehbg
# paperpath=$(cat ~/.fehbg | grep wpg | cut -d " " -f 4 | cut -d "'" -f 2)
paperpath=$(readlink -f ~/.config/wpg/.current)

# Update lockscreen to use same wallpaper as desktop
dunstify -u critical "Betterlockscreen" "Updating lock screen wallpaper effects..."
betterlockscreen -u "${paperpath}" --fx dim,blur --display 1 && dunstify -u critical "Betterlockscreen" "Update complete"

# Wait 1s and then close notifications
sleep 1
dunstctl close-all &