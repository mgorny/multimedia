# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

WX_GTK_VER="2.9"

LANGS=" ca cs da de el es fi fr hu it ja ko pt_BR ru vi zh_CN zh_TW"

inherit autotools eutils wxwidgets flag-o-matic subversion

DESCRIPTION="Advanced SSA/ASS subtitle editor"
HOMEPAGE="http://www.aegisub.net/"
ESVN_REPO_URI="http://svn.aegisub.org/trunk/aegisub/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="alsa debug +ffmpeg lua nls openal oss portaudio pulseaudio spell"
IUSE+="${LANGS// / linguas_}"

RDEPEND="
	x11-libs/wxGTK:${WX_GTK_VER}[X,opengl,debug?]
	>=media-libs/libass-0.9.7[fontconfig]
	>=media-libs/fontconfig-2.4.2
	media-libs/freetype:2

	alsa? ( media-libs/alsa-lib )
	portaudio? ( =media-libs/portaudio-19* )
	pulseaudio? ( media-sound/pulseaudio )
	openal? ( media-libs/openal )

	lua? ( >=dev-lang/lua-5.1.1 )

	spell? ( >=app-text/hunspell-1.2 )
	ffmpeg? ( virtual/ffmpeg )
"
DEPEND="${RDEPEND}
	dev-util/intltool
	virtual/pkgconfig
	media-gfx/imagemagick
"

pkg_setup() {
	# until fixed UPSTREAM
	filter-flags -Wl,--as-needed
	filter-ldflags --as-needed
	filter-ldflags -Wl,--as-needed
}

src_prepare() {
	subversion_wc_info
	echo "${ESVN_WC_REVISION}" > svn_revision

	# linguas
	for x in ${LANGS}; do
		if use !linguas_${x}; then
			sed -e "s/^\t${x/fr/fr_FR}.po/\t/" -i po/Makefile || die
		fi
	done

	eautoreconf
}

src_configure() {
	econf \
		--prefix="${D}/usr" \
		--with-external-libass \
		$(use_with alsa) \
		$(use_with oss) \
		$(use_with portaudio) \
		$(use_with pulseaudio) \
		$(use_with openal) \
		$(use_with lua) \
		$(use ffmpeg || echo "--without-ffmpeg") \
		$(use_with spell hunspell) \
		$(use_enable debug) \
		$(use_enable nls)
}

src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"
}
