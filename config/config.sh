#!/bin/bash

if [ ${UID} == 0 ];then
	echo "Don't run this script as root."
	exit
fi

# google-chrome
wget https://raw.githubusercontent.com/K-Guan/silver/master/silver
python silver -ic --noconfirm google-chrome

rm silver

wget https://raw.githubusercontent.com/racaljk/hosts/master/hosts
sudo mv hosts /etc

sudo pacman -S --noconfirm alsa-utils
sudo pacman -S --noconfirm openssh
sudo pacman -S --noconfirm {python3,vim-python3,bpython,python-pip}

sudo pip install --upgrade pip
sudo pip install --upgrade Sphinx
sudo pip install --upgrade beautifulsoup4

git clone --depth=1 https://github.com/K-Guan/private ~/private
cp -r ~/private/python-powerline-git ~/powerline
rm -rf Learn

cd ~/powerline
makepkg -sri --noconfirm
cd ~/
rm -rf powerline

git config --global user.email "KevinGuan.gm@gmail.com"
git config --global user.name "Kevin Guan"
git config --global push.default "simple"
git config --global user.signingkey "941C6829"
git config --global core.editor "vim"

cp ~/private/config/zshrc ~/.zshrc
cp ~/private/config/vimrc ~/.vimrc

git clone --depth=1 https://github.com/robbyrussell/oh-my-zsh ~/.oh-my-zsh
wget https://raw.githubusercontent.com/K-Guan/private/master/config/powerlevel9k.zsh-theme \
 -O ~/.oh-my-zsh/themes/powerlevel9k.zsh-theme

# bundle
mkdir -p ~/.vim/autoload ~/.vim/bundle
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

# vim
cd ~/.vim/bundle
git clone --depth=1 https://github.com/mbbill/undotree
git clone --depth=1 https://github.com/terryma/vim-multiple-cursors
git clone --depth=1 https://github.com/tpope/vim-fugitive
git clone --depth=1 https://github.com/easymotion/vim-easymotion
git clone --depth=1 https://github.com/kien/ctrlp.vim
git clone --depth=1 https://github.com/tacahiroy/ctrlp-funky.git
git clone --depth=1 https://github.com/kshenoy/vim-signature
git clone --depth=1 https://github.com/tpope/vim-repeat.git
git clone --depth=1 https://github.com/klen/python-mode
git clone --depth=1 https://github.com/ConradIrwin/vim-bracketed-paste
git clone --depth=1 https://github.com/kien/rainbow_parentheses.vim
git clone --depth=1 https://github.com/bling/vim-airline
cd ~/

mkdir ~/.vim/colors
wget https://raw.githubusercontent.com/tomasr/molokai/master/colors/molokai.vim -O ~/.vim/colors/molokai.vim

# cinnamon theme
git clone --depth=1 https://github.com/zagortenay333/new-minty
mkdir -p ~/.themes
mv new-minty/New-Minty ~/.themes
rm -rf new-minty
rm -rf ~/private
