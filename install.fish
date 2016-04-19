#!/usr/bin/fish

# ask the user if we have already conneted to the Internet
echo 'Have you already connected to the Internet? [Y/N]'
read -n 1 network

while true
    if test {$network} = 'N' -o {$network} = 'n'
        echo 'Please connect to the Internet before run this script'
        exit
    else if test {$network} = 'Y' -o {$network} = 'y'
        break
    else
        echo 'Sorry, please enter "Y" or "N"'
        read -n 1 network
    end
end


# format the disk partition of the new system as `btrfs`
mkfs.btrfs -f /dev/sda

# mount the new system to `/mnt`
mount /dev/sda /mnt


# install the basic packages for the new system
pacstrap -i /mnt base base-devel

# generate an fstab file for the new system
genfstab -U /mnt >> /mnt/etc/fstab

# create a `continue.sh`
echo "
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

# install `grub` as the boot loader
pacman -S grub os-prober --needed --noconfirm
grub-install --target=i386-pc /dev/sda
grub-mkconfig -o /boot/grub/grub.cfg

# set the host name
echo 'Arch' > /etc/hostname

# set the root password
passwd

# exit `chroot`
exit
" > /mnt/tmp/continue.sh
chmod 755 /mnt/tmp/continue.sh

# run 'continue.sh' via `arch-chroot`
arch-chroot /mnt /tmp/continue.sh

# umount the partition
umount -R /mnt
