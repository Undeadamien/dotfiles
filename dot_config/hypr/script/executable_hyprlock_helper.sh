#!/usr/bin/env bash

IS_MUTED=$(wpctl get-volume @DEFAULT_SINK@ | grep -c MUTED)

playerctl --all-players pause
wpctl set-mute @DEFAULT_SINK@ 1
hyprlock
wpctl set-mute @DEFAULT_SINK@ $IS_MUTED
