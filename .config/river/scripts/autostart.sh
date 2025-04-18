#!/bin/bash

way-displays >/tmp/way-displays.${XDG_VTNR}.${USER}.log 2>&1 &

PROGRAMS=(
	i3bar-river
	swww-daemon
	/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
)

start() {
	for program in ${PROGRAMS[@]}; do
		riverctl spawn $program &
	done
}

start
