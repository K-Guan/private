#!/usr/bin/fish

# format the disk partition of the new system as `btrfs`
mkfs.btrfs -f /dev/sda

# mount the new system to `/mnt`
mount /dev/sda /mnt

# install the basic packages for the new system
pacstrap -i /mnt base base-devel

# generate an fstab file for the new system
genfstab -U /mnt >> /mnt/etc/fstab

# create `continue_install.bash`
cp continue_install.bash /mnt/tmp/continue_install.bash
chmod 755 /mnt/continue_install.bash

# run 'continue_install.bash' via `arch-chroot`
arch-chroot /mnt /continue_install.bash
rm /mnt/continue_install.bash

# umount the partition
umount -R /mnt
