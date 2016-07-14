#!/bin/bash
# simple bash script for generating dtb image

# root directory of universal3475 kernel git repo (default is this script's location)
RDIR=$(pwd)

# directory containing cross-compile arm toolchain
TOOLCHAIN=$HOME/build/toolchain/gcc-linaro-4.9-2016.02-x86_64_arm-linux-gnueabihf

# device dependant variables
PAGE_SIZE=2048
DTB_PADDING=0

export ARCH=arm
export CROSS_COMPILE=$TOOLCHAIN/bin/arm-linux-gnueabihf-

BDIR=$RDIR/build
OUTDIR=$BDIR/arch/$ARCH/boot
DTSDIR=$RDIR/arch/$ARCH/boot/dts
DTBDIR=$OUTDIR/dtb
DTCTOOL=$BDIR/scripts/dtc/dtc
INCDIR=$RDIR/include

ABORT()
{
	[ "$1" ] && echo "Error: $*"
	exit 1
}

[ -x "$DTCTOOL" ] ||
BORT "You need to run ./build.sh first!"

[ -x "${CROSS_COMPILE}gcc" ] ||
ABORT "Unable to find gcc cross-compiler at location: ${CROSS_COMPILE}gcc"

[ "$1" ] && DEVICE=$1
[ "$2" ] && VARIANT=$2

case $DEVICE in
gteslte)
	case $VARIANT in
	usa|att|tmo|mtr|can)
		DTSFILES="exynos3475-gteslte_usa_open_00 exynos3475-gteslte_usa_open_01
			exynos3475-gteslte_usa_open_02 exynos3475-gteslte_usa_open_05
			exynos3475-gteslte_usa_open_07 exynos3475-gteslte_usa_open_08"
		;;
	vzw)
		DTSFILES="exynos3475-gteslte_usa_vzw_00 exynos3475-gteslte_usa_vzw_01
			exynos3475-gteslte_usa_vzw_02 exynos3475-gteslte_usa_vzw_05"
		;;
	kor|skt|lgt|ktt)
		DTSFILES="exynos3475-gteslte_kor_open_05 exynos3475-gteslte_kor_open_07
			exynos3475-gteslte_kor_open_08"
		;;
	chn|tw|zc|zh)
		DTSFILES="exynos3475-gteslte_chn_tw_00 exynos3475-gteslte_chn_tw_01
			exynos3475-gteslte_chn_tw_02 exynos3475-gteslte_chn_tw_05
			exynos3475-gteslte_chn_tw_07 exynos3475-gteslte_chn_tw_08"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x50a6
	DTBH_SUBTYPE_CODE=0x217584da
	;;
gteswifi)
	case $VARIANT in
	usa|att|tmo|mtr|can)
		DTSFILES="exynos3475-gteswifi_usa_open_01 exynos3475-gteswifi_usa_open_02
			exynos3475-gteswifi_usa_open_05"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x50a6
	DTBH_SUBTYPE_CODE=0x217584da
	;;
j1xlte)
	case $VARIANT in
	eur|xx)
		DTSFILES="exynos3475-j1xlte_eur_open_00"
		;;
	aus|xsa)
		DTSFILES="exynos3475-j1xlte_aus_xsa_00"
		;;
	mea|jt)
		DTSFILES="exynos3475-j1xlte_mea_jt_00 exynos3475-j1xlte_mea_jt_02"
		;;
	usa|att|tmo|mtr|can)
		DTSFILES="exynos3475-j1xlte_att_jt_00 exynos3475-j1xlte_att_jt_02
			exynos3475-j1xlte_att_jt_03"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x50a6
	DTBH_SUBTYPE_CODE=0x217584da
	;;
j2lte)
	case $VARIANT in
	eur|xx)
		DTSFILES="exynos3475-j2lte_eur_open_00 exynos3475-j2lte_eur_open_01
			exynos3475-j2lte_eur_open_02 exynos3475-j2lte_eur_open_03"
		;;
	ltn|dtv)
		DTSFILES="exynos3475-j2lte_ltn_dtv_00 exynos3475-j2lte_ltn_dtv_01
			exynos3475-j2lte_ltn_dtv_02 exynos3475-j2lte_ltn_dtv_03
			exynos3475-j2lte_ltn_dtv_04"
		;;
	aus|xsa|sea)
		DTSFILES="exynos3475-j2lte_sea_xsa_00 exynos3475-j2lte_sea_xsa_01
			exynos3475-j2lte_sea_xsa_02 exynos3475-j2lte_sea_xsa_03"
		;;
	swa)
		DTSFILES="exynos3475-j2lte_swa_open_00 exynos3475-j2lte_swa_open_01
			exynos3475-j2lte_swa_open_02 exynos3475-j2lte_swa_open_03
			exynos3475-j2lte_swa_open_04"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x50a6
	DTBH_SUBTYPE_CODE=0x217584da
	;;
