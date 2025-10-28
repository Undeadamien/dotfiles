#!/usr/bin/env bash

cd "$HOME"
sudo pacman -S --needed git base-devel && git clone https://aur.archlinux.org/yay-bin.git && cd yay-bin && makepkg -si
rm -rf yay-bin
