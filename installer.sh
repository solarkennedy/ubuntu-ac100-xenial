#!/bin/sh
clear

#### Root check

if [ `id -u` != 0 ]; then
	echo "Please run installation process as root!"
	exit
fi

#### Environment check

if [ "`cat /etc/issue | grep SOSBoot`" == "" ]; then
	echo "Please run installation process from SOSBoot environment!"
	exit
fi

#### Files check

if [ ! -f /mnt/rootfs.tgz ]; then
	echo "System image missing (make sure rootfs.tgz file is present)"
	exit
fi

#### Confirmation

echo "DO YOU REALLY WANT TO OVERWRITE CURRENT FIRMWARE?"
echo "All data will be erased and Ubuntu files will be copied."
echo "Press ENTER to start, or CTRL+C to reboot."
read

#### Main process

sleep 2

echo "  -->  Preparing root storage..."
dd if=/dev/zero of=/dev/mmcblk0 bs=1M count=100
parted /dev/mmcblk0 mklabel gpt
parted /dev/mmcblk0 -s mkpart primary 7168s '100%'
parted /dev/mmcblk0 -s name 1 UDB
mkfs.ext4 /dev/mmcblk0p1
mkdir /target
mount -t ext4 /dev/mmcblk0p1 /target

echo "  -->  Copying system files..."
cd /target
gunzip < /mnt/rootfs.tgz | tar xpf -

echo "  -->  Housekeeping..."
cd /
sync
umount /target

echo ""
echo "Done. Please remove all external media and then press Ctrl+Alt+Del to reboot."
