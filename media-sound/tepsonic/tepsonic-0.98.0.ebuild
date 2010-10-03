# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
LANGSLONG="cs_CZ"

inherit cmake-utils qt4-r2

DESCRIPTION="Simple small audio player written in C++ using Qt."
HOMEPAGE="http://www.tepsonic.org"
SRC_URI="http://www.tepsonic.org/files/${P}-src.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="lastfm mysql +sqlite"

DEPEND="
	>=x11-libs/qt-gui-4.5.0:4
	>=x11-libs/qt-sql-4.5.0:4[mysql?,sqlite?]
	|| ( >=x11-libs/qt-phonon-4.5.0:4 media-sound/phonon )
	media-libs/taglib
	lastfm? ( media-libs/lastfmlib )
"
RDEPEND="${DEPEND}"

CMAKE_IN_SOURCE_BUILD="1"

pkg_setup() {
	use !sqlite && use !mysql && ewarn \
		"You need at least one database backend, enable sqlite or mysql."
}

src_configure() {
	# linguas
	local langs
	for x in ${LANGSLONG}; do
		use linguas_${x%_*} && langs+="${x%_*} "
	done

	local mycmakeargs=(
		$(cmake-utils_use_with lastfm LASTFMSCROBBLER)
		-DLANGS="${langs}"
	)
	cmake-utils_src_configure
}
