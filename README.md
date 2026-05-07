# Dotfiles

Personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/), for a **Hyprland** setup, designed for an Arch-based system

<div align="center">
  <img src="./assets/screenshot_0.png" width="49%">
  <img src="./assets/screenshot_1.png" width="49%">
</div>

<p align="center">
  <i>Wallpapers from <a href=https://www.instagram.com/guweiz/>Guweiz</a> and <a href=https://www.instagram.com/wlop/>WLOP</a></i>
</p>

## Features

### Desktop environment

- `hypridle` - idle manager
- `hyprland` - window manager
- `hyprlock` - screen locker
- `rofi` - app launcher
- `swaync` - notification center
- `awww` - wallpaper daemon
- `thunar` - file manager
- `waybar` - status bar
- `wlsunset` - night light

### Terminal

- `btop` - system monitor
- `kitty` - terminal emulator
- `mpd/rmpc` - daemon/TUI music player
- `neovim` - text editor
- `tmux` - terminal multiplexer
- `yazi` - TUI file manager
- `zsh` - shell

### Other

- `yay` - AUR helper

## Installation

**1. Install chezmoi**

```bash
# https://www.chezmoi.io/install/
sudo pacman -S chezmoi
```

**2. Clone and apply the repo with the preferred method:**

```bash
# https://www.chezmoi.io/reference/commands/init/
chezmoi init git@github.com:Undeadamien/dotfiles.git -a
```

```bash
# https://www.chezmoi.io/reference/commands/init/
chezmoi init https://github.com/Undeadamien/dotfiles.git -a
```

During `chezmoi apply`, multiple [scripts](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/) will run, helping with different tasks:

- Install packages (pacman & yay)
- Restart applications
- Cleanup files
