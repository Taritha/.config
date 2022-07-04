#! /bin/sh

INTERFACE="$1"
CON_NAME="$2"

# Returns what the interface is connected to
if [[ "$CON_NAME" == "-c" ]]; then
    STATUS="$(nmcli dev status | grep -w "$INTERFACE" | grep -wv "p2p" | awk '{ print $3 }')"
    CONNECTION="$(nmcli dev status | grep -w "$INTERFACE" | grep -wv "p2p" | awk '{ print $4 }')"

    if [[ "$STATUS" == "connected" ]]; then
        echo "$CONNECTION"
    else
        echo "disconnected"
    fi

    # Reload eww netbar to be proper length if the network has changed
    if [[ "$INTERFACE" == "wlan0" ]]; then
        CON_CHANGE="$(cat ~/.config/eww/info_center/secrets/conn_name.txt)"
        if [[ "$CONNECTION" != "$CON_CHANGE" ]]; then
            echo "$CONNECTION" > ~/.config/eww/info_center/secrets/conn_name.txt
            eww --config ~/.config/eww/bars/ close netbar && eww --config ~/.config/eww/bars/ open netbar
        fi
    fi
else
    # Returns symbols based on the connection 
    if [[ "$INTERFACE" == "wwan0" ]]; then
        STATUS="$(nmcli dev status | grep -w "$INTERFACE" | grep -wv "p2p" | awk '{ print $3 }')"

        if [[ "$STATUS" == "connected" ]]; then
            echo ""
        else
            echo ""
        fi
    elif [[ "$INTERFACE" == "wlan0" ]]; then
        STATUS="$(nmcli dev status | grep -w "$INTERFACE" | grep -wv "p2p" | awk '{ print $3 }')"

        if [[ "$STATUS" == "connected" ]]; then
            echo "直"
        else
            echo "睊"
        fi
    fi
fi