j3xlte)
	case $VARIANT in
	usa|att|tmo|mtr|can)
		DTSFILES="exynos3475-j3xlte_usa_att_00 exynos3475-j3xlte_usa_att_01
			exynos3475-j3xlte_usa_att_02 exynos3475-j3xlte_usa_att_03
			exynos3475-j3xlte_usa_att_04"
		;;
	kor|skt|lgt|ktt)
		DTSFILES="exynos3475-j3xlte_kor_open_00"
		;;
	ltn|b28)
		DTSFILES="exynos3475-j3xlte_ltn_b28_00"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x50a6
	DTBH_SUBTYPE_CODE=0x217584da
	;;
novel3g)
	case $VARIANT in
	kor|skt|lgt|ktt)
		DTSFILES="exynos3475-novel3g_kor_skt_00 exynos3475-novel3g_kor_skt_01
			exynos3475-novel3g_kor_skt_03 exynos3475-novel3g_kor_skt_04"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x50a6
	DTBH_SUBTYPE_CODE=0x217584da
	;;
novellte)
	case $VARIANT in
	kor|skt|lgt|ktt)
		DTSFILES="exynos3475-novellte_kor_open_00 exynos3475-novellte_kor_open_01
			exynos3475-novellte_kor_open_03 exynos3475-novellte_kor_open_04"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x50a6
	DTBH_SUBTYPE_CODE=0x217584da
	;;
o5lte)
	case $VARIANT in
	eur|xx|swa)
		DTSFILES="exynos3475-o5lte_swa_open_00"
		;;
	chn|tw|zc|zh)
		DTSFILES="exynos3475-o5lte_chn_open_00"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x50a6
	DTBH_SUBTYPE_CODE=0x217584da
	;;
on5ltetmo)
	case $VARIANT in
	usa|att|tmo|mtr|can)
		DTSFILES="exynos3475-on5lte_usa_tmo_00 exynos3475-on5lte_usa_tmo_02
			exynos3475-on5lte_usa_tmo_05"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x50a6
	DTBH_SUBTYPE_CODE=0x217584da
	;;
xcover3velte)
	case $VARIANT in
	eur|xx)
		DTSFILES="exynos3475-xcover3velte_eur_open_00 exynos3475-xcover3velte_eur_open_01"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x50a6
	DTBH_SUBTYPE_CODE=0x217584da
	;;
xcover3veelte)
	case $VARIANT in
	eur|xx)
		DTSFILES="exynos3475-xcover3veelte_eur_open_00"
		;;
	*) ABORT "Unknown variant of $DEVICE: $VARIANT" ;;
	esac
	DTBH_PLATFORM_CODE=0x50a6
	DTBH_SUBTYPE_CODE=0x217584da
	;;
*) ABORT "Unknown device: $DEVICE" ;;
esac

mkdir -p "$OUTDIR" "$DTBDIR"

cd "$DTBDIR" || ABORT "Unable to cd to $DTBDIR!"

rm -f ./*

echo "Processing dts files..."

for dts in $DTSFILES; do
	echo "=> Processing: ${dts}.dts"
	"${CROSS_COMPILE}cpp" -nostdinc -undef -x assembler-with-cpp -I "$INCDIR" "$DTSDIR/${dts}.dts" > "${dts}.dts"
	echo "=> Generating: ${dts}.dtb"
	$DTCTOOL -p $DTB_PADDING -i "$DTSDIR" -O dtb -o "${dts}.dtb" "${dts}.dts"
done

echo "Generating dtb.img..."
"$RDIR/scripts/dtbTool/dtbTool" -o "$OUTDIR/dtb.img" -d "$DTBDIR/" -s $PAGE_SIZE --platform $DTBH_PLATFORM_CODE --subtype $DTBH_SUBTYPE_CODE || exit 1

echo "Done."
