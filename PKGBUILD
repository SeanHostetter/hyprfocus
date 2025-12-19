# Maintainer: Your Name <your.email@example.com>
pkgname=hyprfocus
pkgver=1.0.0
pkgrel=1
pkgdesc="Lightweight Hyprland workspace switcher with thumbnail grid preview"
arch=('any')
url="https://github.com/YOUR_USERNAME/hyprfocus"
license=('MIT')
depends=('rofi-wayland' 'jq' 'grim' 'socat' 'hyprland')
source=("$pkgname-$pkgver.tar.gz::$url/archive/v$pkgver.tar.gz")
sha256sums=('SKIP')

package() {
    cd "$srcdir/$pkgname-$pkgver"
    
    # Install binaries
    install -Dm755 hyprfocus "$pkgdir/usr/bin/hyprfocus"
    install -Dm755 hyprfocus-daemon "$pkgdir/usr/bin/hyprfocus-daemon"
    
    # Install default config to /etc (user can copy to ~/.config/hyprfocus/config)
    install -Dm644 config.default "$pkgdir/etc/hyprfocus/config.default"
    
    # Install docs
    install -Dm644 README.md "$pkgdir/usr/share/doc/$pkgname/README.md"
    install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}

post_install() {
    echo "hyprfocus installed!"
    echo ""
    echo "To create your config:"
    echo "  mkdir -p ~/.config/hyprfocus"
    echo "  cp /etc/hyprfocus/config.default ~/.config/hyprfocus/config"
    echo ""
    echo "Add to hyprland.conf:"
    echo "  # hyprfocus - workspace switcher"
    echo "  exec-once = hyprfocus-daemon --start"
    echo "  bind = \$mainMod, TAB, exec, hyprfocus"
    echo "  windowrulev2 = noanim, class:^(Rofi)$"
}

post_upgrade() {
    post_install
}
