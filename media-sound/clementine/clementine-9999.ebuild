# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

LANGS="ar cs da de el en_CA en_GB es fi fr gl it kk nb oc pl pt_BR pt ro ru sk sv tr zh_CN zh_TW"

inherit qt4-r2 cmake-utils subversion

DESCRIPTION="A modern music player and library organizer based on Amarok 1.4 and Qt4"
HOMEPAGE="http://code.google.com/p/clementine-player/"
ESVN_REPO_URI="http://clementine-player.googlecode.com/svn/trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+gstreamer -phonon projectm vlc xine"

COMMON_DEPEND="x11-libs/qt-gui:4
	x11-libs/qt-opengl:4
	x11-libs/qt-sql:4[sqlite]
	>=media-libs/taglib-1.6
	media-libs/liblastfm
	dev-libs/glib:2
	gstreamer? ( >=media-libs/gstreamer-0.10
		>=media-libs/gst-plugins-base-0.10 )
	phonon? ( || ( x11-libs/qt-phonon:4 media-sound/phonon ) )
	vlc? ( media-video/vlc )
	xine? ( media-libs/xine-lib )
	!gstreamer? ( !phonon? ( !vlc? ( media-libs/xine-lib ) ) )"
# now only presets are used, libprojectm is internal
# http://code.google.com/p/clementine-player/source/browse/#svn/trunk/3rdparty/libprojectm/patches
RDEPEND="${COMMON_DEPEND}
	projectm? ( >=media-libs/libprojectm-1.2.0 )
	gstreamer? ( >=media-plugins/gst-plugins-meta-0.10
		>=media-plugins/gst-plugins-gio-0.10 )"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.39
	dev-util/pkgconfig"
DOCS="Changelog TODO"

pkg_setup() {
	use phonon && ewarn "Phonon support is broken."
}

src_prepare() {
	sed -e '/DESTINATION /s:share/icons/hicolor/64x64/apps/:share/pixmaps/:' \
		-i src/CMakeLists.txt || die "sed failed"
}

src_configure() {
	# linguas
	local langs
	for x in ${LANGS}; do
		use linguas_${x} && langs+="${x} "
	done

	mycmakeargs=(
		-DLINGUAS="${langs}"
		-DBUNDLE_PROJECTM_PRESETS=OFF
		$(cmake-utils_use projectm ENABLE_VISUALISATIONS)
		$(cmake-utils_use gstreamer ENGINE_GSTREAMER_ENABLED)
		$(cmake-utils_use phonon ENGINE_QT_PHONON_ENABLED)
		$(cmake-utils_use vlc ENGINE_LIBVLC_ENABLED)
		$(cmake-utils_use xine ENGINE_LIBXINE_ENABLED)
		)

	if ! use gstreamer && ! use phonon && ! use vlc; then
		mycmakeargs+=(
			"-DENGINE_LIBXINE_ENABLED=ON"
			)
	fi

	cmake-utils_src_configure
}
