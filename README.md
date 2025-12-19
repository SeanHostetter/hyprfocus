# hyprfocus

🖼️ Lightweight Hyprland workspace switcher with thumbnail grid preview.

![hyprfocus demo](https://github.com/SeanHostetter/hyprfocus/demo.gif)

## Features

- 🖼️ **Grid layout** with live workspace thumbnails
- ⌨️ **Vim navigation** (hjkl) + arrow keys
- 🔄 **Toggle behavior** - same keybind opens/closes
- ⚡ **Fast** - low-res periodic screenshots
- 🎨 **Theme support** - auto-reads kitty/omarchy colors
- ➕ **Create workspaces** - press Space to create new
- �️ **Multi-monitor** - captures all visible workspaces

## Dependencies

- `rofi-wayland` - UI framework
- `grim` - screenshot tool
- `jq` - JSON parser
- `socat` - socket communication
- `hyprctl` - Hyprland control (comes with Hyprland)

## Note on performance and limitations:
- 'grim' is used for screenshots to generate thumbnails, which can be slow on large displays. A screenshot is captured every 7 seconds, on workspace switch, and on workspace creation. A scale of 0.15 is used to speed up capture.
-The user+sys time of each screenshot is about 0.082 seconds on my system.
- Hyprfocus is written in bash, which is not the most performant, and is not multithreaded
-If you have any suggestions for improvement, please open an issue or submit a pull request, or fork it and make your own version! I made this in a few hours for my own use, so I will likely not be doing a lot of continuous development on it.
-you can turn off thumbnail generation by setting the CAPTURE_DELAY variable to 0 in the hyprfocus-daemon script.

## Installation

### Quick Install (from source)

```bash
git clone https://github.com/YOUR_USERNAME/hyprfocus.git
cd hyprfocus
./install.sh
```

### With Dependencies

```bash
# Install deps first (Arch)
./install.sh --deps
```

### Manual

```bash
# Arch Linux
pacman -S rofi-wayland jq grim socat

# Copy scripts
cp hyprfocus hyprfocus-daemon ~/.local/bin/
chmod +x ~/.local/bin/hyprfocus ~/.local/bin/hyprfocus-daemon
```

## Hyprland Configuration

Add to `~/.config/hypr/hyprland.conf`:

```conf
# Start daemon on login
exec-once = hyprfocus-daemon --start

# Keybinding (toggle)
bind = $mainMod, TAB, exec, ~/.local/bin/hyprfocus
```

## Usage

### Keybindings

| Key | Action |
|-----|--------|
| `h` / `←` | Move left |
| `l` / `→` | Move right |
| `k` / `↑` | Move up |
| `j` / `↓` | Move down |
| `Enter` | Switch to workspace |
| `Space` | Create new workspace |
| `Esc` / `q` | Close |

### Commands

```bash
hyprfocus                # Open switcher (toggle)
hyprfocus --capture      # Capture current workspace
hyprfocus --refresh      # Refresh all thumbnails
hyprfocus --help         # Show help
```

### Daemon Commands

```bash
hyprfocus-daemon --start    # Start daemon (detached)
hyprfocus-daemon --stop     # Stop daemon
hyprfocus-daemon --restart  # Restart daemon
hyprfocus-daemon --status   # Check if running
hyprfocus-daemon --log      # Watch daemon log
hyprfocus-daemon --clear    # Clear thumbnail cache
```

## How It Works

1. **Daemon** runs in background, captures thumbnails:
   - On every workspace switch
   - Every 7 seconds (all monitors)
   - On new workspace creation

2. **Hyprfocus** opens rofi with cached thumbnails in a grid

3. **Theming** auto-reads colors from `~/.config/omarchy/current/theme/kitty.conf`

## Files

| Path | Description |
|------|-------------|
| `~/.local/bin/hyprfocus` | Main script |
| `~/.local/bin/hyprfocus-daemon` | Background capture daemon |
| `~/.cache/hyprfocus/` | Thumbnail cache |
| `~/.config/hyprfocus/grid.rasi` | Generated rofi theme |

## Uninstall

```bash
./install.sh --uninstall
```

## License

MIT
