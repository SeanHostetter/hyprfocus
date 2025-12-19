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
    
    install -Dm755 hyprfocus "$pkgdir/usr/bin/hyprfocus"
    install -Dm755 hyprfocus-daemon "$pkgdir/usr/bin/hyprfocus-daemon"
    install -Dm644 README.md "$pkgdir/usr/share/doc/$pkgname/README.md"
    install -Dm644 LICENSE "$pkgdir/usr/share/licenses/$pkgname/LICENSE"
}
