#!/usr/bin/env bash
set -euo pipefail

sudo pacman -R waybar 2>/dev/null || true
dir="$HOME/.local/src/waybar"
mkdir -p "$dir"
if [[ ! -d "$dir/.git" ]]; then git clone https://github.com/Alexays/Waybar "$dir"; fi
cd "$dir"
git pull --ff-only origin master
meson setup build --reconfigure -Dtests=disabled -Dcava=disabled -Dprefix="/usr/local"
ninja -C build
sudo ninja -C build install
