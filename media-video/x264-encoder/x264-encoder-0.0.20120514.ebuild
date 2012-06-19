# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-video/x264-encoder/x264-encoder-9999.ebuild,v 1.4 2012/05/05 08:58:56 jdhore Exp $

EAPI=4

if [ "${PV#9999}" != "${PV}" ]; then
	V_ECLASS="git-2"
else
	V_ECLASS=""
fi

inherit multilib toolchain-funcs ${V_ECLASS}

if [ "${PV#9999}" = "${PV}" ]; then
	MY_P="x264-${PV}"
fi
DESCRIPTION="A free commandline encoder for X264/AVC streams"
HOMEPAGE="http://www.videolan.org/developers/x264.html"
if [ "${PV#9999}" != "${PV}" ]; then
	EGIT_REPO_URI="git://git.videolan.org/x264.git"
	SRC_URI=""
else
	SRC_URI="http://rion-overlay.googlecode.com/files/${MY_P}.tar.xz"
fi

LICENSE="GPL-2"
SLOT="0"
if [ "${PV#9999}" != "${PV}" ]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
fi
IUSE="10bit debug ffmpeg ffmpegsource +interlaced mp4 pic +system-libx264 +threads"

REQUIRED_USE="ffmpegsource? ( ffmpeg )"

RDEPEND="
	ffmpeg? ( virtual/ffmpeg )
	ffmpegsource? ( media-libs/ffmpegsource )
	mp4? ( >=media-video/gpac-0.4.1_pre20060122 )
	system-libx264? ( ~media-libs/x264-${PV}[10bit=,interlaced=] )
"
ASM_DEP=">=dev-lang/yasm-1"
DEPEND="${RDEPEND}
	amd64? ( ${ASM_DEP} )
	x86? ( ${ASM_DEP} )
	x86-fbsd? ( ${ASM_DEP} )
	virtual/pkgconfig
"
if [ "${PV#9999}" = "${PV}" ]; then
	S="${WORKDIR}/${MY_P}"
fi

src_configure() {
	tc-export CC

	local myconf=""
	use 10bit && myconf+=" --bit-depth=10"
	use debug && myconf+=" --enable-debug"
	use ffmpeg || myconf+=" --disable-lavf --disable-swscale"
	use ffmpegsource || myconf+=" --disable-ffms"
	use interlaced || myconf+=" --disable-interlaced"
	use mp4 || myconf+=" --disable-gpac"
	use system-libx264 && myconf+=" --system-libx264"
	use threads || myconf+=" --disable-thread"

	if use x86 && use pic; then
		myconf+=" --disable-asm"
	fi

	./configure \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--disable-avs \
		--enable-pic \
		--host="${CHOST}" \
		${myconf} || die
}
