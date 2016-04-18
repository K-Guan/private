#!/bin/bash

cat > /etc/pacman.d/mirrorlist << EOF
Server = https://mirrors.ustc.edu.cn/archlinux/$repo/os/$arch
Server = http://mirror.adminbannok.com/archlinux/$repo/os/$arch
Server = http://mirrors.abscission.net/archlinux/$repo/os/$arch
Server = http://mirror.kaminski.io/archlinux/$repo/os/$arch
Server = http://arch.apt-get.eu/$repo/os/$arch
Server = http://mirror.its.dal.ca/archlinux/$repo/os/$arch
Server = http://mirrors.acm.wpi.edu/archlinux/$repo/os/$arch
Server = http://ftp.osuosl.org/pub/archlinux/$repo/os/$arch
Server = http://mirror.cs.pitt.edu/archlinux/$repo/os/$arch
Server = http://mirror.flipez.de/archlinux/$repo/os/$arch
EOF


# copy `pacman.conf` to `/ect`
cp pacman.conf /etc/pacman.conf

# refresh the new mirrors and install some important packages
sudo pacman -Syy 
sudo pacman -S --needed --noconfirm wget git openssh fish

# create the new user
usrnm='kevin'
read -s -p "Password: " usrpasswd

useradd -m -G wheel -s /usr/bin/fish ${usrnm}
echo "${usrnm}:${usrpasswd}" | chpasswd

# add the new user to `sudoers` list
if [ -n "${usrnm}" ];then
    sed -i "73a ${usrnm} ALL=(ALL) ALL" /etc/sudoers
fi
clear

# install font and desktop
pacman -S --needed --noconfirm wqy-microhei
pacman -S --needed --noconfirm xorg-{server,xinit}
pacman -S --needed --noconfirm cinnamon

# install other packages
pacman -S --needed --noconfirm xf86-input-synaptics
pacman -S --needed --noconfirm pantheon-terminal
pacman -S --needed --noconfirm guake
pacman -S --needed --noconfirm gnome-screenshot
pacman -S --needed --noconfirm fcitx-{im,qt5,googlepinyin,configtool}
pacman -S --needed --noconfirm p7zip
pacman -S --needed --noconfirm mpv
pacman -S --needed --noconfirm easytag
pacman -S --needed --noconfirm alsa-utils
pacman -S --needed --noconfirm nodejs
pacman -S --needed --noconfirm phantomjs
pacman -S --needed --noconfirm vim-python3 bpython python-pip

# install and enable Network Manager
pacman -S --needed --noconfirm networkmanager
systemctl enable NetworkManager
systemctl start NetworkManager

# change the hosts
echo '72.52.9.107 privateinternetaccess.com' >> /etc/hosts

# change, lock the DNS and restart Network Manager
cat > /etc/resolv.conf << EOF
# PIA servers
nameserver 209.222.18.222
nameserver 209.222.18.218
EOF

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


# create `continue.fish`
cat > 'continue.fish' << EOF
#!/usr/bin/fish

# exit if the user is "root"
if test $USER = root
    echo "Do not run this script as root"
    exit
end


# install PIA
sudo pacman -S --needed --noconfirm openvpn

cd ~/private/private-internet-access-vpn
makepkg -sricC --noconfirm

sudo vi /etc/private-internet-access/login.conf
sudo chmod 0600 /etc/private-internet-access/login.conf
sudo chown root:root /etc/private-internet-access/login.conf

sudo openvpn /etc/openvpn/Singapore.conf &

# install Google Chrome
cd /tmp
wget 'https://aur.archlinux.org/cgit/aur.git/snapshot/google-chrome.tar.gz'
tar xzf google-chrome.tar.gz
rm google-chrome.tar.gz

cd /tmp/google-chrome 
makepkg -sricC --noconfirm
cd /tmp 

rm -rf google-chrome
sudo kill (job -p)

# copy chromedriver to PATH
sudo cp ~/private/chromedriver /usr/bin/chromedriver 
sudo chmod 755 /usr/bin/chromedriver 
sudo chown root:root /usr/bin/chromedriver 

# set vim for root
sudo cp ~/.vimrc /root
sudo cp -R ~/.vim /root
sudo chown -R root:root /root/.vim
EOF

chmod 755 'continue.fish' 
mv 'continue.fish' '/home/kevin/continue.fish'

echo 'Please logout and login as "kevin", and run the below command: '
echo 'fish ~/continue.fish'
