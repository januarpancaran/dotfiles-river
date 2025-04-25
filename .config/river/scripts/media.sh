#!/bin/bash

for mode in normal locked; do
  # Eject the optical drive (well if you still have one that is)
  riverctl map $mode None XF86Eject spawn 'eject -T'

  # Control pulse audio volume with pamixer (https://github.com/cdemoulins/pamixer)
  riverctl map $mode None XF86AudioRaiseVolume spawn '~/.local/bin/changevolume up'
  riverctl map $mode None XF86AudioLowerVolume spawn '~/.local/bin/changevolume down'
  riverctl map $mode None XF86AudioMute spawn '~/.local/bin/changevolume toggle'

  # Control MPRIS aware media players with playerctl (https://github.com/altdesktop/playerctl)
  riverctl map $mode None XF86AudioMedia spawn 'playerctl play-pause'
  riverctl map $mode None XF86AudioPlay spawn 'playerctl play-pause'
  riverctl map $mode None XF86AudioPrev spawn 'playerctl previous'
  riverctl map $mode None XF86AudioNext spawn 'playerctl next'

  # Control screen backlight brightness with brightnessctl (https://github.com/Hummer12007/brightnessctl)
  riverctl map $mode None XF86MonBrightnessUp spawn '~/.local/bin/changebrightness up'
  riverctl map $mode None XF86MonBrightnessDown spawn '~/.local/bin/changebrightness down'
done
