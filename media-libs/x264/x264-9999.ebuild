# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

if [ "${PV#9999}" != "${PV}" ]; then
	V_ECLASS="git-2"
else
	V_ECLASS=""
fi

inherit flag-o-matic multilib toolchain-funcs ${V_ECLASS}

DESCRIPTION="A free library for encoding X264/AVC streams"
HOMEPAGE="http://www.videolan.org/developers/x264.html"
if [ "${PV#9999}" != "${PV}" ]; then
	EGIT_REPO_URI="git://git.videolan.org/x264.git"
	SRC_URI=""
else
	SRC_URI="http://rion-overlay.googlecode.com/files/${P}.tar.xz"
fi

LICENSE="GPL-2"
SLOT="0/129"
if [ "${PV#9999}" != "${PV}" ]; then
	KEYWORDS=""
else
	KEYWORDS="~alpha ~amd64 ~hppa ~mips ~ppc ~ppc64 ~sparc ~x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
fi
IUSE="10bit debug +interlaced pic static-libs +threads"

RDEPEND=""
ASM_DEP=">=dev-lang/yasm-1.2.0"
DEPEND="
	amd64? ( ${ASM_DEP} )
	x86? ( ${ASM_DEP} )
	x86-fbsd? ( ${ASM_DEP} )
"

DOCS="AUTHORS doc/*.txt"

src_configure() {
	tc-export CC

	# let upstream pick the optimization level
	filter-flags -O?

	local myconf=""
	use 10bit && myconf+=" --bit-depth=10"
	use debug && myconf+=" --enable-debug"
	use interlaced || myconf+=" --disable-interlaced"
	use static-libs && myconf+=" --enable-static"
	use threads || myconf+=" --disable-thread"

	if use x86 && use pic; then
		myconf+=" --disable-asm"
	fi

	./configure \
		--prefix="${EPREFIX}"/usr \
		--libdir="${EPREFIX}"/usr/$(get_libdir) \
		--disable-cli \
		--disable-avs \
		--disable-lavf \
		--disable-swscale \
		--disable-ffms \
		--disable-gpac \
		--enable-pic \
		--enable-shared \
		--host="${CHOST}" \
		${myconf} || die
}
