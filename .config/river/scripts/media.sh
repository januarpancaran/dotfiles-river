#!/bin/bash

for mode in normal locked; do
  # Eject the optical drive (well if you still have one that is)
  riverctl map $mode None XF86Eject spawn 'eject -T'

  # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
  riverctl map $mode None XF86AudioRaiseVolume spawn 'wpctl set-volume -l 2 @DEFAULT_AUDIO_SINK@ 5%+'
  riverctl map $mode None XF86AudioLowerVolume spawn 'wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-'
  riverctl map $mode None XF86AudioMute spawn 'wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle'

  # Control MPRIS aware media players with playerctl (https://github.com/altdesktop/playerctl)
  riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
  riverctl map $mode None XF86AudioPlay spawn 'playerctl play-pause'
  riverctl map $mode None XF86AudioPrev spawn 'playerctl previous'
  riverctl map $mode None XF86AudioNext spawn 'playerctl next'

  # Control screen backlight brightness with brightnessctl (https://github.com/Hummer12007/brightnessctl)
  riverctl map $mode None XF86MonBrightnessUp spawn 'brightnessctl set +5%'
  riverctl map $mode None XF86MonBrightnessDown spawn 'brightnessctl set 5%-'
done
