# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libbluray/libbluray-9999.ebuild,v 1.1 2010/07/17 02:55:14 beandog Exp $

EAPI=2

inherit autotools java-pkg-opt-2 git

EGIT_REPO_URI="git://git.videolan.org/libbluray.git"

DESCRIPTION="Blu-ray playback libraries"
HOMEPAGE="http://www.videolan.org/ http://git.videolan.org/?p=libbluray.git;a=summary"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""
IUSE="aacs java static-libs utils"

COMMON_DEPEND="
	dev-libs/libxml2
	java? ( virtual/jdk )
"
RDEPEND="${COMMON_DEPEND}
	aacs? ( media-video/aacskeys )
"
DEPEND="${COMMON_DEPEND}
	dev-util/pkgconfig
"

src_prepare() {
	use java && export JDK_HOME="$(java-config -g JAVA_HOME)"
	eautoreconf
}

src_configure() {
	local myconf=""
	use java && myconf="--with-jdk=${JDK_HOME}"

	econf \
		$(use_enable static-libs static) \
		$(use_enable utils static) \
		$(use_enable utils examples) \
		$myconf
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc doc/README README.txt TODO.txt || die

	if use utils; then
		cd src/examples/
		dobin clpi_dump index_dump mobj_dump mpls_dump sound_dump || die
		cd .libs/
		dobin bd_info bdsplice hdmv_test libbluray_test list_titles || die
	fi
}
