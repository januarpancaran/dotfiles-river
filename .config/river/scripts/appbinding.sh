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
map B firefox
map I "firefox --private-window"
map D "discord --ozone-platform=wayland"
map SemiColon spotify-launcher
map O obs
