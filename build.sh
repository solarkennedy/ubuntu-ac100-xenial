#!/bin/bash

#### Root check

if (( $EUID != 0 )); then
    echo "Please run build process as root!"
    exit
fi

#### Building core filesystem

rm -rf rfs
debootstrap --arch=armhf --foreign --variant=minbase xenial rfs
cd rfs
cp /usr/bin/qemu-arm-static usr/bin
chroot . /debootstrap/debootstrap --second-stage

#### Configuring APT for low-storage device

cat <<'EOF' > etc/apt/sources.list
deb http://ports.ubuntu.com/ubuntu-ports xenial main universe
deb http://ports.ubuntu.com/ubuntu-ports xenial-updates main universe
deb http://ports.ubuntu.com/ubuntu-ports xenial-security main universe
EOF

#### Preparing for changing environment

mount -t proc proc proc
mount -t sysfs sysfs sys
mount --bind /dev dev
cp ../linux-image-ac100_3.16*.deb tmp/
cp ../third-stage.sh tmp/third-stage.sh
chmod +x tmp/third-stage.sh
chroot . /tmp/third-stage.sh

#### Housekeeping

umount -l dev
umount -l sys
umount -l proc
rm -rf var/lib/apt/lists/*
rm -rf tmp/*
rm -rf usr/bin/qemu-arm-static
rm -rf root/.bash_history

#### Creating final package

rm -rf ../rootfs.tar.xz
tar -cJvpf ../rootfs.tar.xz .
echo "Done."
cd ..
rm -rf rfs
exit

#### Now boot SOS environment, erase part 4 and 7, extract filesystem and flash kernel image
