#!/bin/bash

way-displays >/tmp/way-displays.${XDG_VTNR}.${USER}.log 2>&1 &

PROGRAMS=(
  i3bar-river
  swww-daemon
  swayidle
  /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
)

set_gnome() {
  gsettings set org.gnome.desktop.interface "$1" "$2"
}

start() {
  for program in ${PROGRAMS[@]}; do
    riverctl spawn $program &
  done

  set_gnome gtk-theme "Dracula"
  set_gnome icon-theme "Dracula"
  set_gnome cursor-theme "Bibata-Modern-Classic"
  set_gnome color-scheme "prefer-dark"
}

start
