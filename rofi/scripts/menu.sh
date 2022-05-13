#!/bin/bash

rofi_command="rofi -theme themes/centermenu.rasi"
backscript="$(dirname $0)/$(basename $0) $1"
echo $backscript

#### Options ###
adsysinfo=" Advanced System Information"
gpuinfo=" Advanced GPU Information"
wifi="泌 Wifi"
bt=" Bluetooth"
vpn="嬨 VPN"
network=" Networking"
monitors=" Display(s)"
keybinds=" Keybinds"
theme=" GTK Appearance/Theme"
wallpaper=" Set Wallpaper/Colorscheme/GRUB Image"
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
options="$adsysinfo\n$gpuinfo\n$wifi\n$bt\n$vpn\n$network\n$monitors\n$keybinds\n$theme\n$wallpaper\n$grub\n$login\n$rofi\n$audio\n$print\n$usb\n$draw\n$rgb\n$corsair"

chosen="$(echo -e "$options" | $rofi_command -dmenu -p "System Settings" -selected-row 0)"
case $chosen in
    $adsysinfo)
        hardinfo
        ;;
    $gpuinfo)
        gpu-viewer
        ;;
    $network)
        nm-connection-editor
        ;;
    $wifi)
        bash $HOME/.config/rofi/scripts/rofi-wifi-menu.sh
        ;;
    $bt)
        bash $HOME/.config/rofi/scripts/btmenu.sh
        ;;
    $vpn)
        bash $HOME/.config/rofi/scripts/fwmenu.sh
        ;;
    $monitors)
        arandr
        ;;
    $keybinds)
        xbindkeys_config
        ;;
    $theme)
        lxappearance
        ;;
    $wallpaper)
        bash $HOME/.config/rofi/scripts/walmenu.sh $backscript
        ;;
    $grub)
        grub-customizer
        ;;
    $login)
        kcmshell5 kcm_sddm
        ;;
    $rofi)
        bash $HOME/.config/rofi/scripts/rofimenu.sh
        ;;
    $audio)
        pavucontrol
        ;;
    $print)
        system-config-printer
        ;;
    $usb)
        usbview
        ;;
    $draw)
        bash /usr/lib/pentablet/pentablet.sh
        ;;
    $rgb)
        openrgb
        ;;
    $corsair)
        ckb-next
        ;;
esac
