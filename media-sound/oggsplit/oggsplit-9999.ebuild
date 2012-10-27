# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit base subversion

DESCRIPTION="Tool for splitting multiplexed Ogg files into separate streams"
HOMEPAGE="http://svn.xiph.org/trunk/ogg-tools/oggsplit/"
ESVN_REPO_URI="http://svn.xiph.org/trunk/ogg-tools/oggsplit/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="media-libs/libogg"
RDEPEND="${DEPEND}"

ESVN_BOOTSTRAP="autogen.sh"
DOCS=( AUTHORS README )
