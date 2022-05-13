#!/bin/bash

# see man zscroll for documentation of the following parameters
zscroll -l 20 \
        -p " " \
        --delay 0.1 \
        --match-command "`dirname $0`/get_spotify_status.sh --status" \
        --match-text "Playing" "--scroll 1" \
        --match-text "Paused" "--scroll 1" \
        --update-check true "`dirname $0`/get_spotify_status.sh" &

wait