#!/bin/sh

# Location of icons to use for volume level (I decided they were fugly and took them out though)
# icondir="/usr/share/icons/Inverse-black/status/symbolic/" 

# Gets volume level
VOL="$(pamixer --get-volume)"
MUTED="$(pamixer --get-mute)"

# Gets an icon depending on the volume level 
getIcon() {
    if [[ "$MUTED" == "true" || ${VOL} == 0 ]]; then
        echo "婢 ${VOL}                      "
    else
        if [[ ${VOL} -lt 10 ]]; then
            echo " ${VOL}                      "
        elif [[ ${VOL} -lt 25 ]]; then
            echo " ${VOL}                     "
        elif [[ ${VOL} -lt 50 ]]; then
            echo "奔 ${VOL}                     "
        elif [[ ${VOL} -lt 75 ]]; then
            echo "墳 ${VOL}                     "
        elif [[ ${VOL} -lt 100 ]]; then
            echo " ${VOL}                     "
        elif [[ ${VOL} -gt 99 ]]; then
            echo " ${VOL}                    "
        fi
    fi
}

# Display notification that lasts for 3000ms, is low priority, stacks on itself, and shows a progress bar of the audio levels
dunstify -t 3000 -u low -h string:x-canonical-private-synchronous:audio "$(getIcon)" -h int:value:"${VOL}"
