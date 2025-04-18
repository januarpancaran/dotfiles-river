#!/bin/bash

riverctl keyboard-layout -options ctrl:nocaps us

touchpad=$(riverctl list-inputs | grep -i touchpad)

TOUCHPAD_OPTS=(
	events
	drag
	disable-while-typing
	natural-scroll
	tap
	tap-button-map
	scroll-method
)

set_opts() {
	for opts in ${TOUCHPAD_OPTS[@]}; do
		if [ "$opts" = "tap-button-map" ]; then
			riverctl input $touchpad $opts left-right-middle
		elif [ "$opts" = "scroll-method" ]; then
			riverctl input $touchpad $opts two-finger
		else
			riverctl input $touchpad $opts enabled
		fi
	done
}

set_opts
