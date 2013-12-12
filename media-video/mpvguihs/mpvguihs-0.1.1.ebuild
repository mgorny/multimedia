# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="https://github.com/sebadoom/mpvguihs.git"

CABAL_FEATURES="bin"
inherit haskell-cabal eutils
[[ ${PV} == *9999* ]] && inherit git-r3

DESCRIPTION="A minimalist mpv GUI written in I/O heavy Haskell"
HOMEPAGE="https://github.com/sebadoom/mpvguihs"
[[ ${PV} == *9999* ]] || \
SRC_URI="mirror://hackage/packages/archive/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
[[ ${PV} == *9999* ]] || \
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	media-video/mpv
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}
	>=dev-haskell/cabal-1.16.0
	>=dev-haskell/gtk-0.12 <dev-haskell/gtk-0.13
	dev-haskell/mtl
	>=dev-lang/ghc-7.6.1
"

src_install() {
	haskell-cabal_src_install

	domenu mpvguihs.desktop
	doicon mpvguihs.png
}
