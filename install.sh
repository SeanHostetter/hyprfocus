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
    
    ok "Installed to $INSTALL_DIR"
    echo ""
    echo "Add to your hyprland.conf:"
    echo ""
    echo "  exec-once = hyprfocus-daemon --start"
    echo "  bind = \$mainMod, TAB, exec, $INSTALL_DIR/hyprfocus"
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
    --check|-c) 
        check_deps 
        ;;
    --deps|-d)
        install_deps && check_deps && install
        ;;
    --uninstall|-u)
        uninstall
        ;;
    install|--install|-i)
        check_deps && install
        ;;
    --help|-h)
        usage
        ;;
    *)
        usage
        exit 1
        ;;
esac
