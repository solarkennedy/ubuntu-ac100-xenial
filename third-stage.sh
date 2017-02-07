#!/bin/bash

#### Prepare environment path

export PS1="(chroot)${PS1}"
export PATH=/bin:/usr/bin:/sbin:/usr/sbin
export DEBIAN_FRONTEND=noninteractive

#### Configure networking and timezone

echo '127.0.0.1 localhost' > /etc/hosts
echo '127.0.1.1 oem' >> /etc/hosts
echo 'oem' > /etc/hostname
echo 'Etc/UTC' > /etc/timezone
dpkg-reconfigure -f noninteractive tzdata

#### Install packages

apt update
apt dist-upgrade -yq
apt install flash-kernel linux-firmware sudo u-boot-tools wireless-tools -y
apt install xserver-xorg{,-input-{evdev,synaptics},-video-fbdev} -y
apt install xubuntu-default-settings light{dm{,-gtk-greeter{,-settings}},-locker} -y
apt install xfce4-{appfinder,indicator-plugin,notifyd,panel,power-manager,screenshooter,terminal,whiskermenu-plugin} -y
apt install catfish lxtask midori mousepad ristretto thunar -y
apt install evince file-roller gnome-{calculator,system-tools} gucharmap -y
apt install {language-selector,network-manager}-gnome software-properties-gtk -y
apt install oem-config-gtk ubiquity-frontend-gtk -y

#### Create filesystem table

cat <<'EOF' > /etc/fstab
/dev/mmcblk0p1   /   ext4   rw,noatime,commit=30,barrier=1,data=ordered   0   0
EOF

#### Fix flash-kernel utility

cat <<'EOF' > /usr/share/flash-kernel/db/all.db
Machine: Toshiba AC100 / Dynabook AZ
Method: generic
U-Boot-Kernel-Address: 0x1000000
U-Boot-Initrd-Address: 0x0
Boot-Kernel-Path: /boot/uImage
Boot-Initrd-Path: /boot/uInitrd
Bootloader-sets-root: no
EOF

#### Installing kernel

dpkg -i /tmp/linux-image-ac100_3.16*.deb

#### Configure swap 

echo 'vm.swappiness = 25' >> /etc/sysctl.conf

#### Add user

adduser --disabled-password --gecos "" oem
echo 'oem:oem' | chpasswd
gpasswd -a oem sudo

#### Housekeeping

oem-config-prepare
apt-get autoremove --purge -y
apt-get autoclean
apt-get clean
exit
