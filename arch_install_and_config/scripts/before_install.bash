#!/bin/bash

# connect to the Internet
wifi-menu

# copy `mirrorlist` to `/ect/pacman.d`
cp ../pacman/mirrorlist /etc/pacman.d/mirrorlist
 
# copy `pacman.conf` to `/ect`
cp ../pacman/pacman.conf /etc/pacman.conf

# refresh the new mirrors
sudo pacman -Syy 
