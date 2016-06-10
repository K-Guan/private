#!/bin/bash

# connect to the Internet
if ip link | grep -P '^\d: wlp'; then
    wifi-menu
else
    dhcpcd
fi

# copy `mirrorlist` to `/ect/pacman.d`
cp ../pacman/mirrorlist /etc/pacman.d/mirrorlist
 
# copy `pacman.conf` to `/ect`
cp ../pacman/pacman.conf /etc/pacman.conf

# refresh the new mirrors
sudo pacman -Syy 

# install fish
sudo pacman -S --needed --noconfirm fish
