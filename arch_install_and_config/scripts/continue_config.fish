#!/usr/bin/fish

# exit if the user is 'root'
if test {$USER} = root
    echo 'Do not run this script as root'
    exit
end


# signature for a finger
fprintd-enroll

# edit 'system-local-login' to enable "fingreprint + password" login
echo '#%PAM-1.0
 
auth      required  pam_fprintd.so                                                                                                          
auth      include   system-login
 
account   include   system-login
password  include   system-login
session   include   system-login' > /etc/pam.d/system-local-login
                                                             

# install PIA
sudo pacman -S --needed --noconfirm openvpn

cd ~/private/programs/private-internet-access-vpn
makepkg -sricC --noconfirm

reset
echo -e 'Now you have to create `/etc/private-internet-access/login.conf` yourself\n\n'
fish

sudo chmod 0600 /etc/private-internet-access/login.conf
sudo chown root:root /etc/private-internet-access/login.conf
sudo pia -a
sudo systemctl restart NetworkManager


# enable and run PIA as a service
sudo systemctl enable openvpn@Singapore.service
sudo systemctl start openvpn@Singapore.service
sleep 10


# install Google Chrome
cd /tmp
wget 'https://aur.archlinux.org/cgit/aur.git/snapshot/google-chrome.tar.gz'
tar xzf google-chrome.tar.gz
rm google-chrome.tar.gz

cd /tmp/google-chrome 
makepkg -sricC --noconfirm
cd /tmp 

rm -rf google-chrome


# copy chromedriver to PATH
sudo cp ~/private/google_chrome/chromedriver /usr/bin/chromedriver 
sudo chown root:root /usr/bin/chromedriver 


# make `fish` as the default shell
reset
chsh -s /usr/bin/fish


# config vim for root
sudo cp ~/.vimrc /root
sudo cp -R ~/.vim /root
sudo chown -R root:root /root/.vim /root/.vimrc
