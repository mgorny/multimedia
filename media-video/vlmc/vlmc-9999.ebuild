# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

LANGS="ca cs de es fr gl it ja nl pl pt ro ru sk sv ta tr uk zh"

inherit cmake-utils qt4-r2 git

DESCRIPTION="VideoLAN Movie Creator"
HOMEPAGE="http://www.vlmc.org"
EGIT_REPO_URI="git://git.videolan.org/${PN}.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	>=x11-libs/qt-gui-4.6:4
	>=media-video/vlc-1.1
	media-plugins/frei0r-plugins
	"
RDEPEND="${DEPEND}"

CMAKE_IN_SOURCE_BUILD="1"

DOCS="AUTHORS NEWS README TRANSLATORS"

src_prepare() {
	# we use dodoc
	sed -e '/INSTALL (FILES AUTHORS COPYING INSTALL NEWS README THANKS TRANSLATORS/d' \
		-e '/DESTINATION ${VLMC_DOC_DIR})/d' \
		-i CMakeLists.txt || die "sed failed"
}

src_configure() {
	# linguas
	local langs x
	for x in ${LANGS}; do
		use linguas_${x} && langs+=" ${x}"
	done

	local mycmakeargs=(
		-DLANGS="${langs}"
		-DVLMC_LIB_SUBDIR="$(get_libdir)"
	)
	cmake-utils_src_configure
}
