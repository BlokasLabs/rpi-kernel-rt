#!/bin/sh

mkdir -p build/boot/overlays

git clone --depth 1 --branch rpi-4.19.y-rt https://github.com/raspberrypi/linux
cd linux
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
export INSTALL_MOD_PATH=../build

# Arg1: kernel file name, Arg2: config to use
build_kernel() {
	local KERNEL=$1
	make mrproper
	make $2
	make zImage modules dtbs -j8
	make modules_install
	cp Module.symvers ../build/boot/${KERNEL}_Module.symvers
	cp arch/arm/boot/zImage ../build/boot/$KERNEL.img
	cp arch/arm/boot/dts/*.dtb ../build/boot/
	cp arch/arm/boot/dts/overlays/*.dtb* ../build/boot/overlays/
	cp arch/arm/boot/dts/overlays/README ../build/boot/overlays/
}

# Build kernel for Pi 1, Pi 0, Pi 0 W and Compute Module
build_kernel kernel bcmrpi_defconfig

# Build kernel for Pi 2, Pi 3, Pi 3+ and Compute Module 3
build_kernel kernel7 bcm2709_defconfig

# Build kerenl for Pi 4
build_kernel kernel7l bcm2711_defconfig
