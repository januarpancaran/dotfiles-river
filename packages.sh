#!/bin/bash

APPS=(
	# WM
	river

	# Terminal
	ghostty

	# Menu
	rofi-wayland

	# Themes
	bibata-cursor-theme-bin
	dracula-gtk-theme
	dracula-icons-theme
	papirus-icon-theme

	# Bar
	waybar

	# Lockscreen
	swayidle
	swaylock-effects
	wlogout

	# Others
	blueberry
	discord
	gnome-control-center
	google-chrome
	mpv
	nautilus
	neovim
	networkmanager
	obs-studio
	pavucontrol
	spotify-launcher
	telegram-desktop
	zsh
)

UTILS=(
	# Sound
	alsa-firmware
	alsa-utils
	pipewire
	pipewire-alsa
	pipewire-pulse
	wireplumber

	# Brightness
	brightnessctl

	# Bluetooth
	bluez
	bluez-utils

	# Seatd
	seatd

	# Notification
	dunst

	# Disk
	gvfs
	polkit-gnome
	xorg-xhost

	# Screenshot
	grim
	slurp

	# Background
	swww

	# Auto-cpufreq
	auto-cpufreq

	# Timeshift
	timeshift-autosnap

	# Firewalld
	firewalld

	# Apparmor
	apparmor

	# Others
	bat
	fastfetch
	fzf
	git
	htop
	kanshi
	nodejs
	npm
	openssh
	playerctl
	ripgrep
	starship
	tmux
	trash-cli
	unrar
	unzip
	wget
	wl-clipboard
	wlopm
	wlr-randr
	xdg-desktop-portal
	xdg-desktop-portal-gtk
	xdg-desktop-portal-wlr
	xwaylandvideobridge
	yazi
	zip
	zoxide
)

FONTS=(
	noto-fonts-cjk
	noto-fonts-emoji
	otf-font-awesome
	ttf-jetbrains-mono-nerd
	ttf-space-mono-nerd
	ttf-ms-win11-auto
)

ADD_GROUP=(
	input
	seat
)

SERVICES=(
	# System
	auto-cpufreq
	apparmor
	bluetooth
	firewalld
	seatd

	# User
	pipewire
)
