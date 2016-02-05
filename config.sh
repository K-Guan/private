#!/bin/bash

if [ $(getconf LONG_BIT) = 64 ];then
    sed -i '93d' /etc/pacman.conf > /dev/null 2>&1
    sed -i '92a Include = /etc/pacman.d/mirrorlist' /etc/pacman.conf > /dev/null 2>&1
    sed -i 's/\#\[multilib\]/\[multilib\]/g' /etc/pacman.conf  
fi

sed -i 's/#Color/Color/g' /etc/pacman.conf
sed -i 's/#TotalDownload/TotalDownload/g' /etc/pacman.conf
sed -i 's/#VerbosePkgLists/VerbosePkgLists/g' /etc/pacman.conf

sudo pacman -Syy 
sudo pacman -S --needed --noconfirm {wget,git,openssh,fish}

usrnm='kevin'
read -s -p "Password: " usrpasswd

useradd -m -G wheel -s /usr/bin/fish ${usrnm}
echo "${usrnm}:${usrpasswd}" | chpasswd

if [ -n "${usrnm}" ];then
    sed -i "73a ${usrnm} ALL=(ALL) ALL" /etc/sudoers
fi
clear


cat >> 'continue.sh' << EOF
#!/bin/bash

if [ ${UID} == 0 ];then
	echo "Don't run this script as root."
	exit
fi

# font, xorg
sudo pacman -S --needed --noconfirm wqy-microhei
sudo pacman -S --needed --noconfirm xorg-{server,xinit}
cp /etc/X11/xinit/xinitrc ~/.xinitrc
sed -i '\$d' ~/.xinitrc

# desktop
sudo pacman -S --needed --noconfirm cinnamon
sudo pacman -S --needed --noconfirm {gnome-screenshot,gnome-terminal}
sed -i '$ d' ~/.xinitrc
echo 'exec cinnamon-session' >> ~/.xinitrc

# NetworkManager
sudo pacman -S --needed --noconfirm networkmanager
sudo systemctl enable NetworkManager
sudo systemctl start NetworkManager
sudo pacman -S --needed --noconfirm fcitx-{im,qt5,googlepinyin,configtool}
sudo pacman -S --needed --noconfirm mpv
sudo pacman -S --needed --noconfirm xf86-input-synaptics

# hosts
cat /etc/hosts >> /tmp/hosts
echo '72.52.9.107 privateinternetaccess.com' >> /tmp/hosts
sudo mv /tmp/hosts /etc/hosts

# DNS
echo '# PIA servers' >> /tmp/resolv.conf
echo 'nameserver 209.222.18.222' >> /tmp/resolv.conf
echo 'nameserver 209.222.18.218' >> /tmp/resolv.conf
sudo mv /tmp/resolv.conf /etc/resolv.conf

sudo chattr +i /etc/resolv.conf
sudo systemctl restart NetworkManager

# PIA
sudo pacman -S --needed --noconfirm openvpn

cd private-internet-access-vpn
makepkg -sricC --noconfirm

sudo vi /etc/private-internet-access/login.conf
sudo chmod 0600 /etc/private-internet-access/login.conf
sudo chown root:root /etc/private-internet-access/login.conf

sudo pia -a
cd ~/private

# google-chrome
cd /tmp
wget 'https://aur.archlinux.org/cgit/aur.git/snapshot/google-chrome.tar.gz'
tar xzf google-chrome.tar.gz
rm google-chrome.tar.gz

cd google-chrome 
makepkg -sricC --noconfirm
cd ..

rm -rf google-chrome
cd ~/private


# other softwares
sudo pacman -S --needed --noconfirm p7zip
sudo pacman -S --needed --noconfirm alsa-utils
sudo pacman -S --needed --noconfirm {vim-python3,bpython,python-pip}

# Python packages
sudo pip install --upgrade pip
sudo pip install --upgrade Flask
sudo pip install --upgrade selenium
sudo pip install --upgrade beautifulsoup4
sudo pip install --upgrade pip-autoremove

# chromedriver
sudo cp ~/private/chromedriver /usr/bin/chromedriver 
sudo chmod 755 /usr/bin/chromedriver 
sudo chown root:root /usr/bin/chromedriver 

# Fish Shell
mkdir -p ~/.config/fish/completions
wget https://raw.githubusercontent.com/d42/fish-pip-completion/master/pip.fish -O ~/.config/fish/completions/pip.fish

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
FEOF

echo 'fish_update_completions' | fish

# bpython
mkdir -p /home/kevin/.config/bpython/
cat >> /home/kevin/.config/bpython/config << BEOF
[general]
editor = vim
BEOF

# powerline for vim-airline
wget https://raw.githubusercontent.com/powerline/powerline/develop/font/10-powerline-symbols.conf
wget https://raw.githubusercontent.com/powerline/powerline/develop/font/PowerlineSymbols.otf

sudo cp 10-powerline-symbols.conf /usr/share/fonts/OTF/ 
sudo mv 10-powerline-symbols.conf /etc/fonts/conf.d/
sudo mv PowerlineSymbols.otf /usr/share/fonts/OTF/

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
wget https://raw.githubusercontent.com/tpope/vim-pathogen/master/autoload/pathogen.vim -O  ~/.vim/autoload/pathogen.vim

# vim plugins
mkdir ~/.vim/colors
wget https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim -O ~/.vim/colors/molokai.vim
wget https://raw.githubusercontent.com/vim-airline/vim-airline-themes/master/autoload/airline/themes/serene.vim -O ~/.vim/bundle/vim-airline/autoload/airline/themes/serene.vim

cd ~/.vim/bundle
git clone --depth=1 https://github.com/terryma/vim-multiple-cursors
git clone --depth=1 https://github.com/tpope/vim-fugitive
git clone --depth=1 https://github.com/easymotion/vim-easymotion
git clone --depth=1 https://github.com/kshenoy/vim-signature
git clone --depth=1 https://github.com/klen/python-mode
git clone --depth=1 https://github.com/ConradIrwin/vim-bracketed-paste
git clone --depth=1 https://github.com/kien/rainbow_parentheses.vim
git clone --depth=1 https://github.com/bling/vim-airline
git clone --depth=1 https://github.com/Glench/Vim-Jinja2-Syntax
cd -

# cinnamon theme
git clone --depth=1 https://github.com/zagortenay333/new-minty
mkdir -p ~/.themes
mv new-minty/New-Minty ~/.themes
rm -rf new-minty

# set fish and vim
sudo chsh -s /usr/bin/fish

sudo cp -R ~/.vim /root
sudo chown -R root:root /root/.vim
EOF

chmod 755 'continue.sh' 
mv 'continue.sh' /home/kevin

echo 'Please logout and login as "kevin", and run command: '
echo 'bash ~/continue.sh'
