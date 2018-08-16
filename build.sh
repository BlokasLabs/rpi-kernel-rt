#!/bin/sh

mkdir -p build/boot/overlays

git clone --depth 1 --branch rpi-4.14.y-rt https://github.com/raspberrypi/linux
cd linux
export ARCH=arm
export CROSS_COMPILE=arm-linux-gnueabihf-
export INSTALL_MOD_PATH=../build

# Build kernel for Pi 1, Pi 0, Pi 0 W and Compute Module
export KERNEL=kernel
make bcmrpi_defconfig
make zImage modules dtbs -j8
make modules_install
cp arch/arm/boot/zImage ../build/boot/$KERNEL.img
cp arch/arm/boot/dts/*.dtb ../build/boot/
cp arch/arm/boot/dts/overlays/*.dtb* ../build/boot/overlays/
cp arch/arm/boot/dts/overlays/README ../build/boot/overlays/

# Build kernel for Pi 2, Pi 3, Pi 3+ and Compute Module 3
export KERNEL=kernel7
make mrproper
make bcm2709_defconfig
make zImage modules dtbs -j8
make modules_install
cp arch/arm/boot/zImage ../build/boot/$KERNEL.img
cp arch/arm/boot/dts/*.dtb ../build/boot/
cp arch/arm/boot/dts/overlays/*.dtb* ../build/boot/overlays/
cp arch/arm/boot/dts/overlays/README ../build/boot/overlays/

