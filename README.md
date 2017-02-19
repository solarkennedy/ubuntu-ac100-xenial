# Porting Ubuntu 16.04 to Toshiba AC100

![Overview](https://github.com/nthchild/ubuntu-ac100-xenial/raw/master/screen.png)

**WARNING**: This is **experimental**, slipstreamed Xubuntu desktop. Many things don't work yet. I'm not responsible for any stability and functionality issues.

It is **strongly recommended** to use virtual machine/secondary operating system to build root filesystem.

## Changes I've applied

Compared to my Ubuntu 14.04 port

- All upstream patches and changes
- U-boot and upstream Linux 3.16 kernel
- XFCE instead of GNOME Flashback

Many things are not ported yet, such as keybinding, swap partition or themes.

## Known issues

- No proprietary graphics drivers - therefore no HDMI output, HW acceleration, or webcam support
- No sound yet
- Cannot turn off device (please shutdown system, then hold power button)
- Random kernel panics

## How to build

1. Make sure you're running Ubuntu 16.04
2. Install `debootstrap` and `qemu-user-static` packages
3. Download this repository to your PC
4. As root, execute `./build.sh`

Tip: You can use `time` utility to display how much time the process took (less than 1 hour in most cases), or append `2>&1 | tee log.txt` to save logs. Output file is called `rootfs.tgz`.

## Prepare device

1. Install proprietary nvflash utility (can be found [here](https://github.com/nthchild/ubuntu-ac100/blob/master/nvflash_20110628-2_all.deb)).
2. Connect AC100 to PC, press and hold Ctrl+Esc+Power.
3. Execute `nvflash --bl sos-uboot-r5-2013-09-23.bin --go` to boot into recovery mode

## Install Ubuntu

1. Copy two files to FAT32-formatted flash memory
   - `installer.sh`
   - `rootfs.tar.xz`
2. If you don't have U-boot installed, run `./switch-to-uboot` 
3. Mount USB device: `mount -t vfat /dev/sda1 /mnt`
4. Start installer and follow instructions: `sh /mnt/installer.sh`
5. Reboot device, wait 1-2 minutes to see setup wizard and finish installation.

## Additional resources

Without them, I wouldn't be able to create this project

- https://github.com/nthchild/ubuntu-ac100 (My 14.04 port, see "Additional resources" section)
- https://ac100.grandou.net/kerneldev#mainline_git_kernel (Upstream kernel compilation guide)
- https://github.com/cm-paz00/cm-paz00/wiki/InstallGuide (CM10.1+ installation guide)
- and many others

## Changelog

### 2017-02-19

- Swap file will be created during installation
- Output file is now compressed with XZ

Starting this release, I will *try* to upload output files.

### 2017-02-07

- First experimental release

## Copyright

```
    Ubuntu 16.04 build scripts for Toshiba AC100
    Copyright (C) 2015-2017 Mateusz Nowak

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
```

- Linux kernel and Buildroot are licenced under GNU General Public License version 2 (GPLv2).
- Distribution terms for each Ubuntu program are described in `/usr/share/doc/*/copyright`.
