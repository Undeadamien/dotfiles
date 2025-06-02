#!/usr/bin/env bash

set -e

wallpaper_path="$(swww query | grep -o 'image: \S*' | awk '{print $2}')"
tmp_file="$(mktemp)"
sed -e "s@path_placeholder@${wallpaper_path}@" ~/.config/hypr/hyprlock.conf >"$tmp_file"
hyprlock -c "$tmp_file"
