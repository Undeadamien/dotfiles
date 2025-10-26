#!/usr/bin/env bash

direction=${1}
total=${2}
current=$(hyprctl activeworkspace -j | jq '.id')

if [ -z "$direction" ]; then exit; fi
if [ -z "$total" ]; then exit; fi
if [ -z "$current" ]; then exit; fi

if [ "$direction" == "next" ]; then new=$(((current % total) + 1)); fi
if [ "$direction" == "prev" ]; then new=$(((current + total - 2) % total + 1)); fi

hyprctl dispatch workspace "${new}"
