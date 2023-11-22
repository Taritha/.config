#!/bin/bash

rofi_command="rofi -theme -terminal kitty themes/centermenu.rasi"
backscript="$(dirname $0)/$(basename $0) $1"
echo $backscript
status=$?



_supress() {
  eval "$1() { \$(which $1) \"\$@\" 2>&1 | awk NF | grep -v \"$2\"; }"
}

#### Options ###
adsysinfo=" Advanced System Information"
gpuinfo=" Advanced GPU Information"
bt=" Bluetooth"
network=" Networking"
disks=" Drives"
monitors=" Display(s)"
theme=" GTK Appearance/Theme"
wallpaper=" Set Wallpaper/Colorscheme"
grub=" Grub Customizer"
login="﫻 Login Appearance/Theme"
rofi=" Change Rofi Theme"
audio=" Audio"
print=" Printing"
usb=" USB Management"
draw=" Drawing Tablet/Display"
rgb=" RGB"
corsair=" Corsair Peripherals"
# Variable passed to rofi
options="$adsysinfo\n$gpuinfo\n$monitors\n$disks\n$network\n$bt\n$theme\n$wallpaper\n$grub\n$login\n$rofi\n$audio\n$print\n$usb\n$draw\n$rgb\n$corsair"
cmd=""

chosen="$(echo -e "$options" | $rofi_command -dmenu -p "System Settings" -selected-row 0)"
case $chosen in
    $adsysinfo)
        cmd="hardinfo"
        ;;
    $gpuinfo)
        cmd="gpu-viewer"
        ;;
    $network)
        _supress nm-connection-editor   "Gtk-WARNING\|connect to accessibility bus"
        cmd="nm-connection-editor"  
        ;;
    $disks)
        _supress gnome-disks            "Gtk-WARNING\|connect to accessibility bus"
        cmd="gnome-disks"
        ;;
    $bt)
        _supress blueman-manager        "Gtk-WARNING\|connect to accessibility bus"
        cmd="blueman-manager"
        ;;
    $monitors)
        _supress arandr                 "Gtk-WARNING\|connect to accessibility bus\|atom_name"
        cmd="arandr"
        ;;
    $theme)
        _supress lxappearance           "Gtk-WARNING\|connect to accessibility bus"
        cmd="lxappearance"
        ;;
    $wallpaper)
        _supress wpg                    "[i]"
        cmd="wpg"
        ;;
    $grub)
        cmd="grub-customizer"
        ;;
    $login)
        cmd="kcmshell5 kcm_sddm"
        ;;
    $rofi)
        cmd="bash $HOME/.config/rofi/scripts/rofimenu.sh"
        ;;
    $audio)
        _supress pavucontrol            "Gtk-WARNING\|connect to accessibility bus"
        cmd="pavucontrol"
        ;;
    $print)
        _supress system-config-printer  "Gtk-WARNING\|connect to accessibility bus\|DeprecationWarning\|action\|self.\|Gdk."
        cmd="system-config-printer"
        ;;
    $usb)
        _supress usbview                "Gtk-WARNING\|connect to accessibility bus"
        cmd="usbview"
        ;;
    $draw)
        cmd="bash /usr/lib/pentablet/pentablet.sh"
        ;;
    $rgb)
        cmd="killall -9 openrgb && openrgb"
        ;;
    $corsair)
        cmd="ckb-next"
        ;;
esac

ERROR=$($cmd 2> /dev/null)
# If error is not empty, display what it says, otherwise just exit
if [ ! -z "$ERROR" ]; then
    echo $ERROR
    dunstify -u critical -t 10000 "Error" "$ERROR"
fi