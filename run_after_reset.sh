#!/usr/bin/env bash

set -euo pipefail

programs=(waybar swaync)

if ! command -v hyprctl >/dev/null; then exit 1; fi

for program in "${programs[@]}"; do
    pkill -x "$program" 2>/dev/null || true
    hyprctl dispatch exec "$program" >/dev/null
done
