# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-sound/qsampler/qsampler-0.2.2.ebuild,v 1.1 2009/12/04 19:01:06 aballier Exp $

EAPI=4
inherit autotools eutils qt4-r2 subversion

DESCRIPTION="A graphical frontend to the LinuxSampler engine"
HOMEPAGE="http://qsampler.sourceforge.net"
ESVN_REPO_URI="https://svn.linuxsampler.org/svn/qsampler/trunk"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug +libgig"

DEPEND="media-libs/alsa-lib
	>=media-libs/liblscp-0.5.5
	x11-libs/libX11
	dev-qt/qtcore:4
	dev-qt/qtgui:4
	libgig? ( >=media-libs/libgig-3.2.1 )"
RDEPEND="${DEPEND}
	>=media-sound/linuxsampler-0.5"

src_prepare() {
	epatch "${FILESDIR}"/${P}-build.patch
	eautoreconf
}

src_configure() {
	econf $(use_enable debug) \
		$(use_enable libgig)
}

src_install() {
	emake DESTDIR="${D}" install
	dodoc AUTHORS ChangeLog README TODO
	doman debian/${PN}.1
}
