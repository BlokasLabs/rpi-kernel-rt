#!/bin/sh

mkdir -p build/boot/overlays

git clone --depth 1 --branch blokas-rpi-6.6.y-rt https://github.com/BlokasLabs/rpi-linux-rt linux
cd linux

# Arg1: kernel suffix, Arg2: config to use
build_kernel() {
	local KERNEL=kernel$1
	local MODULE_SYMVERS=Module$1.symvers
	local SYSTEM_MAP=System$1.map
	local UNAME_STRING=uname_string$1
	echo Building ${KERNEL}.img with config $2...
	# dt-blob.dts?
	# git_hash
	make mrproper
	make $2
	make $3 modules dtbs -j8
	make modules_install
	cp Module.symvers ../build/boot/${MODULE_SYMVERS}
	cp System.map ../build/boot/${SYSTEM_MAP}
	cp arch/${ARCH}/boot/$3 ../build/boot/${KERNEL}.img
	if [ "$ARCH" = "arm" ]; then
		cp arch/${ARCH}/boot/dts/*.dtb ../build/boot/
	else
		cp arch/${ARCH}/boot/dts/broadcom/*.dtb ../build/boot/
	fi
	cp arch/${ARCH}/boot/dts/overlays/*.dtb* ../build/boot/overlays/
	cp arch/${ARCH}/boot/dts/overlays/README ../build/boot/overlays/
}

# 32 bit ARM builds.
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
export INSTALL_MOD_PATH=../build

# Build kernel for Pi 1, Pi 0, Pi 0 W and Compute Module
build_kernel "" bcmrpi_defconfig zImage

# Build kernel for Pi 2, Pi 3, Pi 3+ and Compute Module 3
build_kernel "7" bcm2709_defconfig zImage

# Build kernel for Pi 4
build_kernel "7l" bcm2711_defconfig zImage

# 64 bit ARM builds
export ARCH=arm64
export CROSS_COMPILE=aarch64-linux-gnu-

# Build kernel for Pi 4 (work on Pi 5 too)
build_kernel "8" bcm2711_defconfig Image

# Build kernel for Pi 5
build_kernel "2712" bcm2712_defconfig Image

# Run depmod for all kernels and unlink build and source
find "../build/lib/modules" -mindepth 1 -maxdepth 1 -type d | while read DIR; do
	BASEDIR="$(basename "${DIR}")"
	echo depmod ${BASEDIR}
	depmod -b ../build -a "${BASEDIR}"
	unlink "${DIR}/build"
	unlink "${DIR}/source"
done
