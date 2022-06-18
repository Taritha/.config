#!/bin/bash

# see man zscroll for documentation of the following parameters
zscroll -l 16 \
        -p "    ~    " \
        --delay 0.15 \
        --match-command "`dirname $0`/get_spotify_statusthingy.sh --status" \
        --match-text "Playing" "--scroll 1" \
        --match-text "Paused" "--scroll 1" \
        --update-check true "`dirname $0`/get_spotify_statusthingy.sh" &
wait