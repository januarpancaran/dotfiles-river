#!/bin/bash

map() {
  key="$1"
  shift
  riverctl map normal Super "$key" spawn "$@"
}

map_shift() {
  key="$1"
  shift
  riverctl map normal Super+Shift "$key" spawn "$@"
}

map T ghostty
map R "rofi -show drun"
map E nautilus
map B google-chrome-stable
map I "google-chrome-stable --incognito"
map D "discord --ozone-platform=wayland"
map SemiColon spotify-launcher
map O obs
map M wlogout
map C code

map_shift C "XDG_CURRENT_DESKTOP=GNOME gnome-control-center"
map_shift N "_JAVA_AWT_WM_NONREPARENTING=1 netbeans"

# Screenshot
map_shift S 'grim -g "$(slurp)" ~/Pictures/Screenshots/Screenshot_$(date +'%Y%m%d_%H%M%S').png && notify-send "Screenshot Taken!" -t 2000'
map_shift P 'grim ~/Pictures/Screenshots/Screenshot_$(date +'%Y%m%d_%H%M%S').png && notify-send "Screenshot Taken!" -t 2000'
map P 'grim - | wl-copy && notify-send "Screenshot Copied to Clipboard" -t 2000'
