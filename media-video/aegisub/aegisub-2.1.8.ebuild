# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

WX_GTK_VER="2.8"
inherit autotools eutils wxwidgets

DESCRIPTION="Advanced SSA/ASS subtitle editor"
HOMEPAGE="http://www.aegisub.net/"
SRC_URI="http://ftp.aegisub.org/pub/archives/releases/source/${P}.tar.gz
		 http://ftp2.aegisub.org/pub/archives/releases/source/${P}.tar.gz
		 http://www.mahou.org/~verm/aegisub/${P}.tar.gz
		 http://www.mahou.org/~verm/aegisub/archives/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="alsa debug +ffmpeg lua nls openal oss portaudio pulseaudio spell"

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl]
	>=media-libs/libass-0.9.7[fontconfig]
	>=media-libs/fontconfig-2.4.2
	media-libs/freetype:2

	alsa? ( media-libs/alsa-lib )
	portaudio? ( =media-libs/portaudio-19* )
	pulseaudio? ( media-sound/pulseaudio )
	openal? ( media-libs/openal )

	lua? ( >=dev-lang/lua-5.1.1 )

	spell? ( >=app-text/hunspell-1.2 )
	ffmpeg? ( >=media-video/ffmpeg-0.5_p18642 !>media-video/ffmpeg-0.6_p25423 )
"
DEPEND="${RDEPEND}
	dev-util/intltool
	dev-util/pkgconfig
	media-gfx/imagemagick
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-do-not-verify-audiolibs.patch
	epatch "${FILESDIR}"/${P}-external-libass.patch

	eautoreconf
}

src_configure() {
	econf \
		--with-external-libass \
		$(use_with alsa) \
		$(use_with oss) \
		$(use_with portaudio) \
		$(use_with pulseaudio) \
		$(use_with openal) \
		$(use_with lua) \
		CXXFLAGS="$CXXFLAGS -D__STDC_CONSTANT_MACROS" \
		$(use ffmpeg || echo "--without-ffmpeg") \
		$(use_with spell hunspell) \
		$(use_enable debug) \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
