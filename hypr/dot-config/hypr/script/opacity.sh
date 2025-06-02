#!/usr/bin/env bash

action=${1}
if [ -z "$action" ]; then exit; fi

current=$(hyprctl activeworkspace -j)
