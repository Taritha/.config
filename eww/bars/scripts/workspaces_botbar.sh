#!/bin/sh


workspaces() {

    ws8="8"
    ws9="9"
    ws10="10"

    # Unoccupied
    un="0"

    # check if Occupied
    o8=$(bspc query -D -d .occupied --names | grep "$ws8" )
    o9=$(bspc query -D -d .occupied --names | grep "$ws9" )
    o10=$(bspc query -D -d .occupied --names | grep "$ws10" )

    # check if Focused
    f8=$(bspc query -D -d focused --names | grep "$ws8" )
    f9=$(bspc query -D -d focused --names | grep "$ws9" )
    f10=$(bspc query -D -d focused --names | grep "$ws10")

    ic_8="ﰊ"
    ic_9="ﰊ"
    ic_10="ﰊ"

    if [ $f8 ]; then
        ic_8="ﰉ"
    elif [ $f9 ]; then
        ic_9="ﰉ"
    elif [ $f10 ]; then
        ic_10="ﰉ"
    fi

    echo "(box :class \"bot-bar\" :orientation \"h\" :spacing 5 :space-evenly \"false\" (button :onclick \"bspc desktop -f $ws8\" :class \"wb-$un-$o8-$f8\" \"$ic_8\") (button :onclick \"bspc desktop -f $ws9\" :class \"wb-$un-$o9-$f9\" \"$ic_9\") (button :onclick \"bspc desktop -f $ws10\" :class \"wb-$un-$o10-$f10\" \"$ic_10\"))"
}


workspaces

bspc subscribe desktop node_transfer | while read -r _ ; do
    workspaces
done