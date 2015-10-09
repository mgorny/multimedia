# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

LANGS=" af ar be bg bn br bs ca cs cy da de el en_CA en_GB eo es es_AR et eu fa fi fr ga gl he hi hr hu hy ia id is it ja ka kk ko lt lv mr ms nb nl oc pa pl pt pt_BR ro ru sk sl sr sr@latin sv te tr uk uz vi zh_CN zh_TW"

EGIT_REPO_URI="https://github.com/clementine-player/Clementine.git"

inherit cmake-utils flag-o-matic fdo-mime gnome2-utils virtualx git-r3

DESCRIPTION="A modern music player and library organizer based on Amarok 1.4 and Qt4"
HOMEPAGE="http://www.clementine-player.org https://github.com/clementine-player/Clementine"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="ayatana box cdda +dbus debug dropbox googledrive ipod lastfm mms moodbar mtp projectm skydrive +qt4 qt5 system-sqlite test ubuntu-one +udisks wiimote"
IUSE+="${LANGS// / linguas_}"

REQUIRED_USE="
	^^ ( qt4 qt5 )
	udisks? ( dbus )
	wiimote? ( dbus )
"

# qca dep is temporary for bug #489850
COMMON_DEPEND="
	qt4? ( >=dev-qt/qtcore-4.5:4
		>=dev-qt/qtgui-4.5:4
		>=dev-qt/qtopengl-4.5:4
		>=dev-qt/qtsql-4.5:4[sqlite]
		app-crypt/qca:2[qt4(+)]
		>=dev-libs/qjson-0.5[qt4]
		>=media-libs/libmygpo-qt-1.0.7[qt4]
		media-libs/libechonest[qt4]
		dbus? ( >=dev-qt/qtdbus-4.5:4 ) )
	qt5? ( >=dev-qt/qtcore-5.1:5
		>=dev-qt/qtgui-5.1:5
		>=dev-qt/qtnetwork-5.1:5
		>=dev-qt/qtopengl-5.1:5
		>=dev-qt/qttranslations-5.1:5
		>=dev-qt/qtsql-5.1:5[sqlite]
		>=dev-qt/qtwidgets-5.1:5
		>=dev-qt/qtx11extras-5.1:5
		>=dev-qt/qtxml-5.1:5
		>=dev-qt/linguist-tools-5.1:5
		app-crypt/qca:2[qt5(+)]
		>=dev-libs/qjson-0.5[qt5]
		>=media-libs/libmygpo-qt-1.0.8[qt5]
		>=media-libs/libechonest-2.3.0[qt5]
		dbus? ( >=dev-qt/qtdbus-5.1:5 ) )

	dev-libs/crypto++
	>=dev-libs/glib-2.24.1-r1
	dev-libs/libspotify
	dev-libs/libxml2
	dev-libs/protobuf:=
	dev-libs/qjson
	>=media-libs/chromaprint-0.6
	media-libs/gst-plugins-base:0.10
	media-libs/gstreamer:0.10
	>=media-libs/taglib-1.8[mp4]
	virtual/glu
	virtual/opengl
	ayatana? ( dev-libs/libindicate-qt )
	cdda? ( dev-libs/libcdio )
	ipod? ( >=media-libs/libgpod-0.8.0 )
	lastfm? ( >=media-libs/liblastfm-1 )
	moodbar? ( sci-libs/fftw:3.0 )
	mtp? ( >=media-libs/libmtp-1.0.0 )
	projectm? ( media-libs/glew )
	system-sqlite? ( dev-db/sqlite[fts3(+)] )
"
# now only presets are used, libprojectm is internal
# https://github.com/clementine-player/Clementine/tree/master/3rdparty/libprojectm/patches
# r1966 "Compile with a static sqlite by default, since Qt 4.7 doesn't seem to expose the symbols we need to use FTS"
RDEPEND="${COMMON_DEPEND}
	dbus? ( udisks? ( sys-fs/udisks:0 ) )
	mms? ( media-plugins/gst-plugins-libmms:0.10 )
	mtp? ( gnome-base/gvfs )
	projectm? ( >=media-libs/libprojectm-1.2.0 )
	media-plugins/gst-plugins-meta:0.10
	media-plugins/gst-plugins-gio:0.10
	media-plugins/gst-plugins-soup:0.10
	media-plugins/gst-plugins-taglib:0.10
