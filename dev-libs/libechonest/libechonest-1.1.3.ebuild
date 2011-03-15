# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

inherit cmake-utils

DESCRIPTION="Qt library for communicating with The Echo Nest"
HOMEPAGE="https://projects.kde.org/projects/playground/libs/libechonest"
SRC_URI="http://pwsp.cleinias.com/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
RESTRICT="test" # needs network

RDEPEND="
	>=x11-libs/qt-core-4.6:4
	>=dev-libs/qjson-0.5
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
"
DOCS="AUTHORS README TODO"
