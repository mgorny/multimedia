# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit base qt4-r2

MY_PN="tsMuxeR"
DESCRIPTION="TS/M2TS/BD video muxer/demuxer"
HOMEPAGE="http://www.smlabs.net/tsmuxer_en.html"
SRC_URI="http://www.smlabs.net/tsMuxer/${MY_PN}_shared_${PV}.tar.gz"

LICENSE="SMLABS-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="qt4"

DEPEND=">=app-arch/upx-3.01"
RDEPEND="
	x86? (
		sys-libs/zlib
		media-libs/freetype:2
		qt4? ( x11-libs/qt-gui:4 )
	)
	amd64? (
		app-emulation/emul-linux-x86-baselibs
		app-emulation/emul-linux-x86-xlibs
		>=app-emulation/emul-linux-x86-qtlibs-20081109
	)"
# cli is linked to freetype, when it will be fixed
# we will remove app-emulation/emul-linux-x86-xlibs dep.

S="${WORKDIR}"
RESTRICT="mirror"

src_prepare() {
	upx -d "${MY_PN}" || die
	if use qt4; then
		upx -d tsMuxerGUI || die
	fi
}

src_install() {
	into /opt
	dobin "${MY_PN}"
	dosym "${MY_PN}" /opt/bin/${PN}

	if use qt4; then
		dobin tsMuxerGUI
		dosym tsMuxerGUI /opt/bin/${PN}-gui

		make_desktop_entry tsMuxerGUI "${MY_PN}" ${PN} "Qt;AudioVideo;Video"
	fi

	dodoc readme.rus.txt
}
