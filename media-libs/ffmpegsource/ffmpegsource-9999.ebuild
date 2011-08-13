# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools subversion

DESCRIPTION="An FFmpeg based source library for easy frame accurate access"
HOMEPAGE="https://code.google.com/p/ffmpegsource/"
ESVN_REPO_URI="http://ffmpegsource.googlecode.com/svn/trunk/"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE="static-libs"

RDEPEND="
	sys-libs/zlib
	virtual/ffmpeg
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}/html" \
		$(use_enable static-libs static) \
		--enable-shared
}

src_install() {
	default

	use static-libs || find "${D}" -name '*.la' -delete
}
