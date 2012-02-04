# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="Faenza icon theme for SMPlayer"
HOMEPAGE="http://reikonya.deviantart.com/art/Faenza-SMPlayer-1-0-r1-244895655"
SRC_URI="http://www.deviantart.com/download/244895655/faenza_smplayer_1_0_r1_by_reikonya-d41syp3.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="media-video/smplayer"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	unpack ./*.tar.xz
	rm ./*.tar.xz || die
}

src_install() {
	insinto /usr/share/smplayer/themes
	doins -r Faenza*
}
