#!/bin/fish

# copy `pacman.conf` to `/ect`
cp mirrorlist /etc/pacman.d/mirrorlist

# copy `pacman.conf` to `/ect`
cp pacman.conf /etc/pacman.conf

# refresh the new mirrors and install some important packages
sudo pacman -Syy 
sudo pacman -S --needed --noconfirm wget git openssh fish

# create the new user
set usrnm 'kevin'
echo 'Please enter the password for kevin:'
read usrpasswd

useradd -m -G wheel -s /usr/bin/fish $usrnm
echo "$usrnm:$usrpasswd" | chpasswd

# add the new user to `sudoers` list
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
pacman -S --needed --noconfirm vim-python3 bpython python-pip

# install and enable ntpd
pacman -S --needed --noconfirm ntpd
sudo  systemctl enable ntp
sudo  systemctl start ntpd

# install and enable Network Manager
pacman -S --needed --noconfirm networkmanager
systemctl enable NetworkManager
systemctl start NetworkManager

# change the hosts
echo '72.52.9.107 privateinternetaccess.com' >> /etc/hosts

# change, lock the DNS and restart Network Manager
echo "
# PIA servers
nameserver 209.222.18.222
nameserver 209.222.18.218
" > /etc/resolv.conf

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


# create `continue.fish`
echo "
#!/usr/bin/fish

# exit if the user is 'root'
if test \$USER = root
    echo 'Do not run this script as root'
    exit
end


# install PIA
sudo pacman -S --needed --noconfirm openvpn

cd ~/private/programs/private-internet-access-vpn
makepkg -sricC --noconfirm

sudo vi /etc/private-internet-access/login.conf
sudo chmod 0600 /etc/private-internet-access/login.conf
sudo chown root:root /etc/private-internet-access/login.conf
sudo pia -a
sudo systemctl restart NetworkManager

# run PIA in the background and check if succeeded
sudo openvpn /etc/openvpn/Singapore.conf > /tmp/pia_status &

while true
    if sudo grep -q 'Initialization Sequence Completed$' /tmp/pia_status
        break
    else
        sleep 4
    end
end


# install Google Chrome
cd /tmp
wget 'https://aur.archlinux.org/cgit/aur.git/snapshot/google-chrome.tar.gz'
tar xzf google-chrome.tar.gz
rm google-chrome.tar.gz

cd /tmp/google-chrome 
makepkg -sricC --noconfirm
cd /tmp 

rm -rf google-chrome

# kill the PIA which's running in background
sudo kill (jobs -p)
sleep 2


# copy chromedriver to PATH
sudo cp ~/private/google_chrome/chromedriver /usr/bin/chromedriver 
sudo chmod 755 /usr/bin/chromedriver 
sudo chown root:root /usr/bin/chromedriver 

# config vim for root
sudo cp ~/.vimrc /root
sudo cp -R ~/.vim /root
sudo chown -R root:root /root/.vim
" > '/home/kevin/continue.fish'
chmod 755 '/home/kevin/continue.fish' 

echo "'Please logout and login as 'kevin', and run the below command:'
fish ~/continue.fish'"
