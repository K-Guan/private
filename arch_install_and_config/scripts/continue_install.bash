#!/bin/bash

# set the locale (system language)
echo 'en_US.UTF-8 UTF-8' >> /etc/locale.gen
echo 'zh_CN.UTF-8 UTF-8' >> /etc/locale.gen
echo 'zh_TW.UTF-8 UTF-8' >> /etc/locale.gen
locale-gen

echo 'LANG=en_US.UTF-8' > /etc/locale.conf


# set the timezone (`4911` is 'Bejing, China, Asia')
echo -e '4\n9\n1\n1' | tzselect
ln -s /usr/share/zoneinfo/Asia/Shanghai /etc/localtime

hwclock --systohc --utc


# install wifi-menu if found a wireless card
if ip link | grep -P '^\d: wlp'; then
    sudo pacman -S wifi-menu --needed --noconfirm
else 
    dhcpcd
fi   


# install `grub` as the boot loader
pacman -S grub os-prober --needed --noconfirm

grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg


# set the host name
echo 'Arch' > /etc/hostname


# set the root password
reset
passwd
