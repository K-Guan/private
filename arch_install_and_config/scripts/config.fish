#!/bin/fish

# install some important packages
sudo pacman -S --needed --noconfirm wget git openssh


# change the locale when login
echo '

if status --is-login
    export LANG=en_US.UTF-8
end' >> /etc/fish/config.fish


# create a new user
reset
set usrnm 'kevin'

echo 'Please enter the password for kevin:'
read usrpasswd

useradd -m -G wheel -s /usr/bin/fish $usrnm
echo "$usrnm:$usrpasswd" | chpasswd

# add the new user to the `sudoers` list
sed -i "73a $usrnm ALL=(ALL) ALL" /etc/sudoers
clear


# install font and desktop
pacman -S --needed --noconfirm wqy-microhei
pacman -S --needed --noconfirm xorg-{server,xinit}
pacman -S --needed --noconfirm cinnamon

# install other packages
pacman -S --needed --noconfirm xf86-input-synaptics
pacman -S --needed --noconfirm guake
pacman -S --needed --noconfirm gnome-terminal
pacman -S --needed --noconfirm scrot
pacman -S --needed --noconfirm fcitx-{im,qt5,googlepinyin,configtool}
pacman -S --needed --noconfirm p7zip
pacman -S --needed --noconfirm mpv
pacman -S --needed --noconfirm easytag
pacman -S --needed --noconfirm alsa-utils
pacman -S --needed --noconfirm nodejs
pacman -S --needed --noconfirm phantomjs
pacman -S --needed --noconfirm pavucontrol
pacman -S --needed --noconfirm simplescreenrecorder
pacman -S --needed --noconfirm progress
pacman -S --needed --noconfirm btrfs-progs
pacman -S --needed --noconfirm vim-python3 bpython python-pip

pacman -S --needed --noconfirm mdk3
pacman -S --needed --noconfirm nmap
pacman -S --needed --noconfirm ettercap
pacman -S --needed --noconfirm aircrack-ng

# install and enable Network Manager
pacman -S --needed --noconfirm networkmanager
systemctl enable NetworkManager
systemctl start NetworkManager


# change the hosts
echo '72.52.9.107 privateinternetaccess.com' >> /etc/hosts

# change, lock the DNS and restart Network Manager
echo "# PIA servers
nameserver 209.222.18.222
nameserver 209.222.18.218" > /etc/resolv.conf

chattr +i /etc/resolv.conf
systemctl restart NetworkManager


# install some python packages
pip install --upgrade pip
pip install --upgrade Flask
pip install --upgrade Pillow
pip install --upgrade selenium
pip install --upgrade beautifulsoup4
pip install --upgrade pip-autoremove


# download some fonts of powerline for vim-airline
wget 'https://raw.githubusercontent.com/powerline/powerline/develop/font/10-powerline-symbols.conf' -O /usr/share/fonts/OTF/10-powerline-symbols.conf
wget 'https://raw.githubusercontent.com/powerline/powerline/develop/font/PowerlineSymbols.otf' -O /usr/share/fonts/OTF/PowerlineSymbols.otf

cp /usr/share/fonts/OTF/10-powerline-symbols.conf /etc/fonts/conf.d/10-powerline-symbols.conf


# install tedit
wget 'https://raw.githubusercontent.com/K-Guan/tedit/master/tedit' -O /usr/bin/tedit
chmod 755 /usr/bin/tedit

# install realpath
wget 'https://raw.githubusercontent.com/K-Guan/Learn/master/Python/programs/realpath' -O /usr/bin/realpath
chmod 755 /usr/bin/realpath

# install lyrics_search
wget 'https://raw.githubusercontent.com/K-Guan/Learn/master/Python/programs/lyrics_search' -O /usr/bin/lyrics_search
chmod 755 /usr/bin/lyrics_search


# copy `continue_config.fish` to the new user's home folder
cp continue_config.fish /home/kevin/continue_config.fish
chmod 755 '/home/kevin/continue_config.fish' 

echo "'Please logout and login as 'kevin', and run the below command:'
fish ~/continue_config.fish'"
