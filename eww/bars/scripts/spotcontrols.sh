#!/bin/bash

if [[ "$1" == "--prev" ]]; then
    playerctl --player="spotify" previous
elif [[ "$1" == "--toggle" ]]; then
    playerctl --player="spotify" play-pause
elif [[ "$1" == "--next" ]]; then
    playerctl --player="spotify" next
fi