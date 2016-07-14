#!/bin/bash
# simple bash script for generating dtb image

# directory containing cross-compile arm toolchain
TOOLCHAIN=$HOME/build/toolchain/gcc-linaro-4.9-2016.02-x86_64_arm-linux-gnueabihf

# device dependant variables
PAGE_SIZE=2048
DTB_PADDING=0

export ARCH=arm
export CROSS_COMPILE=$TOOLCHAIN/bin/arm-linux-gnueabihf-

RDIR=$(pwd)
BDIR=$RDIR/build
OUTDIR=$BDIR/arch/$ARCH/boot
DTSDIR=$RDIR/arch/$ARCH/boot/dts
DTBDIR=$OUTDIR/dtb
DTCTOOL=$BDIR/scripts/dtc/dtc
INCDIR=$RDIR/include

ABORT()
{
	echo "Error: $*"
	exit 1
}

[ -f "$DTCTOOL" ] || ABORT "You need to run ./build.sh first!"

[ "$1" ] && DEVICE=$1
[ "$DEVICE" ] || DEVICE=gteslte

case $DEVICE in
gteslte)
	DTSFILES="exynos3475-gteslte_usa_open_00 exynos3475-gteslte_usa_open_01
		exynos3475-gteslte_usa_open_02 exynos3475-gteslte_usa_open_05"
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
"$RDIR/scripts/dtbTool/dtbTool" -o "$OUTDIR/dtb.img" -d "$DTBDIR/" -s $PAGE_SIZE || exit 1

echo "Done."
