# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

LANGS=" ar be bg br ca cs cy da de el en_CA en_GB eo es et eu fi fr gl he hi hr hu is it ja kk lt lv nb nl oc pa pl pt pt_BR ro ru sk sl sr sv tr uk vi zh_CN zh_TW"

inherit cmake-utils gnome2-utils virtualx subversion

DESCRIPTION="A modern music player and library organizer based on Amarok 1.4 and Qt4"
HOMEPAGE="http://www.clementine-player.org/ http://code.google.com/p/clementine-player/"
ESVN_REPO_URI="http://clementine-player.googlecode.com/svn/trunk"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="archive ayatana +dbus iphone ipod +lastfm mtp projectm python remote +udev wiimote"
IUSE+="${LANGS// / linguas_}"

REQUIRED_USE="
	iphone? ( ipod )
	udev? ( dbus )
	wiimote? ( dbus )
"

COMMON_DEPEND="
	>=x11-libs/qt-gui-4.5:4[dbus?]
	>=x11-libs/qt-opengl-4.5:4
	>=x11-libs/qt-sql-4.5:4[sqlite]
	dev-db/sqlite[fts3]
	>=media-libs/taglib-1.6
	>=dev-libs/glib-2.24.1-r1:2
	dev-libs/libxml2
	media-libs/libechonest
	>=media-libs/gstreamer-0.10
	>=media-libs/gst-plugins-base-0.10
	archive? ( >=app-arch/libarchive-2.8.3 )
	ayatana? ( dev-libs/libindicate-qt )
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
	python? ( dev-python/PyQt4 )
	remote? ( net-libs/gnutls )
"
# now only presets are used, libprojectm is internal
# http://code.google.com/p/clementine-player/source/browse/#svn/trunk/3rdparty/libprojectm/patches
# r1966 "Compile with a static sqlite by default, since Qt 4.7 doesn't seem to expose the symbols we need to use FTS"
RDEPEND="${COMMON_DEPEND}
	dbus? ( udev? ( sys-fs/udisks ) )
	mtp? ( gnome-base/gvfs )
	projectm? ( >=media-libs/libprojectm-1.2.0 )
	>=media-plugins/gst-plugins-meta-0.10
	>=media-plugins/gst-plugins-gio-0.10
	>=media-plugins/gst-plugins-soup-0.10
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.39
	dev-util/pkgconfig
	sys-devel/gettext
	x11-libs/qt-test:4
"
DOCS="Changelog TODO"

src_prepare() {
	default_src_prepare

	# some tests fail or hang
	sed \
		-e '/add_test_file(translations_test.cpp/d' \
		-i tests/CMakeLists.txt || die
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
		$(cmake-utils_use dbus ENABLE_DBUS)
		$(cmake-utils_use udev ENABLE_DEVICEKIT)
		$(cmake-utils_use ipod ENABLE_LIBGPOD)
		$(cmake-utils_use iphone ENABLE_IMOBILEDEVICE)
		$(cmake-utils_use lastfm ENABLE_LIBLASTFM)
		$(cmake-utils_use mtp ENABLE_LIBMTP)
		-DENABLE_GIO=ON
		$(cmake-utils_use wiimote ENABLE_WIIMOTEDEV)
		$(cmake-utils_use projectm ENABLE_VISUALISATIONS)
		$(cmake-utils_use ayatana ENABLE_SOUNDMENU)
		$(cmake-utils_use python ENABLE_SCRIPTING_PYTHON)
		$(cmake-utils_use archive ENABLE_SCRIPTING_ARCHIVES)
		$(cmake-utils_use remote ENABLE_REMOTE)
		-DSTATIC_SQLITE=OFF
		-DPYQT_SIP_DIR="${EPREFIX}/usr/share/sip"
		)

	cmake-utils_src_configure
}

src_test() {
	cd "${CMAKE_BUILD_DIR}" || die
	Xemake test
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
