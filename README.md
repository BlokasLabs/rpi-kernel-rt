# rpi-kernel-rt
Binary kernel builds based on -rt branches of https://github.com/raspberrypi/linux/

Installing these builds can make your SD card non-bootable, so make sure to backup your current kernel build and any critical information on your SD card!

# Downloading prebuilt archives

Go to https://github.com/BlokasLabs/rpi-kernel-rt/releases, download one of the releases
and extract it to /, for example:

```shell
# Back up current kernel first.
sudo cp /boot/kernel.img /boot/kernel.img.bak
sudo cp /boot/kernel7.img /boot/kernel7.img.bak

# Download and extract RT kernel.
wget https://github.com/BlokasLabs/rpi-kernel-rt/archive/v4.14.59-rt37.tar.gz
sudo tar -xvf v4.14.59-rt37.tar.gz --strip 1 -C /
```

# Manual building

## Prerequisities

Set up the cross compiler toolchain as described on Install Toolchain section of
https://www.raspberrypi.org/documentation/linux/kernel/building.md.

## Steps

1. Run `./build.sh`
1. Wait for ages
1. The build result will be in build/ folder. build/lib contents should go to /lib/
and build/boot should go to /boot/ on the SD card.
