# Contributor: Marco Pompili (emarcs) <marcs.pompili@gmail.com>
# Maintainer: Marco Pompili (emarcs) <marcs.pompili@gmail.com>

pkgname=daphne-git
_pkgname=daphne
pkgver=134.3675284
pkgrel=1
pkgdesc="A command-line multiple arcade laserdisc emulator. GIT fork"
url="http://www.daphne-emu.com/"
license=('GPL')
arch=('i686' 'x86_64')
depends=('glew' 'sdl_mixer' 'zlib' 'gcc-libs' 'libxmu')
makedepends=('git')
provides=('daphne')
conflicts=('daphne')
source=('git+https://github.com/DavidGriffith/daphne.git' 'daphne.sh' 'singe.sh')
sha256sums=('SKIP' 'SKIP' 'SKIP')

pkgver()
{
  cd ${srcdir}/${_pkgname}
  printf "%s.%s" "$(git rev-list --count HEAD)" "$(git rev-parse --short HEAD)"
}

build()
{
  cd ${srcdir}/${_pkgname}
  cd src/vldp2
  ./configure --disable-accel-detect
  make -f Makefile.linux_x64
  cd ..
  ln -fs Makefile.vars.linux_x64 Makefile.vars
  make
  cd ..
}

package()
{
  # Install everything in /usr/share
  cd ${srcdir}/${_pkgname}
  install -Dm755 ${srcdir}/daphne.sh ${pkgdir}/usr/bin/daphne
  #install -Dm755 ${srcdir}/singe.sh ${pkgdir}/usr/bin/singe
  install -Dm755 ${_pkgname}.bin ${pkgdir}/usr/share/${_pkgname}/${_pkgname}.bin
  install -Dm555 libvldp2.so ${pkgdir}/usr/share/${_pkgname}/libvldp2.so
  install -d ${pkgdir}/usr/share/${_pkgname}/{pics,pics/obsolete,roms/cputest,sound}
  install -m644 pics/*.* ${pkgdir}/usr/share/${_pkgname}/pics/
  install -m644 pics/obsolete/*.* ${pkgdir}/usr/share/${_pkgname}/pics/obsolete/
  install -m644 roms/cputest/* ${pkgdir}/usr/share/${_pkgname}/roms/cputest/
  install -m644 sound/* ${pkgdir}/usr/share/${_pkgname}/sound/
}
