#!/bin/bash

# Set background and border color
riverctl background-color 0x002b36
riverctl border-color-focused 0x93a1a1
riverctl border-color-unfocused 0x586e75

# Set keyboard repeat rate
riverctl set-repeat 50 300

# Make all views with an app-id that starts with "float" and title "foo" start floating.
riverctl rule-add -app-id 'float*' -title 'foo' float

# Make all views with app-id "bar" and any title use client-side decorations
riverctl rule-add -app-id "bar" csd

# Set the default layout generator to be rivertile and start it.
# River will send the process group of the init executable SIGTERM on exit.
riverctl default-layout rivertile
rivertile -view-padding 6 -outer-padding 6 &
