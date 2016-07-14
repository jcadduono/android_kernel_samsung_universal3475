#!/bin/bash
# Stock Samsung kernel for Samsung Galaxy Tab E & On5 (2015) build script by jcadduono

################### BEFORE STARTING ################
#
# download a working toolchain and extract it somewhere and configure this
# file to point to the toolchain's root directory.
#
# once you've set up the config section how you like it, you can simply run
# ./build.sh [VARIANT]
#
###################### CONFIG ######################

# root directory of gteslte kernel git repo (default is this script's location)
RDIR=$(pwd)

[ "$VER" ] ||
# version number
VER=$(cat "$RDIR/VERSION")

# directory containing cross-compile arm toolchain
TOOLCHAIN=$HOME/build/toolchain/gcc-linaro-4.9-2016.02-x86_64_arm-linux-gnueabihf

# amount of cpu threads to use in kernel make process
THREADS=5

############## SCARY NO-TOUCHY STUFF ###############

export ARCH=arm
export CROSS_COMPILE=$TOOLCHAIN/bin/arm-linux-gnueabihf-

[ "$1" ] && DEVICE=$1
[ "$DEVICE" ] || DEVICE=gteslte
[ "$TARGET" ] || TARGET=samsung

DEFCONFIG=${TARGET}_${DEVICE}_defconfig

ABORT()
{
	echo "Error: $*"
	exit 1
}

[ -f "$RDIR/arch/$ARCH/configs/${DEFCONFIG}" ] ||
abort "Config $DEFCONFIG not found in $ARCH configs!"

export LOCALVERSION=$TARGET-$DEVICE-$VER

CLEAN_BUILD()
{
	echo "Cleaning build..."
	cd "$RDIR"
	rm -rf build
}

SETUP_BUILD()
{
	echo "Creating kernel config for $LOCALVERSION..."
	cd "$RDIR"
	mkdir -p build
	make -C "$RDIR" O=build "$DEFCONFIG" \
		|| ABORT "Failed to set up build"
}

BUILD_KERNEL()
{
	echo "Starting build for $LOCALVERSION..."
	while ! make -C "$RDIR" O=build -j"$THREADS"; do
		read -p "Build failed. Retry? " do_retry
		case $do_retry in
			Y|y) continue ;;
			*) return 1 ;;
		esac
	done
}

BUILD_DTB()
{
	echo "Generating dtb.img..."
	cd "$RDIR"
	./dtbgen.sh $DEVICE || ABORT "Failed to generate dtb.img!"
}

CLEAN_BUILD && SETUP_BUILD && BUILD_KERNEL && BUILD_DTB && echo "Finished building $LOCALVERSION!"
