#!/bin/bash

if [ ${UID} == 0 ];then
	echo "Don't run this script as root."
	exit
fi

cd /tmp
# google-chrome
wget https://raw.githubusercontent.com/K-Guan/silver/master/silver
python silver -ic --noconfirm google-chrome
rm silver

# hosts
wget https://raw.githubusercontent.com/racaljk/hosts/master/hosts
sudo mv hosts /etc/hosts

# DNS
sudo rm /etc/resolv.conf
sudo echo '# OpenDNS servers' >> /etc/resolv.conf
sudo echo 'nameserver 208.67.222.222' >> /etc/resolv.conf
sudo echo 'nameserver 208.67.220.220' >> /etc/resolv.conf

sudo chattr +i /etc/resolv.conf
sudo systemctl restart NetworkManager

# other softwares
sudo pacman -S --noconfirm fish
sudo pacman -S --noconfirm p7zip
sudo pacman -S --noconfirm openssh
sudo pacman -S --noconfirm alsa-utils
sudo pacman -S --noconfirm {vim-python3,bpython,python-pip}

# Python packages
sudo pip install --upgrade pip
sudo pip install --upgrade Flask
sudo pip install --upgrade bpython
sudo pip install --upgrade selenium
sudo pip install --upgrade virtualenv
sudo pip install --upgrade beautifulsoup4
sudo pip install --upgrade pip-autoremove

# chromedriver
wget https://raw.githubusercontent.com/K-Guan/private/master/chromedriver
sudo mv chromedriver /usr/bin/chromedriver 
sudo chmod 755 /usr/bin/chromedriver 
sudo chown root:root /usr/bin/chromedriver 

# Fish Shell
sudo chsh -s /usr/bin/fish
mkdir -p ~/.config/fish/completions
wget https://raw.githubusercontent.com/d42/fish-pip-completion/master/pip.fish -O ~/.config/fish/completions/pip.fish
cat >> ~/.config/fish/config.fish << EOF
set -x LESS_TERMCAP_mb (printf "\033[01;31m")  
set -x LESS_TERMCAP_md (printf "\033[01;31m")  
set -x LESS_TERMCAP_me (printf "\033[0m")  
set -x LESS_TERMCAP_se (printf "\033[0m")  
set -x LESS_TERMCAP_so (printf "\033[01;44;33m")  
set -x LESS_TERMCAP_ue (printf "\033[0m")  
set -x LESS_TERMCAP_us (printf "\033[01;32m")  

export VISUAL="vim"
export EDITOR="vim"
EOF

echo 'fish_update_completions' | fish

# bpython
mkdir -p /home/kevin/.config/bpython/
cat >> /home/kevin/.config/bpython/config << EOF
[general]
editor = vim
EOF

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
