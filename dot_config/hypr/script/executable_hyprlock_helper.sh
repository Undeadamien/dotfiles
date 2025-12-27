#!/usr/bin/env bash

VOLUME=$(wpctl get-volume @DEFAULT_SINK@ | awk '{printf $2}')

playerctl --all-players pause
wpctl set-volume @DEFAULT_SINK@ 0
hyprlock
wpctl set-volume @DEFAULT_SINK@ $VOLUME
