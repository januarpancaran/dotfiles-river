#!/bin/bash

PROGRAMS=(
  kanshi
  i3bar-river
  swww-daemon
  /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
)

monitor=$(wlr-randr | grep DP | awk '{print $1}')

set_gnome() {
  gsettings set org.gnome.desktop.interface "$1" "$2"
}

start() {
  for program in ${PROGRAMS[@]}; do
    riverctl spawn $program &
  done

  swayidle -w \
    timeout 150 'brightnessctl -s set 10' \
    resume 'brightnessctl -r' \
    \
    timeout 150 'brightnessctl -sd rgb:kbd_backlight set 0' \
    resume 'brightnessctl -rd rgb:kbd_backlight' \
    \
    timeout 300 'swaylock' \
    \
    timeout 330 'wlopm --off $monitor' \
    resume 'wlopm --on $monitor' \
    \
    timeout 600 'systemctl suspend' \
    \
    before-sleep 'swaylock' \
    lock 'swaylock' &

  set_gnome gtk-theme "Dracula"
  set_gnome icon-theme "Dracula"
  set_gnome cursor-theme "Bibata-Modern-Classic"
  set_gnome color-scheme "prefer-dark"
}

start
