# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Official skins for SMPlayer"
HOMEPAGE="http://smplayer.info"
SRC_URI="mirror://sourceforge/smplayer/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~hppa ~ppc ~ppc64 ~x86 ~x86-fbsd"
IUSE=""
DEPEND=""
RDEPEND="media-video/smplayer"

# Override it as default will call make that will catch the install target...
src_compile() {
	return
}

src_install() {
	insinto /usr/share/smplayer
	doins -r themes
	dodoc Changelog README.txt
}
