# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
KDE_REQUIRED="optional"
PLOCALES="cs de en_GB es hu ko pl ru zh_CN"
inherit kde4-base l10n subversion

DESCRIPTION="A featureful and configurable Qt4 client for the music player daemon (MPD)"
HOMEPAGE="https://code.google.com/p/cantata/"
ESVN_REPO_URI="http://cantata.googlecode.com/svn/trunk/"

LICENSE="GPL-2"
SLOT="4"
KEYWORDS=""
IUSE="cddb cdda devices dynamic http-server kde lame mtp musicbrainz online-services qt5 replaygain streams taglib"
REQUIRED_USE="
	cddb? ( cdda taglib )
	cdda? ( devices || ( cddb musicbrainz )  )
	lame? ( cdda taglib )
	mtp? ( devices taglib )
	musicbrainz? ( cdda taglib )
	online-services? ( taglib )
	qt5? ( !kde )
	replaygain? ( taglib )
"

DEPEND="
	cdda? ( media-sound/cdparanoia )
	cddb? ( media-libs/libcddb )
	kde? ( $(add_kdebase_dep kwalletd) )
	lame? ( media-sound/lame )
	mtp? ( media-libs/libmtp )
	musicbrainz? ( media-libs/musicbrainz:5 )
	qt5? (
		dev-qt/qtconcurrent:5
		dev-qt/qtnetwork:5
		dev-qt/qtsvg:5
		dev-qt/qtwidgets:5
		dev-qt/qtxml:5
	)
	!qt5? (
		dev-qt/qtcore:4
		dev-qt/qtdbus:4
		dev-qt/qtgui:4
	)
	replaygain? (
		media-libs/speex
		media-sound/mpg123
		virtual/ffmpeg
	)
	taglib? (
		media-libs/taglib[asf,mp4]
		media-libs/taglib-extras
		!kde? ( devices? ( sys-fs/udisks:2 ) )
	)
	dev-libs/qjson
	sys-libs/zlib
	x11-libs/libX11
"
RDEPEND="${DEPEND}
	$(add_kdebase_dep oxygen-icons)
"

# cantata has no tests
RESTRICT="test"

src_prepare() {
	kde4-base_src_prepare

	rm -rf 3rdparty/qtsingleapplication/ || die
	# qjson ebuild does not support Qt5 yet
	use qt5 || { rm -rf 3rdparty/qjson/ || die ;}
	use kde && { rm -rf 3rdparty/solid-lite/ || die ;}

	l10n_find_plocales_changes 'po' '' '.po'
}

src_configure() {
	local langs="$(l10n_get_locales)"

	local mycmakeargs=(
		-DCANTATA_TRANSLATIONS="${langs// /;}"
		$(cmake-utils_use_enable cdda CDPARANOIA)
		$(cmake-utils_use_enable cddb)
		$(cmake-utils_use_enable devices DEVICES_SUPPORT)
		$(cmake-utils_use_enable dynamic)
		$(cmake-utils_use_enable http-server HTTP_SERVER)
		$(cmake-utils_use_enable kde)
		$(cmake-utils_use_enable kde kwallet)
		$(cmake-utils_use_enable lame)
		$(cmake-utils_use_enable mtp)
		$(cmake-utils_use_enable musicbrainz)
		$(cmake-utils_use_enable online-services ONLINE_SERVICES)
		$(cmake-utils_use_enable streams)
		$(cmake-utils_use_enable qt5)
		$(cmake-utils_use_enable replaygain FFMPEG)
		$(cmake-utils_use_enable replaygain MPG123)
		$(cmake-utils_use_enable replaygain SPEEXDSP)
		$(cmake-utils_use_enable taglib)
		$(cmake-utils_use_enable taglib TAGLIB_EXTRAS)
		-DENABLE_HTTPS_SUPPORT=ON
		-DENABLE_HTTP_STREAM_PLAYBACK=OFF
		-DENABLE_REMOTE_DEVICES=OFF
		-DENABLE_UDISKS2=ON
		-DUSE_SYSTEM_MENU_ICON=OFF
	)
	kde4-base_src_configure
}
