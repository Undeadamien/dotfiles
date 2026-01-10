#!/usr/bin/env bash

set -euo pipefail

pkill -x waybar 2>/dev/null

if command -v hyprctl >/dev/null; then
	hyprctl dispatch exec waybar
fi
