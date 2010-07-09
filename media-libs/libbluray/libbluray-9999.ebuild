# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2
inherit autotools git

EGIT_REPO_URI="git://git.videolan.org/libbluray.git"

DESCRIPTION="Blu-ray playback libraries"
HOMEPAGE="http://www.videolan.org/ http://git.videolan.org/?p=libbluray.git;a=summary"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="aacs"

RDEPEND="aacs? ( media-video/aacskeys )"
DEPEND=""

src_prepare() {
	eautoreconf
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc doc/README TODO.txt || die
}
