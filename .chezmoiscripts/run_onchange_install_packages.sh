#!/usr/bin/env bash

set -euo pipefail

PACKAGES_PACMAN=(
    android-file-transfer
    awww
    bat
    brightnessctl
    btop
    chezmoi
    cronie
    discord
    dust
    firefox
    fzf
    glow
    go
    hypridle
    hyprland
    hyprlock
    hyprpaper
    hyprshot
    iwd
    krita
    ly
    mpc
    mpd
    mpv
    neovim
    obsidian
    pavucontrol
    pulsemixer
    python-adblock
    qbittorrent
    qutebrowser
    ripgrep
    rmpc
    rofi
    steam
    swaync
    syncthing
    thunar
    tree
    ttf-ubuntu-font-family
    ttf-ubuntu-mono-nerd
    ttf-ubuntu-nerd
    vlc
    waybar
    wev
    wget
    wlsunset
    yazi
    yt-dlp
    zsh-autocomplete
)
PACKAGES_YAY=(
    opera
    uni
    xp-pen-tablet
)

echo "Updating pacman databases..."
sudo pacman -Syy
sudo pacman -Syu

echo "Installing pacman packages..."
sudo pacman -S --needed --noconfirm "${PACKAGES_PACMAN[@]}"

if ! command -v yay &>/dev/null; then
    echo "Installing yay..."
    sudo pacman -S --needed --noconfirm base-devel git
    rm -rf /tmp/yay
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    (cd /tmp/yay && makepkg --si --noconfirm --nosign)
    rm -rf /tmp/yay
fi

echo "Installing AUR packages..."
yay -S --needed --noconfirm "${PACKAGES_YAY[@]}"

echo "Installation done."
