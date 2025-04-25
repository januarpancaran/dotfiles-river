#!/bin/bash

command_exists() {
  command -v "$1" 2 >/dev/null &>1
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
fi

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

cp ./.zshrc "$HOME"
# Tpm for tmux
git clone https://github.com/tmux-plugins/tpm $HOME/.config/tmux/plugins/tpm

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
