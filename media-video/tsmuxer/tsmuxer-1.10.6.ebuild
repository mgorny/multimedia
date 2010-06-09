# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
MY_PN="tsMuxeR"

inherit base qt4-r2

RESTRICT="mirror strip"

DESCRIPTION="TS/M2TS/BD video muxer/demuxer"
HOMEPAGE="http://www.smlabs.net/tsmuxer_en.html"
SRC_URI="http://www.smlabs.net/tsMuxer/${MY_PN}_shared_${PV}.tar.gz"

LICENSE="SMLABS-EULA"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-arch/upx"
RDEPEND="x11-libs/qt-core:4
	x11-libs/qt-gui:4
	amd64? ( >=app-emulation/emul-linux-x86-qtlibs-20081109 )"

S="${WORKDIR}"

src_prepare() {
	upx -d ${MY_PN} tsMuxerGUI || die
}


src_install() {
	into /opt
	dobin ${MY_PN}
	dobin tsMuxerGUI
	dodoc readme.rus.txt licence.txt
}
