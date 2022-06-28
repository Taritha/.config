#!/bin/sh


workspaces() {

    ws1="1"
    ws2="2"
    ws3="3"
    ws4="4"
    ws5="5"
    ws6="6"
    ws7="7"

    # Unoccupied
    un="0"

    # check if Occupied
    o1=$(bspc query -D -d .occupied --names | grep -m1 -w "$ws1" )
    o2=$(bspc query -D -d .occupied --names | grep "$ws2" )
    o3=$(bspc query -D -d .occupied --names | grep "$ws3" )
    o4=$(bspc query -D -d .occupied --names | grep "$ws4" )
    o5=$(bspc query -D -d .occupied --names | grep "$ws5" )
    o6=$(bspc query -D -d .occupied --names | grep "$ws6" )
    o7=$(bspc query -D -d .occupied --names | grep "$ws7" )

    # check if Focused
    f1=$(bspc query -D -d focused --names | grep -m1 -w "$ws1" )
    f2=$(bspc query -D -d focused --names | grep "$ws2" )
    f3=$(bspc query -D -d focused --names | grep "$ws3" )
    f4=$(bspc query -D -d focused --names | grep "$ws4" )
    f5=$(bspc query -D -d focused --names | grep "$ws5" )
    f6=$(bspc query -D -d focused --names | grep "$ws6" )
    f7=$(bspc query -D -d focused --names | grep "$ws7" )

    ic_1="ﰊ"
    ic_2="ﰊ"
    ic_3="ﰊ"
    ic_4="ﰊ"
    ic_5="ﰊ"
    ic_6="ﰊ"
    ic_7="ﰊ"

    if [ $f1 ]; then
        ic_1="ﰉ"
    elif [ $f2 ]; then
        ic_2="ﰉ"
    elif [ $f3 ]; then
        ic_3="ﰉ"
    elif [ $f4 ]; then
        ic_4="ﰉ"
    elif [ $f5 ]; then
        ic_5="ﰉ"
    elif [ $f6 ]; then
        ic_6="ﰉ"
    elif [ $f7 ]; then
        ic_7="ﰉ"
    fi

    echo "(box :class \"bot-bar\" :orientation \"h\" :spacing 5 :space-evenly \"false\" :halign \"center\" (button :onclick \"bspc desktop -f $ws1\" :class \"wb-$un-$o1-$f1\" \"$ic_1\") (button :onclick \"bspc desktop -f $ws2\" :class \"wb-$un-$o2-$f2\" \"$ic_2\") (button :onclick \"bspc desktop -f $ws3\" :class \"wb-$un-$o3-$f3\" \"$ic_3\") (button :onclick \"bspc desktop -f $ws4\" :class \"wb-$un-$o4-$f4\" \"$ic_4\") (button :onclick \"bspc desktop -f $ws5\" :class \"wb-$un-$o5-$f5\" \"$ic_5\") (button :onclick \"bspc desktop -f $ws6\" :class \"wb-$un-$o6-$f6\" \"$ic_6\") (button :onclick \"bspc desktop -f $ws7\" :class \"wb-$un-$o7-$f7\" \"$ic_7\"))"
}


workspaces

bspc subscribe desktop node_transfer | while read -r _ ; do
    workspaces
done