#! /bin/sh
# ~/.config/bspwm/scripts/external_rules.sh

wid=$1
class=$2
instance=$3
consequences=$4

# notify-send "\$1=$(printf '0x%08X' "$1") \$2=$2 \$3=$3" "$4"

case "$class" in
	# Spotify is a big dumb stupid dumb app and doesn't like normal bspwm rules for little babies
	"")
		echo "state=pseudo_tiled"
		;;
	"")
		sleep 0.5

		wm_class=($(xprop -id $wid | grep "WM_CLASS" | grep -Po '"\K[^,"]+'))

		class=${wm_class[-1]}

		[[ ${#wm_class[@]} == "2" ]] && instance=${wm_class[0]}

		[[ -n "$class" ]] && main
		;;
	Evolution)
		# Opens initial evolution window in tiled mode, but sub-windows to floating
		titles=$(xtitle $(bspc query -N -n .window)) # Gets titles of open windows
		# If an evolution window already exists, make subsequent ones float
		if [[ "$titles" == *"Calendar"* ]]; then
			echo "bspc rule -a $2:$3 state=floating"
		fi
	;;
	Aseprite)
		# Sets rules for aseprite: open new instances on monitor 1 if it's already open 
		titles=$(xtitle $(bspc query -N -n .window)) # Gets titles of open windows
		# If an aseprite window already exists, place new ones on the primary display
		if [[ "$titles" == *"$2"* ]]; then
			echo "bspc rule -a $2:$3 monitor=^1"
		# If an aseprite window doesn't already exist, set new instances to display on the drawing tablet
		else
			echo "bspc rule -a $2:$3 monitor=^2 state=fullscreen"
		fi
	;;

esac
		