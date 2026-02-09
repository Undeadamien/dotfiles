# Dotfiles

Personal dotfiles, managed with [chezmoi](https://www.chezmoi.io/), for a **Hyprland** setup, designed for an Arch-based system

## Features

### Desktop environment

- `hypridle` - idle manager
- `hyprland` - window manager
- `hyprlock` - screen locker
- `rofi` - app launcher
- `swaync` - notification center
- `swww` - wallpaper daemon
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

## Todo / Future Improvements

**Dotfiles**

- [ ] Add a notification module to `waybar` [example](https://github.com/ErikReider/SwayNotificationCenter?tab=readme-ov-file#waybar-example)
- [ ] Configure `yazi`

**Chezmoi**

- [ ] Configure nvim using [run_once](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/)
- [ ] Configure systemd services using [run_onchange](https://www.chezmoi.io/user-guide/use-scripts-to-perform-actions/)
- [ ] Sync `hex.toml` and `rgb.toml` while following chezmoi's [application-order](https://www.chezmoi.io/reference/application-order/)

**Readme**

- [ ] Add screenshots/gifs
- [ ] Add some decorations/badges
