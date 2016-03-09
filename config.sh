#!/bin/bash

cat << EOF > /etc/pacman.d/mirrorlist
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


if [ $(getconf LONG_BIT) = 64 ];then
    sed -i '93d' /etc/pacman.conf > /dev/null 2>&1
    sed -i '92a Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf > /dev/null 2>&1
    sed -i 's/\#\[multilib\]/\[multilib\]/g' /etc/pacman.conf  
fi

sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#TotalDownload/TotalDownload/g' /etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf

sudo pacman -Syy 
sudo pacman -S --needed --noconfirm wget git openssh fish

usrnm='kevin'
read -s -p "Password: " usrpasswd

useradd -m -G wheel -s /usr/bin/fish ${usrnm}
echo "${usrnm}:${usrpasswd}" | chpasswd

if [ -n "${usrnm}" ];then
    sed -i "73a ${usrnm} ALL=(ALL) ALL" /etc/sudoers
fi
clear

# font and desktop
pacman -S --needed --noconfirm wqy-microhei
pacman -S --needed --noconfirm xorg-{server,xinit}
pacman -S --needed --noconfirm cinnamon

# other softwares
pacman -S --needed --noconfirm {gnome-{screenshot,terminal}
pacman -S --needed --noconfirm fcitx-{im,qt5,googlepinyin,configtool}
pacman -S --needed --noconfirm mpv
pacman -S --needed --noconfirm xf86-input-synaptics
pacman -S --needed --noconfirm p7zip
pacman -S --needed --noconfirm phantomjs
pacman -S --needed --noconfirm alsa-utils
pacman -S --needed --noconfirm vim-python3 bpython python-pip

# networkmanager
pacman -S --needed --noconfirm networkmanager
systemctl enable NetworkManager
systemctl start NetworkManager

# hosts
echo '72.52.9.107 privateinternetaccess.com' >> /etc/hosts

# DNS
echo '# PIA servers' > /etc/resolv.conf
echo 'nameserver 209.222.18.222' >> /etc/resolv.conf
echo 'nameserver 209.222.18.218' >> /etc/resolv.conf

chattr +i /etc/resolv.conf
systemctl restart NetworkManager

# Python packages
pip install --upgrade pip
pip install --upgrade Flask
pip install --upgrade selenium
pip install --upgrade beautifulsoup4
pip install --upgrade pip-autoremove

# powerline for vim-airline
wget 'https://raw.githubusercontent.com/powerline/powerline/develop/font/10-powerline-symbols.conf' -O /usr/share/fonts/OTF/10-powerline-symbols.conf
wget 'https://raw.githubusercontent.com/powerline/powerline/develop/font/PowerlineSymbols.otf' -O /usr/share/fonts/OTF/PowerlineSymbols.otf

cp /usr/share/fonts/OTF/10-powerline-symbols.conf /etc/fonts/conf.d/10-powerline-symbols.conf

# tedit
wget 'https://raw.githubusercontent.com/K-Guan/tedit/master/tedit' -O /usr/bin/tedit
chmod 755 /usr/bin/tedit


cat >> 'continue.sh' << EOF
#!/bin/bash

if [ ${UID} == 0 ];then
	echo "Don't run this script as root."
	exit
fi

# xinitrc
cp /etc/X11/xinit/xinitrc ~/.xinitrc

sed -i '$ d' ~/.xinitrc
echo 'exec cinnamon-session' >> ~/.xinitrc

# PIA
sudo pacman -S --needed --noconfirm openvpn

cd ~/private/private-internet-access-vpn
makepkg -sricC --noconfirm

sudo vi /etc/private-internet-access/login.conf
sudo chmod 0600 /etc/private-internet-access/login.conf
sudo chown root:root /etc/private-internet-access/login.conf

sudo pia -a

# google-chrome
cd /tmp
wget 'https://aur.archlinux.org/cgit/aur.git/snapshot/google-chrome.tar.gz'
tar xzf google-chrome.tar.gz
rm google-chrome.tar.gz

cd /tmp/google-chrome 
makepkg -sricC --noconfirm
cd /tmp 

rm -rf google-chrome


# chromedriver
sudo cp ~/private/chromedriver /usr/bin/chromedriver 
sudo chmod 755 /usr/bin/chromedriver 
sudo chown root:root /usr/bin/chromedriver 

# Fish Shell
mkdir -p ~/.config/fish/completions
wget 'https://raw.githubusercontent.com/d42/fish-pip-completion/master/pip.fish' -O ~/.config/fish/completions/pip.fish

cat >> ~/.config/fish/config.fish << FEOF
set -x LESS_TERMCAP_mb (printf "\033[01;31m")  
set -x LESS_TERMCAP_md (printf "\033[01;31m")  
set -x LESS_TERMCAP_me (printf "\033[0m")  
set -x LESS_TERMCAP_se (printf "\033[0m")  
set -x LESS_TERMCAP_so (printf "\033[01;44;33m")  
set -x LESS_TERMCAP_ue (printf "\033[0m")  
set -x LESS_TERMCAP_us (printf "\033[01;32m")  

export VISUAL="vim"
export EDITOR="vim"

export LESS=' -R '
FEOF

echo 'fish_update_completions' | fish


# bpython
mkdir -p /home/kevin/.config/bpython/
cat >> /home/kevin/.config/bpython/config << BEOF
[general]
editor = vim
BEOF

# git config
git config --global user.email "KevinGuan.gm@gmail.com"
git config --global user.name "Kevin Guan"
git config --global push.default "simple"
git config --global user.signingkey "941C6829"
git config --global core.editor "vim"

# vimrc
cp ~/private/vimrc ~/.vimrc

# bundle
mkdir -p ~/.vim/autoload ~/.vim/bundle
wget 'https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim' -O  ~/.vim/autoload/pathogen.vim

# vim plugins
mkdir ~/.vim/colors
wget 'https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim' -O ~/.vim/colors/molokai.vim
wget 'https://raw.githubusercontent.com/vim-airline/vim-airline-themes/master/autoload/airline/themes/serene.vim' -O ~/.vim/bundle/vim-airline/autoload/airline/themes/serene.vim

git clone --depth=1 'https://github.com/terryma/vim-multiple-cursors' ~/.vim/bundle/vim-multiple-cursors
git clone --depth=1 'https://github.com/tpope/vim-fugitive' ~/.vim/bundle/vim-fugitive
git clone --depth=1 'https://github.com/easymotion/vim-easymotion' ~/.vim/bundle/vim-signature
git clone --depth=1 'https://github.com/kshenoy/vim-signature' ~/.vim/bundle/vim-signature
git clone --depth=1 'https://github.com/klen/python-mode' ~/.vim/bundle/python-mode
git clone --depth=1 'https://github.com/ConradIrwin/vim-bracketed-paste' ~/.vim/bundle/vim-bracketed-paste
git clone --depth=1 'https://github.com/kien/rainbow_parentheses.vim' ~/.vim/bundle/rainbow_parentheses.vim
git clone --depth=1 'https://github.com/bling/vim-airline' ~/.vim/bundle/vim-airline
git clone --depth=1 'https://github.com/Glench/Vim-Jinja2-Syntax' ~/.vim/bundle/Vim-Jinja2-Syntax

# cinnamon theme
mkdir ~/.themes
git clone --depth=1 'https://github.com/zagortenay333/new-minty' ~/.themes/new-minty
mv ~/.themes/new-minty/New-Minty ~/.themes/New-Minty
rm -rf ~/.themes/new-minty

# set fish and vim
sudo chsh -s /usr/bin/fish

sudo cp -R ~/.vim /root
sudo chown -R root:root /root/.vim
EOF

chmod 755 'continue.sh' 
mv 'continue.sh' '/home/kevin/continue.sh'

echo 'Please logout and login as "kevin", and run command: '
echo 'bash ~/continue.sh'
