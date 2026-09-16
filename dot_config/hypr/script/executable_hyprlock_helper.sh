#!/usr/bin/env bash

# Function to get current mute status
is_muted() {
    wpctl get-volume @DEFAULT_AUDIO_SINK@ | grep -q '\[MUTED\]'
}

# Remember initial mute state to avoid unmuting if it was already muted
WAS_MUTED=$(is_muted && echo "1" || echo "0")

# Ensure audio is unmuted on exit only if it was not originally muted
cleanup() {
    if [ "$WAS_MUTED" = "0" ]; then
        wpctl set-mute @DEFAULT_AUDIO_SINK@ 0
    fi
}

# Trap exit signals to ensure cleanup runs even if the script is killed
trap cleanup EXIT SIGINT SIGTERM

# Pause all media players
playerctl --all-players pause >/dev/null 2>&1

# Mute audio if not already muted
if [ "$WAS_MUTED" = "0" ]; then
    wpctl set-mute @DEFAULT_AUDIO_SINK@ 1
fi

# Run hyprlock - this blocks until the screen is unlocked
hyprlock
