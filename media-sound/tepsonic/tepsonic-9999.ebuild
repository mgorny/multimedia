# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
LANGSLONG="cs_CZ"

inherit cmake-utils qt4-r2 git-2

EGIT_REPO_URI="git://git.gitorious.org/${PN}/${PN}.git"

DESCRIPTION="Simple small audio player written in C++ using Qt."
HOMEPAGE="http://www.tepsonic.org"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="lastfm mysql +sqlite"

RDEPEND="
	>=dev-qt/qtgui-4.5.0:4
	>=dev-qt/qtsql-4.5.0:4[mysql?,sqlite?]
	x11-libs/libqxt
	|| ( >=dev-qt/qtphonon-4.5.0:4 media-libs/phonon )
	media-libs/taglib
	lastfm? ( media-libs/lastfmlib )
"
DEPEND="${RDEPEND}"

CMAKE_IN_SOURCE_BUILD="1"

REQUIRED_USE="^^ ( sqlite mysql )"

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
