# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit autotools git-2

DESCRIPTION="An OpenType text shaping engine"
HOMEPAGE="http://freedesktop.org/wiki/Software/HarfBuzz"
EGIT_REPO_URI="git://anongit.freedesktop.org/${PN}"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=dev-libs/glib-2.16
	>=x11-libs/cairo-1.8.0
	dev-libs/icu
	media-libs/freetype:2
"

DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-devel/autoconf-2.64
	>=sys-devel/libtool-2.2
	dev-util/ragel
"

src_prepare() {
	eautoreconf
}

src_install() {
	default

	find "${ED}" -name '*.la' -delete
}
