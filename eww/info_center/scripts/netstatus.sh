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
else
    # Returns symbols based on the connection 
    if [[ "$INTERFACE" == "enp5s0" ]]; then
        STATUS="$(nmcli dev status | grep -w "$INTERFACE" | grep -wv "p2p" | awk '{ print $3 }')"

        if [[ "$STATUS" == "connected" ]]; then
            echo ""
        else
            echo ""
        fi
    elif [[ "$INTERFACE" == "wlp4s0" ]]; then
        STATUS="$(nmcli dev status | grep -w "$INTERFACE" | grep -wv "p2p" | awk '{ print $3 }')"

        if [[ "$STATUS" == "connected" ]]; then
            echo "直"
        else
            echo "睊"
        fi
    fi
fi
