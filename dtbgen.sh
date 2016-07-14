#!/bin/bash
# simple bash script for generating dtb image

# root directory of exynos3475 kernel git repo (default is this script's location)
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

[ -x "$DTCTOOL" ] || ABORT "You need to run ./build.sh first!"

[ -x "${CROSS_COMPILE}gcc" ] ||
ABORT "Unable to find gcc cross-compiler at location: ${CROSS_COMPILE}gcc"

[ "$1" ] && DEVICE=$1
[ "$TARGET" ] || TARGET=samsung
$RDIR/targets.sh "$TARGET" "$DEVICE" || ABORT

case $DEVICE in
gteslte)
	DTSFILES="exynos3475-gteslte_usa_open_00 exynos3475-gteslte_usa_open_01
		exynos3475-gteslte_usa_open_02 exynos3475-gteslte_usa_open_05"
	DTBH_PLATFORM_CODE=0x50a6
	DTBH_SUBTYPE_CODE=0x217584da
	;;
j1xlte)
	DTSFILES="exynos3475-j1xlte_eur_open_00"
	DTBH_PLATFORM_CODE=0x50a6
	DTBH_SUBTYPE_CODE=0x217584da
	;;
o5lte)
	DTSFILES="exynos3475-o5lte_swa_open_00"
	DTBH_PLATFORM_CODE=0x50a6
	DTBH_SUBTYPE_CODE=0x217584da
	;;
on5ltetmo)
	DTSFILES="exynos3475-on5lte_usa_tmo_00 exynos3475-on5lte_usa_tmo_02
		exynos3475-on5lte_usa_tmo_05"
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
