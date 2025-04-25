#!/bin/bash

command_exists() {
	command -v "$1" &>/dev/null
}

# Checking SUDO
SUDO_CMD=""

if command_exists sudo; then
	SUDO_CMD="sudo"
elif command_exists doas; then
	SUDO_CMD="doas"
else
	echo "No Sudo Command Detected!"
	exit 1
fi

# Checking AUR Helper
AUR_HELPER=""

if command_exists yay; then
	AUR_HELPER="yay"
elif command_exists paru; then
	AUR_HELPER="paru"
else
	echo "No AUR Helper Detected!"
	read -p "Install Yay? [y/N]" aur
	if [[ "$aur" =~ ^[Yy]$ ]]; then
		git clone https://aur.archlinux.org/yay.git
		cd yay
		makepkg -si --noconfirm
		cd ..
		rm -rf yay

		AUR_HELPER="yay"
	else
		echo "Please Install yay or paru!"
		exit 1
	fi
fi

echo "$AUR_HELPER installed! Proceeding Installation..."

source packages.sh

install() {
	$AUR_HELPER -S --noconfirm "$@"
}

echo "Installing Packages..."
install "${APPS[@]}"

echo "Installing Utilities..."
install "${UTILS[@]}"

echo "Installing Fonts..."
install "${FONTS[@]}"

echo "Adding User Groups..."
for group in "${ADD_GROUP[@]}"; do
	${SUDO_CMD} usermod -aG "$group" "$USER"
done

echo "Enabling Services..."
for service in "${SERVICES[@]}"; do
	if [ "$service" = "pipewire" ]; then
		systemctl enable --user --now "$service"
	else
		${SUDO_CMD} systemctl enable --now "$service"
	fi
done

read -p "Change Shell? [y/N]" confirmation
if [[ "$confirmation" =~ ^[Yy]$ ]]; then
	chsh -s "$(which zsh)"
	echo "Shell changed successfully"
else
	echo "Default shell not changed"
fi

SRC_DIR="./.config/"
CONFIG_DIR=""

if [ -d "$XDG_CONFIG_HOME" ]; then
	CONFIG_DIR="$XDG_CONFIG_HOME"
else
	CONFIG_DIR="$HOME/.config"
fi

for dir in "$SRC_DIR"*; do
	base_dir=$(basename "$dir")
	des_dir="$CONFIG_DIR/$base_dir"

	if [ -d "$des_dir" ]; then
		mv -v "$des_dir" "$des_dir".bak
	fi

	cp -r "$dir" "$des_dir"
done

LOCAL_BIN_SRC="./.local/bin/"
LOCAL_BIN_DES="$HOME/.local/bin/"

if [ ! -d "$LOCAL_BIN_DES" ]; then
	mkdir -p "$LOCAL_BIN_DES"
fi

for files in "$LOCAL_BIN_SRC"*; do
	cp "$files" "$LOCAL_BIN_DES"
done

cp ./.zshrc "$HOME"
# Tpm for tmux
git clone https://github.com/tmux-plugins/tpm $HOME/.config/tmux/plugins/tpm

# Systemd timers
echo "Creating systemd timers..."
SYSTEMD_DIR="$HOME/.config/systemd/user/"

if [ ! -d "$SYSTEMD_DIR" ]; then
	mkdir -p "$SYSTEMD_DIR"
fi

# Battery notification
cat >"$SYSTEMD_DIR/batterynotify.service" <<EOF
[Unit] 
Description=Battery Notification Script

[Service]
ExecStart=%h/.local/bin/batterynotify
EOF

cat >"$SYSTEMD_DIR/batterynotify.timer" <<EOF
[Unit]
Description=Run Battery Notification Script every 5 minutes

[Timer]
OnCalendar=*:0/5
Unit=batterynotify.service

[Install]
WantedBy=timers.target
EOF

# Trash emptying
cat >"$SYSTEMD_DIR/trash-empty.service" <<EOF
[Unit] 
Description=Empty Trash older than 30 days

[Service]
ExecStart=/sbin/trash-empty 30
EOF

cat >"$SYSTEMD_DIR/trash-empty.timer" <<EOF
[Unit]
Description=Run Trash Emptying Daily

[Timer]
OnCalendar=daily
Unit=trash-empty.service

[Install]
WantedBy=timers.target
EOF

systemctl --user daemon-reload
systemctl --user enable --now batterynotify.timer
systemctl --user enable --now trash-empty.timer

# Power udev rules
echo "Creating power udev rules..."

USERNAME=$(whoami)
HOME_DIR=$HOME
UDEV_RULES_FILE="/etc/udev/rules.d/99-chargingnotify.rules"
CHARGING_NOTIFY_SCRIPT="$HOME_DIR/.local/bin/chargingnotify"
WAYLAND_DISPLAY="wayland-0"
DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus"

if [ ! -x "$CHARGING_NOTIFY_SCRIPT" ]; then
	echo "Error: $CHARGING_NOTIFY_SCRIPT does not exist or is not executable."
	exit 1
fi

# Creating the udev rules
sudo bash -c "cat > $UDEV_RULES_FILE" <<EOF
ACTION=="change", SUBSYSTEM=="power_supply", ATTRS{type}=="Mains", ATTRS{online}=="1", ENV{WAYLAND_DISPLAY}="$WAYLAND_DISPLAY", ENV{DBUS_SESSION_BUS_ADDRESS}="$DBUS_SESSION_BUS_ADDRESS" RUN+="/usr/bin/su $USERNAME -c '$CHARGING_NOTIFY_SCRIPT 1'"
ACTION=="change", SUBSYSTEM=="power_supply", ATTRS{type}=="Mains", ATTRS{online}=="0", ENV{WAYLAND_DISPLAY}="$WAYLAND_DISPLAY", ENV{DBUS_SESSION_BUS_ADDRESS}="$DBUS_SESSION_BUS_ADDRESS" RUN+="/usr/bin/su $USERNAME -c '$CHARGING_NOTIFY_SCRIPT 0'"
EOF

sudo udevadm control --reload-rules
sudo udevadm trigger

read -p "Do you want to add a .zlogin script for autologin? [y/N]: " autologin
if [[ "$autologin" =~ ^[Yy]$ ]]; then
	cat >"$HOME/.zlogin" <<'EOF'
if [ -z "$WAYLAND_DISPLAY" ] && [ "$(tty)" = "/dev/tty1" ]; then
  exec river
fi
EOF
	echo ".zlogin created successfully."
fi

echo "Dotfiles Installation Completed!"
