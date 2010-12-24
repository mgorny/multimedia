# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

LANGS=" ar be bg br ca cs cy da de el en_CA en_GB eo es et eu fi fr gl he hi hu it ja kk lt nb nl oc pl pt_BR pt ro ru sk sl sr sv tr uk zh_CN zh_TW"

inherit cmake-utils gnome2-utils subversion

DESCRIPTION="A modern music player and library organizer based on Amarok 1.4 and Qt4"
HOMEPAGE="http://www.clementine-player.org/ http://code.google.com/p/clementine-player/"
ESVN_REPO_URI="http://clementine-player.googlecode.com/svn/trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="ayatana +gstreamer iphone ipod +lastfm mtp -phonon projectm -vlc wiimote -xine"
IUSE+="${LANGS// / linguas_}"

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
	>=x11-libs/qt-gui-4.5:4[dbus]
	>=x11-libs/qt-opengl-4.5:4
	>=x11-libs/qt-sql-4.5:4[sqlite]
	dev-db/sqlite[fts3]
	>=media-libs/taglib-1.6
	>=dev-libs/glib-2.24.1-r1:2
	dev-libs/libxml2
	ayatana? ( dev-libs/libindicate-qt )
	gstreamer? ( ${GST_COMMON_DEPEND} )
	phonon? ( x11-libs/qt-phonon:4 )
	vlc? ( <=media-video/vlc-1.0.9999 )
	xine? ( media-libs/xine-lib )
	!phonon? ( !vlc? ( !xine? ( ${GST_COMMON_DEPEND} ) ) )
	ipod? (
		>=media-libs/libgpod-0.7.92
		iphone? (
			app-pda/libplist
			>=app-pda/libimobiledevice-1.0
			app-pda/usbmuxd
		)
	)
	lastfm? ( media-libs/liblastfm )
	mtp? ( >=media-libs/libmtp-1.0.0 )
	projectm? ( media-libs/glew )
"
# now only presets are used, libprojectm is internal
# http://code.google.com/p/clementine-player/source/browse/#svn/trunk/3rdparty/libprojectm/patches
# r1966 "Compile with a static sqlite by default, since Qt 4.7 doesn't seem to expose the symbols we need to use FTS"
RDEPEND="${COMMON_DEPEND}
	mtp? ( gnome-base/gvfs )
	projectm? ( >=media-libs/libprojectm-1.2.0 )
	gstreamer? ( ${GST_RDEPEND} )
	!phonon? ( !vlc? ( !xine? ( ${GST_RDEPEND} ) ) )
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.39
	dev-util/pkgconfig
	sys-devel/gettext
	x11-libs/qt-test:4
"
DOCS="Changelog TODO"

MAKEOPTS="${MAKEOPTS} -j1"

pkg_setup() {
	if use phonon || use vlc || use xine; then
		ewarn "Only GStreamer engine is officially supported."
		ewarn "Other engines are unstable and lacking features."
	fi
}

src_configure() {
	# linguas
	local langs x
	for x in ${LANGS}; do
		use linguas_${x} && langs+=" ${x}"
	done

	mycmakeargs=(
		-DLINGUAS="${langs}"
		-DBUNDLE_PROJECTM_PRESETS=OFF
		$(cmake-utils_use ipod ENABLE_LIBGPOD)
		$(cmake-utils_use iphone ENABLE_IMOBILEDEVICE)
		$(cmake-utils_use lastfm ENABLE_LIBLASTFM)
		$(cmake-utils_use mtp ENABLE_LIBMTP)
		-DENABLE_GIO=ON
		$(cmake-utils_use wiimote ENABLE_WIIMOTEDEV)
		$(cmake-utils_use projectm ENABLE_VISUALISATIONS)
		$(cmake-utils_use ayatana ENABLE_SOUNDMENU)
		-DSTATIC_SQLITE=OFF
		$(cmake-utils_use gstreamer ENGINE_GSTREAMER_ENABLED)
		$(cmake-utils_use phonon ENGINE_QT_PHONON_ENABLED)
		$(cmake-utils_use vlc ENGINE_LIBVLC_ENABLED)
		$(cmake-utils_use xine ENGINE_LIBXINE_ENABLED)
		)

	if use !phonon && use !vlc && use !xine; then
		mycmakeargs+=(
			-DENGINE_GSTREAMER_ENABLED=ON
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
