#!/usr/bin/env bash
# install.sh - Install hyprfocus

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="${HOME}/.local/bin"

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

ok() { echo -e "${GREEN}✓${NC} $*"; }
warn() { echo -e "${YELLOW}!${NC} $*"; }
err() { echo -e "${RED}✗${NC} $*"; }

DEPS=(rofi jq grim socat)

check_deps() {
  local missing=()
  for cmd in hyprctl "${DEPS[@]}"; do
    command -v "$cmd" &>/dev/null || missing+=("$cmd")
  done

  if [[ ${#missing[@]} -gt 0 ]]; then
    err "Missing: ${missing[*]}"
    echo ""
    echo "Install dependencies:"
    echo "  Arch: pacman -S rofi-wayland jq grim socat"
    echo "  Fedora: dnf install rofi jq grim socat"
    return 1
  fi
  ok "Dependencies OK"
}

install_deps() {
  echo "Installing dependencies..."
  if command -v pacman &>/dev/null; then
    sudo pacman -S --needed --noconfirm rofi-wayland jq grim socat
  elif command -v dnf &>/dev/null; then
    sudo dnf install -y rofi jq grim socat
  elif command -v apt &>/dev/null; then
    sudo apt install -y rofi jq grim socat
  else
    err "Unknown package manager. Install manually: ${DEPS[*]}"
    return 1
  fi
  ok "Dependencies installed"
}

install() {
  mkdir -p "$INSTALL_DIR"
  cp "$SCRIPT_DIR/hyprfocus" "$INSTALL_DIR/"
  cp "$SCRIPT_DIR/hyprfocus-daemon" "$INSTALL_DIR/"
  chmod +x "$INSTALL_DIR/hyprfocus" "$INSTALL_DIR/hyprfocus-daemon"

  # Install default config if user doesn't have one
  local config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/hyprfocus"
  mkdir -p "$config_dir"
  if [[ ! -f "$config_dir/config" && -f "$SCRIPT_DIR/config.default" ]]; then
    cp "$SCRIPT_DIR/config.default" "$config_dir/config"
    ok "Created config: $config_dir/config"
  fi

  ok "Installed to $INSTALL_DIR"

  # Hyprland config
  local hypr_conf="$HOME/.config/hypr/hyprland.conf"
  local hypr_lines=(
    "# hyprfocus - workspace switcher"
    "exec-once = hyprfocus-daemon --start"
    "windowrulev2 = noanim, class:^(Rofi)$"
  )

  echo ""
  if [[ -f "$hypr_conf" ]]; then
    # Check if already configured
    if grep -q "hyprfocus-daemon" "$hypr_conf" 2>/dev/null; then
      warn "hyprland.conf already has hyprfocus config"
    else
      echo "Add to hyprland.conf? [y/N] "
      read -r response
      if [[ "$response" =~ ^[Yy]$ ]]; then
        echo "" >>"$hypr_conf"
        for line in "${hypr_lines[@]}"; do
          echo "$line" >>"$hypr_conf"
        done
        ok "Added to hyprland.conf"
        echo "  Run: hyprctl reload"
      else
        echo "Add manually to $hypr_conf:"
        echo ""
        for line in "${hypr_lines[@]}"; do
          echo "  $line"
        done
      fi
    fi
  else
    echo "Add to your hyprland.conf:"
    echo ""
    for line in "${hypr_lines[@]}"; do
      echo "  $line"
    done
  fi

  echo ""
  # Check if ~/.local/bin is in PATH
  if [[ ":$PATH:" != *":$INSTALL_DIR:"* ]]; then
    warn "$INSTALL_DIR is not in your PATH"
    echo "  Add to your shell config: export PATH=\"\$HOME/.local/bin:\$PATH\""
  fi
}

uninstall() {
  rm -f "$INSTALL_DIR/hyprfocus" "$INSTALL_DIR/hyprfocus-daemon"
  rm -rf "${XDG_CACHE_HOME:-$HOME/.cache}/hyprfocus"
  rm -rf "${XDG_CONFIG_HOME:-$HOME/.config}/hyprfocus"
  ok "Uninstalled"
}

usage() {
  echo "hyprfocus installer"
  echo ""
  echo "Usage: ./install.sh [OPTION]"
  echo ""
  echo "Options:"
  echo "  install      Install hyprfocus (default)"
  echo "  --deps       Install dependencies first, then install"
  echo "  --check      Check dependencies only"
  echo "  --uninstall  Remove hyprfocus"
  echo "  --help       Show this help"
}

case "${1:-install}" in
--check | -c)
  check_deps
  ;;
--deps | -d)
  install_deps && check_deps && install
  ;;
--uninstall | -u)
  uninstall
  ;;
install | --install | -i)
  check_deps && install
  ;;
--help | -h)
  usage
  ;;
*)
  usage
  exit 1
  ;;
esac
