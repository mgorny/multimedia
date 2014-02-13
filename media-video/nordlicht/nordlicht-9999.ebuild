# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="https://github.com/blinry/nordlicht.git"

inherit cmake-utils
[[ ${PV} == *9999* ]] && inherit git-r3

DESCRIPTION="library + tool that creates colorful video barcodes"
HOMEPAGE="https://github.com/blinry/nordlicht"
[[ ${PV} == *9999* ]] || \
SRC_URI="https://github.com/blinry/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
[[ ${PV} == *9999* ]] || \
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/ffmpeg
	media-libs/freeimage
"
DEPEND="${RDEPEND}"
