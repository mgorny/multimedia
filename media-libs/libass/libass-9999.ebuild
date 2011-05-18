# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libass/libass-0.9.11.ebuild,v 1.10 2011/04/05 17:44:35 scarabeus Exp $

EAPI=4

inherit autotools git-2

DESCRIPTION="Library for SSA/ASS subtitles rendering"
HOMEPAGE="http://code.google.com/p/libass/"
EGIT_REPO_URI="git://repo.or.cz/${PN}.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS=""
IUSE="+enca +fontconfig static-libs"

RDEPEND="
	fontconfig? ( >=media-libs/fontconfig-2.4.2 )
	>=media-libs/freetype-2.2.1
	virtual/libiconv
	enca? ( app-i18n/enca )
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
"

DOCS="Changelog"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		$(use_enable enca) \
		$(use_enable fontconfig) \
		$(use_enable static-libs static)
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete
}
