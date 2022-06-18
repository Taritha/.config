#!/bin/bash

STATUS="$(playerctl --player='spotify' status 2>/dev/null)"
EXIT_CODE=$?

if [ $EXIT_CODE -eq 0 ]; then
    if [[ "$1" == "--artist" ]]; then
        thingy="$(playerctl --player='spotify' metadata --format '{{artist}}')"
        echo "$thingy"
    elif [[ "$1" == "--album" ]]; then
        thingy="$(playerctl --player='spotify' metadata --format '{{album}}')"
        echo "$thingy"
    elif [[ "$1" == "--title" ]]; then
        thingy="$(playerctl --player='spotify' metadata --format '{{title}}')"
        echo "$thingy"
    fi
else
    echo "ﱙ No player is running"
fi