#!/usr/bin/env bash

# Starts a scan of available broadcasting SSIDs
dunstify -u normal -t 3000 "Wifi" "Scanning for wifi networks..."
nmcli dev wifi rescan

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

FIELDS=SSID,SECURITY
POSITION=0
YOFF=0
XOFF=0
FONT="JetBrainsMono Nerd Font 12"

if [ -r "$DIR/config" ]; then
	source "$DIR/config"
elif [ -r "$HOME/.config/rofi/wifi" ]; then
	source "$HOME/.config/rofi/wifi"
else
	echo "WARNING: config file not found! Using default values."
fi

LIST=$(nmcli --fields "$FIELDS" device wifi list | sed '/^--/d')
# For some reason rofi always approximates character width 2 short... hmmm
RWIDTH=$(($(echo "$LIST" | head -n 1 | awk '{print length($0); }')+2))
# Dynamically change the height of the rofi menu
LINENUM=$(echo "$LIST" | wc -l)
# Gives a list of known connections so we can parse it later
KNOWNCON=$(nmcli connection show)
# Really janky way of telling if there is currently a connection
CONSTATE=$(nmcli -fields WIFI g)

CURRSSID=$(LANGUAGE=C nmcli -t -f active,ssid dev wifi | awk -F: '$1 ~ /^yes/ {print $2}')

# if [[ ! -z $CURRSSID ]]; then
# 	HIGHLINE=$(echo  "$(echo "$LIST" | awk -F "[  ]{2,}" '{print $1}' | grep -Fxn -m 1 "$CURRSSID" | awk -F ":" '{print $1}') + 1" | bc )
# fi


# HOPEFULLY you won't need this as often as I do
# If there are more than 8 SSIDs, the menu will still only have 8 lines
if [ "$LINENUM" -gt 8 ] && [[ "$CONSTATE" =~ "enabled" ]]; then
	LINENUM=8
elif [[ "$CONSTATE" =~ "disabled" ]]; then
	LINENUM=1
fi


if [[ "$CONSTATE" =~ "enabled" ]]; then
	TOGGLE="Toggle off"
elif [[ "$CONSTATE" =~ "disabled" ]]; then
	TOGGLE="Toggle on"
fi

sleep 0.5
dunstctl close

# Displays currently connected wifi network, if there is any
CONNECTED="$(iwgetid -r)"

if [ "$CONNECTED" = "" ]; then
	dunstify -u normal -t 5000 "Wifi" "Not currently connected to any wireless network"
else
	dunstify -u normal -t 5000 "Wifi" "Currently connected to network $CONNECTED"
fi

CHENTRY=$(echo -e "$TOGGLE\nManual\n$LIST" | uniq -u | rofi -theme $HOME/.config/rofi/themes/network.rasi -dmenu -p "Enter Wi-Fi SSID" -lines "$LINENUM" -a "$HIGHLINE" -location "$POSITION" -yoffset "$YOFF" -xoffset "$XOFF" -font "$FONT" -width -"$RWIDTH")
#echo "$CHENTRY"
CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $1}')
#echo "$CHSSID"

# If the user inputs "manual" as their SSID in the start window, it will bring them to this screen
if [ "$CHENTRY" = "Manual" ] ; then
	# Manual entry of the SSID and password (if applicable)
	MSSID=$(echo "Enter the SSID of the network (SSID,password)" | rofi -theme $HOME/.config/rofi/themes/network.rasi -dmenu -p "Manual Entry" -font "$FONT" -lines 1)
	# Separating the password from the entered string
	MPASS=$(echo "$MSSID" | awk -F "," '{print $2}')

	#echo "$MSSID"
	#echo "$MPASS"

	# If the user entered a manual password, then use the password nmcli command
	if [ "$MPASS" = "" ]; then
		dunstify -u critical "Wifi" "Connecting to $MSSID ..."
		nmcli dev wifi con "$MSSID" && dunstctl close && dunstify -u normal "Wifi" "Connected to $MSSID"
	else
		dunstify -u critical "Wifi" "Connecting to $MSSID ..."
		nmcli dev wifi con "$MSSID" password "$MPASS"
		nmcli dev wifi con "$MSSID" && dunstctl close && dunstify -u normal "Wifi" "Connected to $MSSID"
	fi

elif [ "$CHENTRY" = "Toggle on" ]; then
	nmcli radio wifi on && dunstify -u normal "Wifi" "Wifi enabled"

elif [ "$CHENTRY" = "Toggle off" ]; then
	nmcli radio wifi off && dunstify -u normal "Wifi" "Wifi disabled"

else
	# If the connection is already in use, then this will still be able to get the SSID
	if [ "$CHSSID" = "*" ]; then
		CHSSID=$(echo "$CHENTRY" | sed  's/\s\{2,\}/\|/g' | awk -F "|" '{print $3}')
	fi

	# Parses the list of preconfigured connections to see if it already contains the chosen SSID. This speeds up the connection process
	if [[ $(echo "$KNOWNCON" | grep "$CHSSID") = "$CHSSID" ]]; then
		dunstify -u critical "Wifi" "Connecting to $CHSSID ..."
		nmcli con up "$CHSSID" && dunstctl close && dunstify -u normal "Wifi" "Connected to network $CHSSID"
	else
		if [[ "$CHENTRY" =~ "WPA2" ]] || [[ "$CHENTRY" =~ "WEP" ]]; then
			WIFIPASS=$(echo "If connection is stored, hit enter" | rofi -theme $HOME/.config/rofi/themes/network.rasi -dmenu -p "Enter password" -lines 1 -font "$FONT" )
		fi
		if [ "$CHSSID" != "" ]; then
			dunstify -u critical "Wifi" "Connecting to $CHSSID ..."
		fi
		nmcli dev wifi con "$CHSSID" password "$WIFIPASS" && dunstctl close && dunstify -u normal "Wifi" "Connected to network $CHSSID"
	fi

fi
