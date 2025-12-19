# hyprfocus

🖼️ Lightweight Hyprland workspace switcher with thumbnail grid preview.

![hyprfocus demo](https://github.com/user/hyprfocus/raw/main/demo.png)

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
