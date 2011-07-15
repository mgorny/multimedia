# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools git-2

DESCRIPTION="Library for SSA/ASS subtitles rendering"
HOMEPAGE="http://code.google.com/p/libass/"
EGIT_REPO_URI="git://repo.or.cz/${PN}.git"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+enca +fontconfig static-libs"

RDEPEND="
	fontconfig? ( >=media-libs/fontconfig-2.4.2 )
	>=media-libs/freetype-2.2.1
	virtual/libiconv
	enca? ( app-i18n/enca )
	>=media-libs/harfbuzz-0.7.0"
DEPEND="${RDEPEND}
	dev-util/pkgconfig"

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
