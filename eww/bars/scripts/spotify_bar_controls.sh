#! /bin/sh
# Spotify just HAS to be a special snowflake and change its window name to something else while it's playing something, so this script is here to the rescue


# Checks if spotify is running
spotstatus=$(ps -A | grep -w spotify)

# If spotify is running, pause it and go to its window, otherwise just start it
if [ -z "$spotstatus" ]; then
    ~/.config/eww/bars/scripts/rofi_thingies.sh --goto Spotify & # Launch spotify
else
    STATE="$(playerctl --player='spotify' status)"

    # If spotify is playing a song, pause it to change the window name to something containing the keyword "Spotify" and then go to it
    if [[ "$STATE" == "Playing" ]]; then
        playerctl --player="spotify" pause
        sleep 0.01
        ~/.config/eww/bars/scripts/rofi_thingies.sh --goto Spotify & # Go to Spotify window
        playerctl --player="spotify" play
    else
        ~/.config/eww/bars/scripts/rofi_thingies.sh --goto Spotify & 
    fi
fi