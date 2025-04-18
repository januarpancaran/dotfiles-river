#!/bin/bash

ENV=(
  SEATD_SOCK
  DISPLAY
  WAYLAND_DISPLAY
  XDG_CURRENT_DESKTOP=river
  XDG_SESSION_DESKTOP=river
  XDG_SESSION_TYPE=wayland
  QT_QPA_PLATFORMTHEME=qt6ct
  QT_QPA_PLATFORM=wayland
  PLASMA_USE_QT_SCALING=1.25
  GDK_BACKEND=wayland
  ELECTRON_OZONE_PLATFORM_HINT=wayland
  XCURSOR_THEME=Bibata-Modern-Classic
  XCURSOR_SIZE=24
)

start() {
  riverctl spawn "systemctl --user import-environment ${ENV[*]}"
  riverctl spawn "dbus-update-activation-environment --systemd ${ENV[*]}"
  riverctl spawn "systemctl --user restart xdg-desktop-portal"
}

start
