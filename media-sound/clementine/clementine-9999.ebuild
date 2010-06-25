# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

LANGS=" ar cs da de el en_CA en_GB es fi fr gl it kk nb oc pl pt_BR pt ro ru sk sv tr uk zh_CN zh_TW"

inherit cmake-utils gnome2-utils subversion

DESCRIPTION="A modern music player and library organizer based on Amarok 1.4 and Qt4"
HOMEPAGE="http://code.google.com/p/clementine-player/"
ESVN_REPO_URI="http://clementine-player.googlecode.com/svn/trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="+gstreamer -phonon projectm -vlc -xine"
IUSE+=" ${LANGS// / linguas_}"

GST_COMMON_DEPEND="
	>=media-libs/gstreamer-0.10
	>=media-libs/gst-plugins-base-0.10
"
GST_RDEPEND="
	>=media-plugins/gst-plugins-meta-0.10
	>=media-plugins/gst-plugins-gio-0.10
	>=media-plugins/gst-plugins-soup-0.10
"
COMMON_DEPEND="
	x11-libs/qt-gui:4
	x11-libs/qt-opengl:4
	x11-libs/qt-sql:4[sqlite]
	>=media-libs/taglib-1.6
	media-libs/liblastfm
	dev-libs/glib:2
	gstreamer? ( ${GST_COMMON_DEPEND} )
	phonon? ( x11-libs/qt-phonon:4 )
	vlc? ( <=media-video/vlc-1.0.9999 )
	xine? ( media-libs/xine-lib )
	!phonon? ( !vlc? ( !xine? ( ${GST_COMMON_DEPEND} ) ) )
"
# now only presets are used, libprojectm is internal
# http://code.google.com/p/clementine-player/source/browse/#svn/trunk/3rdparty/libprojectm/patches
RDEPEND="${COMMON_DEPEND}
	projectm? ( >=media-libs/libprojectm-1.2.0 )
	gstreamer? ( ${GST_RDEPEND} )
	!phonon? ( !vlc? ( !xine? ( ${GST_RDEPEND} ) ) )
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.39
	dev-util/pkgconfig
"

DOCS="Changelog TODO"

pkg_setup() {
	if use phonon || use vlc || use xine; then
		ewarn "Only GStreamer engine is officially supported."
		ewarn "_Now_ phonon, vlc, xine USE flags are useless, we keep it here only for testing purposes."
	fi
}

src_configure() {
	# linguas
	local langs
	for x in ${LANGS}; do
		use linguas_${x} && langs+="${x} "
	done

	mycmakeargs=(
		-DLINGUAS="${langs}"
		"-DBUNDLE_PROJECTM_PRESETS=OFF"
		$(cmake-utils_use projectm ENABLE_VISUALISATIONS)
		$(cmake-utils_use gstreamer ENGINE_GSTREAMER_ENABLED)
		$(cmake-utils_use phonon ENGINE_QT_PHONON_ENABLED)
		$(cmake-utils_use vlc ENGINE_LIBVLC_ENABLED)
		$(cmake-utils_use xine ENGINE_LIBXINE_ENABLED)
		)

	if use !phonon && use !vlc && use !xine; then
		mycmakeargs+=(
			"-DENGINE_GSTREAMER_ENABLED=ON"
			)
	fi

	cmake-utils_src_configure
}

pkg_preinst() {
	gnome2_icon_savelist
}

pkg_postinst() {
	gnome2_icon_cache_update
}

pkg_postrm() {
	gnome2_icon_cache_update
}
