# Dotfiles

These are my personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/), for a **Wayland + Hyprland** setup.

> Note: This installation guide assumes an Arch-based Linux system.

## Features

### Window Manager & Wayland

- **Hyprland** – dynamic tiling window manager
- **Hypridle** – idle manager
- **Hyprlock** – screen locker
- **Waybar** – status bar
- **Rofi** – application launcher
- **SwayNC** – notification center
- **wlsunset** – night light
- **swww** – wallpaper handler

### Terminal & Shell

- **Kitty** – terminal emulator
- **Zsh** – shell configuration
- **tmux** – terminal multiplexer

### Text Editor

- **Neovim** – terminal-based text editor

### System & Utilities

- **btop** – system monitor
- **mpd/rmpc** – music player
- **Thunar** – file manager
- **GTK** – theme preferences

## Installation

1. Install chezmoi: https://www.chezmoi.io/install/

   ```
   sudo pacman -S chezmoi
   ```

2. Initialize from this repo: https://www.chezmoi.io/reference/commands/init/

   ```
   chezmoi init https://github.com/Undeadamien/dotfiles.git
   ```

   or

   ```
   chezmoi init git@github.com:Undeadamien/dotfiles.git
   ```

3. Apply the dotfiles: https://www.chezmoi.io/reference/commands/apply/
   ```
   chezmoi apply
   ```

A list of required/suggested packages is available in `ignored/packages.txt`.

- These packages are **not automatically installed** by chezmoi
- Obtained using: `sudo pacman -Qqte`
- And there is no distinction between pacman's and AUR's packages

The following script could be used to install the packages.

> Note: this script has not been tested yet.

```
#!/bin/bash

chezmoi cd || exit
while IFS= read -r pkg; do
    if ! sudo pacman -S --needed --noconfirm "$pkg"; then
        yay -S --needed --noconfirm "$pkg"
    fi
done < ignored/packages.txt
```

## Todo / Future Improvements

- [ ] Automate installation of packages
