#!/bin/sh
# Prerequisites: bspc-ordered-hide


usage() {
    cat <<EOM
usage: $(basename $0) [help] 
    help    Displays this message
EOM
    exit 0
}

[ "$1" = "help" ] && usage

# Subscribe to node remove and node transfer events,
# since these are the two events that might make a desktop empty of visible windows.
# Do not listen to node hide events, since if the user explicitly hides the last
# window on a desktop, they probably do not want it to be instantly unhidden.
bspc subscribe node_remove node_transfer | while read event info; do
    # The desktop that might be empty of visible windows
    desktop=""

    # Different events provide different information
    case $event in
        node_remove)
            read mid did nid <<< "$info"
            # The desktop id is the desktop where the node got removed
            desktop="$did"
        ;;
        node_transfer)
            read src_mid src_did src_nid dst_mid dst_did dst_nid <<< "$info"
            # If a node is transferred, it's transferred from the source desktop,
            # hence this is the desktop that might now be empty
            desktop="$src_did"
        ;;
        *)
            # This should never happen
            echo "Unknown event"
        ;;
    esac

    # Get the name of the desktop
    desktop="$(bspc query -D -d $desktop --names)"

    # Count the number of visible nodes 
    visible=$(bspc query -N -d $desktop -n .window.\!hidden | wc -l)

    # Count the number of hidden nodes
    hidden=$(bspc-ordered-hide count $desktop)

    # If there are no visible nodes and more than zero hidden nodes,
    # then unhide the first hidden window using bspc-ordered-hide
    [ "$visible" -eq "0" -a "$hidden" -gt "0" ] && {
        bspc-ordered-hide unhide $desktop
    }
done