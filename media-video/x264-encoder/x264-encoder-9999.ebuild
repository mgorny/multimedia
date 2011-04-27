# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=2

V_ECLASS=""
if [ "${PV#9999}" != "${PV}" ] ; then
	V_ECLASS="git"
else
	V_ECLASS="versionator"
fi

inherit eutils multilib toolchain-funcs ${V_ECLASS}

if [ "${PV#9999}" = "${PV}" ] ; then
	MY_P="x264-snapshot-$(get_version_component_range 3)-2245"
fi
DESCRIPTION="A free commandline encoder for X264/AVC streams"
HOMEPAGE="http://www.videolan.org/developers/x264.html"
if [ "${PV#9999}" != "${PV}" ] ; then
	EGIT_REPO_URI="git://git.videolan.org/x264.git"
	EGIT_PROJECT="x264"
else
	SRC_URI="http://ftp.videolan.org/pub/videolan/x264/snapshots/${MY_P}.tar.bz2"
fi

LICENSE="GPL-2"
SLOT="0"
if [ "${PV#9999}" = "${PV}" ] ; then
	KEYWORDS="~alpha ~amd64 ~ppc ~ppc64 ~sparc ~x86 ~x86-fbsd"
fi
IUSE="debug ffmpeg mp4 static +threads -visualize"

RDEPEND="
	mp4? ( >=media-video/gpac-0.4.1_pre20060122 )
	!static? ( ~media-libs/x264-${PV} )
	ffmpeg? ( media-video/ffmpeg )
"
ASM_DEP=">=dev-lang/yasm-0.6.2"
DEPEND="${RDEPEND}
	amd64? ( ${ASM_DEP} )
	x86? ( || ( ${ASM_DEP} dev-lang/nasm )
		!<dev-lang/yasm-0.6.2 )
	x86-fbsd? ( ${ASM_DEP} )
	dev-util/pkgconfig
"
if [ "${PV#9999}" = "${PV}" ] ; then
	S=${WORKDIR}/${MY_P}
fi

src_prepare() {
	epatch "${FILESDIR}"/${PN}-nostrip.patch

	if use static; then
		epatch "${FILESDIR}/${PN}-nolib-static-20110228.patch"
	else
		epatch "${FILESDIR}/${PN}-nolib-20110228.patch"
	fi
}

src_configure() {
	tc-export CC

	local myconf=""
	use debug && myconf+=" --enable-debug"

	./configure \
		--prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		--disable-avs \
		--disable-ffms \
		$(use_enable ffmpeg lavf) \
		$(use_enable ffmpeg swscale) \
		$(use_enable mp4 gpac) \
		$(use_enable threads thread) \
		$(use_enable visualize) \
		--extra-asflags="${ASFLAGS}" \
		--extra-cflags="${CFLAGS}" \
		--extra-ldflags="${LDFLAGS}" \
		--host="${CHOST}" \
		${myconf} \
		|| die
}

src_install() {
	emake DESTDIR="${D}" install || die
}