"
DEPEND="${COMMON_DEPEND}
	>=dev-libs/boost-1.39
	virtual/pkgconfig
	sys-devel/gettext
	qt4? ( test? ( dev-qt/qttest:4 ) )
	qt5? ( test? ( dev-qt/qttest:5 ) )
	dev-cpp/gmock
	box? ( dev-cpp/sparsehash )
	dropbox? ( dev-cpp/sparsehash )
	googledrive? ( dev-cpp/sparsehash )
	skydrive? ( dev-cpp/sparsehash )
	ubuntu-one? ( dev-cpp/sparsehash )
	test? ( gnome-base/gsettings-desktop-schemas )
"

DOCS="Changelog"

# https://github.com/clementine-player/Clementine/issues/3935
RESTRICT="test"

# [[ ${PV} == *9999* ]] || \
# S="${WORKDIR}/${P^}"

src_unpack() {
	if use qt5; then
		EGIT_BRANCH="qt5"
	fi

	git-r3_src_unpack
}

src_prepare() {
	cmake-utils_src_prepare

	# some tests fail or hang
	sed -i \
		-e '/add_test_file(translations_test.cpp/d' \
		tests/CMakeLists.txt || die
	# If qtchooser is installed, it may break the build, because moc,rcc and uic binaries for wrong qt version may be used.
	# Setting QT_SELECT environment variable will enforce correct binaries.
	if use qt4; then
		export QT_SELECT=qt4
	elif use qt5; then
		export QT_SELECT=qt5
		ewarn "Please note that Qt5 support is still experimental."
		ewarn "If you find anything to not work with Qt5, please report a bug."
		ewarn "«Work (slowly) in progress.»© https://github.com/clementine-player/Clementine/issues/3463#issuecomment-90714420"
	fi
}

src_configure() {
	local langs x
	for x in ${LANGS}; do
		use linguas_${x} && langs+=" ${x}"
	done

	# spotify is not in portage
	local mycmakeargs=(
		-DBUILD_WERROR=OFF
		-DLINGUAS="${langs}"
		-DBUNDLE_PROJECTM_PRESETS=OFF
		$(cmake-utils_use cdda ENABLE_AUDIOCD)
		$(cmake-utils_use dbus ENABLE_DBUS)
		$(cmake-utils_use udisks ENABLE_DEVICEKIT)
		$(cmake-utils_use ipod ENABLE_LIBGPOD)
		$(cmake-utils_use lastfm ENABLE_LIBLASTFM)
		$(cmake-utils_use mtp ENABLE_LIBMTP)
		$(cmake-utils_use moodbar ENABLE_MOODBAR)
		-DENABLE_GIO=ON
		$(cmake-utils_use wiimote ENABLE_WIIMOTEDEV)
		$(cmake-utils_use projectm ENABLE_VISUALISATIONS)
		$(cmake-utils_use ayatana ENABLE_SOUNDMENU)
		$(cmake-utils_use box ENABLE_BOX)
		$(cmake-utils_use dropbox ENABLE_DROPBOX)
		$(cmake-utils_use googledrive ENABLE_GOOGLE_DRIVE)
		$(cmake-utils_use skydrive ENABLE_SKYDRIVE)
		$(cmake-utils_use ubuntu-one ENABLE_UBUNTU_ONE)
		-DENABLE_SPOTIFY_BLOB=OFF
		-DENABLE_BREAKPAD=OFF
		$(cmake-utils_use !system-sqlite STATIC_SQLITE)
		$(cmake-utils_use system-sqlite I_HATE_MY_USERS)
		$(cmake-utils_use system-sqlite MY_USERS_WILL_SUFFER_BECAUSE_OF_ME)
		-DUSE_BUILTIN_TAGLIB=OFF
		-DUSE_SYSTEM_GMOCK=ON
		# force to find crypto++ see bug #548544
		-DCRYPTOPP_LIBRARIES="crypto++"
		-DCRYPTOPP_FOUND=ON
		)

	use !debug && append-cppflags -DQT_NO_DEBUG_OUTPUT

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
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}

pkg_postrm() {
	fdo-mime_desktop_database_update
	gnome2_icon_cache_update
}
