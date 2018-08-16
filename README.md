# rpi-kernel-rt
Binary kernel builds based on -rt branches of https://github.com/raspberrypi/linux/

# Downloading prebuilt archives

Go to https://github.com/BlokasLabs/rpi-kernel-rt/releases, download one of the releases
and extract it to /, for example:

`tar -xvf ...`

# Manual building

## Prerequisities

Set up the cross compiler toolchain as described on Install Toolchain section of
https://www.raspberrypi.org/documentation/linux/kernel/building.md.

## Steps

1. Run `./build.sh`
1. Wait for ages
1. The build result will be in build/ folder. build/lib contents should go to /lib/
and build/boot should go to /boot/ on the SD card.
