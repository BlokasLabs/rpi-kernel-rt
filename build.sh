#!/bin/sh

mkdir -p build/boot/overlays

git clone --depth 1 --branch rpi-4.19.y-rt https://github.com/BlokasLabs/rpi-linux-rt linux
cd linux
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
export INSTALL_MOD_PATH=../build

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
	make zImage modules dtbs -j8
	make modules_install
	cp Module.symvers ../build/boot/${MODULE_SYMVERS}
	cp System.map ../build/boot/${SYSTEM_MAP}
	cp arch/arm/boot/zImage ../build/boot/${KERNEL}.img
	cp arch/arm/boot/dts/*.dtb ../build/boot/
	cp arch/arm/boot/dts/overlays/*.dtb* ../build/boot/overlays/
	cp arch/arm/boot/dts/overlays/README ../build/boot/overlays/
}

# Build kernel for Pi 1, Pi 0, Pi 0 W and Compute Module
build_kernel "" bcmrpi_defconfig

# Build kernel for Pi 2, Pi 3, Pi 3+ and Compute Module 3
build_kernel "7" bcm2709_defconfig

# Build kerenl for Pi 4
build_kernel "7l" bcm2711_defconfig

# Run depmod for all kernels and unlink build and source
find "../build/lib/modules" -mindepth 1 -maxdepth 1 -type d | while read DIR; do
	BASEDIR="$(basename "${DIR}")"
	echo depmod ${BASEDIR}
	depmod -b ../build -a "${BASEDIR}"
	unlink "${DIR}/build"
	unlink "${DIR}/source"
done
