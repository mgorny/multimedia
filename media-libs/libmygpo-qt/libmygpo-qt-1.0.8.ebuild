# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit cmake-utils

DESCRIPTION="Qt/C++ library wrapping the gpodder.net webservice"
HOMEPAGE="http://wiki.gpodder.org/wiki/Libmygpo-qt"

if [[ ${PV} == *9999* ]]; then
	EGIT_REPO_URI="https://github.com/gpodder/libmygpo-qt.git"
	KEYWORDS=""
	SRC_URI=""
	inherit git-2
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/gpodder/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
fi

LICENSE="LGPL-2.1"
SLOT="0"
IUSE="qt4 +qt5 test"

RDEPEND="
	qt4? ( dev-qt/qtcore:4
		>=dev-libs/qjson-0.5[qt4] )
	qt5? ( >=dev-qt/qtcore-5.1:5
		>=dev-qt/qtgui-5.1:5
		>=dev-qt/qtnetwork-5.1:5
		>=dev-libs/qjson-0.5[qt5] )
	"

DEPEND="${RDEPEND}
	qt4? ( test? ( dev-qt/qttest:4 ) )
	qt5? ( test? ( dev-qt/qttest:5 ) )
	virtual/pkgconfig
	"

DOCS=( AUTHORS README )

src_prepare() {
	cmake-utils_src_prepare
	if ! use test ; then
		sed -i -e '/find_package/s/QtTest//' CMakeLists.txt || die
	fi

src_prepare() {
	epatch "${FILESDIR}"/${PN}-correct-package-name.patch
}

	# If qtchooser is installed, it may break the build, because moc,rcc and uic binaries for wrong qt version may be used.
	# Setting QT_SELECT environment variable will enforce correct binaries.
	if use qt4; then
		export QT_SELECT=qt4
	elif use qt5; then
		export QT_SELECT=qt5
		ewarn "Please note that Qt5 support is still experimental."
		ewarn "If you find anything to not work with Qt5, please report a bug."
	fi
}

src_configure() {
	local qt_flag=""
	if use qt5 ; then
		qt_flag="-DBUILD_WITH_QT4=OFF"
	fi
	local mycmakeargs=(
		$(cmake-utils_use test MYGPO_BUILD_TESTS)
		${qt_flag}
	)

	use qt5 && append-cppflags -DBUILD_WITH_QT4=OFF

	cmake-utils_src_configure
}

src_test() {
	cd "${CMAKE_BUILD_DIR}" || die
	Xemake test
}
