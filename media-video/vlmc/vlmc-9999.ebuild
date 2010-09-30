# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

LANGSLONG="ca_ES cs_CZ de_DE es_ES fr_FR gl_ES it_IT ja_JP pl_PL ro_RO ru_RU sk_SK ta_TA tr_TR uk_UA"
LANGS="nl pt_BR sv zh_CN"

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
	sed -e '/INSTALL (FILES AUTHORS COPYING INSTALL NEWS README TRANSLATORS/d' \
		-e '/DESTINATION ${VLMC_DOC_DIR})/d' \
		-i CMakeLists.txt || die "sed failed"
}

src_configure() {
	for lang in ${LANGS}; do
		if ! use linguas_${lang}; then
			rm -f "ts/vlmc_${lang}.ts"
		fi
	done
	for lang in ${LANGSLONG}; do
		if ! use linguas_${lang%_*}; then
			rm -f "ts/vlmc_${lang}.ts"
		fi
	done

	mycmakeargs="${mycmakeargs} -DVLMC_LIB_SUBDIR=$(get_libdir)"

	cmake-utils_src_configure
}
