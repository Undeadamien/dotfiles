#!/usr/bin/env bash

STATE_FILE="/tmp/hypr_all_opaque"

if [ -f "$STATE_FILE" ]; then
    hyprctl keyword 'windowrule[all-opaque]:enable 0'
    rm "$STATE_FILE"
else
    hyprctl keyword 'windowrule[all-opaque]:enable 1'
    touch "$STATE_FILE"
fi
