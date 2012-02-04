# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

DESCRIPTION="AwOken icon theme for SMPlayer"
HOMEPAGE="http://reikonya.deviantart.com/art/AwOken-1-9-for-SMplayer-205536297"
SRC_URI="http://www.deviantart.com/download/205536297/awoken_1_9_for_smplayer_by_reikonya-d3edctl.zip"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="media-video/smplayer"

S="${WORKDIR}"

src_unpack() {
	unpack ${A}
	unpack ./*.tar.gz
	rm ./*.tar.gz || die
}

src_install() {
	insinto /usr/share/smplayer/themes
	doins -r AwOken*
}
