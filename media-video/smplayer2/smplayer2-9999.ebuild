# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
LANGS="bg ca cs da de en_US es et eu fi fr gl hu it ja ka ko ku lt mk nl pl pt pt_BR sk sr sv tr zh_CN zh_TW"
LANGSLONG="ar_SY el_GR ro_RO ru_RU sl_SI uk_UA vi_VN"

inherit qt4-r2 eutils git-2

DESCRIPTION="Qt4 GUI front-end for mplayer2"
HOMEPAGE="https://github.com/lachs0r/SMPlayer2"
EGIT_REPO_URI="git://github.com/lachs0r/SMPlayer2.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug"

DEPEND="
	x11-libs/qt-gui:4
	dev-libs/quazip
"
RDEPEND="${DEPEND}
	media-video/mplayer2[libass,png]
"

src_prepare() {
	# Set version
	local version="0.7.0_pre$(git log -n1 --date=short --format=%cd|tr -d '-')-$(git describe --match "v[0-9]*" --always)"
	sed -i -e "/#define VERSION /s/UNKNOWN/$version/" \
		src/version.cpp || die

	# Fix prefix and doc, don't run qmake in src_compile, don't build all translations
	sed -i \
		-e "/^PREFIX=/s:/usr/local:${EPREFIX}/usr:" \
		-e "/^DOC_PATH=/s:packages/smplayer:${PF}:" \
		-e 's,+cd src && $(QMAKE) $(QMAKE_OPTS) && $(DEFS) make,cd src \&\& $(DEFS) $(MAKE),' \
		-e '/cd src && $(LRELEASE) smplayer2.pro/d' \
		Makefile || die

	# Turn debug message flooding off
	if ! use debug; then
		sed -i 's:#\(DEFINES += NO_DEBUG_ON_CONSOLE\):\1:' \
			src/${PN}.pro || die
	fi
}

src_configure() {
	cd src || die
	eqmake4
}

src_compile() {
	default

	# Generate translations
	cd "${S}"/src/translations || die
	for x in ${LANGS}; do
		if use linguas_${x}; then
			lrelease ${PN}_${x}.ts || die
		fi
	done
	for x in ${LANGSLONG}; do
		if use linguas_${x%_*}; then
			lrelease ${PN}_${x}.ts || die
		fi
	done
	# install fails when no translation is present (bug 244370)
	if [[ -z $(ls *.qm 2>/dev/null) ]]; then
		lrelease ${PN}_en_US.ts || die
	fi
}
