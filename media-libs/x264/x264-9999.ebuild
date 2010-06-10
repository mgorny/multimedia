# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"

inherit eutils multilib toolchain-funcs git

DESCRIPTION="A free library for encoding X264/AVC streams"
HOMEPAGE="http://www.videolan.org/developers/x264.html"
EGIT_REPO_URI="git://git.videolan.org/x264.git"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="debug +threads pic"

RDEPEND=""
ASM_DEP=">=dev-lang/yasm-0.6.2"
DEPEND="amd64? ( ${ASM_DEP} )
	x86? ( ${ASM_DEP} )
	x86-fbsd? ( ${ASM_DEP} )"

src_prepare() {
	epatch "${FILESDIR}/${PN}-nostrip.patch" \
		"${FILESDIR}/${PN}-onlylib-20100605.patch"
}

src_configure() {
	tc-export CC

	local myconf=""
	use debug && myconf+=" --enable-debug"

	if use x86 && use pic; then
		myconf+=" --disable-asm"
	fi

	./configure \
		--prefix=/usr \
		--libdir=/usr/$(get_libdir) \
		--disable-avs \
		--disable-lavf \
		--disable-ffms \
		--disable-gpac \
		$(use_enable threads pthread) \
		--enable-pic \
		--enable-shared \
		--extra-asflags="${ASFLAGS}" \
		--extra-cflags="${CFLAGS}" \
		--extra-ldflags="${LDFLAGS}" \
		--host="${CHOST}" \
		${myconf} || die
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS doc/*.txt
}
