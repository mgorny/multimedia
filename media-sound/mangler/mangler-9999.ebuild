# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
inherit autotools subversion

ESVN_REPO_URI="http://svn.mangler.org/mangler/trunk"
DESCRIPTION="Open source VOIP client capable of connecting to Ventrilo 3.x servers"
HOMEPAGE="http://www.mangler.org/"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="alsa pulseaudio"

RDEPEND="dev-cpp/gtkmm:2.4
	gnome-base/librsvg
	media-libs/speex
	media-sound/gsm
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-devel/autoconf-2.65"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf $(use_with alsa) $(use_with pulseaudio)
}

src_install() {
	emake DESTDIR="${D}" install || die
}
