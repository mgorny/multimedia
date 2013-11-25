# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

EGIT_REPO_URI="https://github.com/silicontrip/lavtools.git"

inherit toolchain-funcs eutils
[[ ${PV} == *9999* ]] && inherit git-r3

DESCRIPTION="Video player based on MPlayer/mplayer2"
HOMEPAGE="http://silicontrip.net/~mark/lavtools https://github.com/silicontrip/lavtools"
[[ ${PV} == *9999* ]] || \
SRC_URI="https://rion-overlay.googlecode.com/files/${P}.tar.xz"

LICENSE="GPL-2"
SLOT="0"
[[ ${PV} == *9999* ]] || \
KEYWORDS="~amd64 ~x86"
LAV_TOOLS="+libav-bitrate yuv2jpeg yuvaddetect yuvadjust yuvaifps yuvbilateral yuvconvolve yuvcrop yuvdiag yuvdiff yuvfade yuvfieldrev yuvfieldseperate yuvhsync yuvilace yuvmdeinterlace yuvnlmeans yuvopencv yuvpixelgraph yuvrfps yuvsubtitle yuvtbilateral yuvtout yuvtshot yuvvalues yuvwater yuvyadif"
IUSE="${LAV_TOOLS} +gnuplot"
REQUIRED_USE="
	|| ( ${LAV_TOOLS//+/} )
	gnuplot? ( libav-bitrate )
"

DEPEND="
	libav-bitrate? ( virtual/ffmpeg )
	yuv2jpeg? ( media-video/mjpegtools virtual/jpeg )
	yuvaddetect? ( media-video/mjpegtools )
	yuvadjust? ( media-video/mjpegtools )
	yuvaifps? ( media-video/mjpegtools )
	yuvbilateral? ( media-video/mjpegtools )
	yuvconvolve? ( media-video/mjpegtools )
	yuvcrop? ( media-video/mjpegtools )
	yuvdiag? ( media-video/mjpegtools media-libs/freetype:2 )
	yuvdiff? ( media-video/mjpegtools )
	yuvfade? ( media-video/mjpegtools )
	yuvfieldrev? ( media-video/mjpegtools )
	yuvfieldseperate? ( media-video/mjpegtools )
	yuvhsync? ( media-video/mjpegtools )
	yuvilace? ( media-video/mjpegtools sci-libs/fftw:3.0 )
	yuvmdeinterlace? ( media-video/mjpegtools )
	yuvnlmeans? ( media-video/mjpegtools )
	yuvopencv? ( media-video/mjpegtools media-libs/opencv )
	yuvpixelgraph? ( media-video/mjpegtools )
	yuvrfps? ( media-video/mjpegtools )
	yuvsubtitle? ( media-video/mjpegtools media-libs/freetype:2 )
	yuvtbilateral? ( media-video/mjpegtools )
	yuvtout? ( media-video/mjpegtools )
	yuvtshot? ( media-video/mjpegtools )
	yuvvalues? ( media-video/mjpegtools )
	yuvwater? ( media-video/mjpegtools )
	yuvyadif? ( media-video/mjpegtools )
"
RDEPEND="${DEPEND}
	gnuplot? ( sci-visualization/gnuplot[qt4] app-shells/bash )
"

src_prepare() {
	epatch_user
}

src_configure() {
	tc-export CC CXX
}

src_compile() {
	local i
	targets=''
	for i in ${LAV_TOOLS//+/}; do
		use ${i} && targets+=" ${i}"
	done
	emake ${targets}
}

src_install() {
	dobin ${targets}
	use gnuplot && dobin plot-bitrate
}
