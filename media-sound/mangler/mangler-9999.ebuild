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
IUSE="alsa celt gsm mpd nowplaying pulseaudio speex xosd"

RDEPEND="dev-cpp/gtkmm:2.4
	gnome-base/librsvg
	speex? ( media-libs/speex )
	gsm? ( media-sound/gsm )
	celt? ( >=media-libs/celt-0.7.1 )
	alsa? ( media-libs/alsa-lib )
	pulseaudio? ( media-sound/pulseaudio )
	mpd? ( media-libs/libmpdclient )
	nowplaying? ( >=dev-libs/dbus-glib-0.80 )
	xosd? ( x11-libs/xosd )"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
	>=sys-devel/autoconf-2.65"

src_prepare() {
	eautoreconf
}

src_configure() {
	econf $(use_with alsa) \
		$(use_with pulseaudio) \
		$(use_enable celt) \
		$(use_enable gsm) \
		$(use_enable speex) \
		$(use_enable xosd)
}

src_install() {
	emake DESTDIR="${D}" install || die
}
