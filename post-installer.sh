#!/bin/bash

# remove libreoffice
sudo dnf remove -y libreoffice*

# update and upgrade package
sudo dnf update -y
sudo dnf upgrade --refresh -y
sudo dnf autoremove -y

# disable quiet boot screen
sudo cp /etc/default/grub /etc/default/grub.bak
sudo cp grub-quiet /etc/default/grub
sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
# if [ -f "/sys/firmware/efi" ]; 
# then
#     sudo grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
# else
#     sudo grub2-mkconfig -o /boot/grub2/grub.cfg
# fi

# enable RPMFusion and Flathub
sudo dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-"$(rpm -E %fedora)".noarch.rpm -y
sudo dnf install https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-"$(rpm -E %fedora)".noarch.rpm -y
sudo dnf upgrade --refresh -y
sudo dnf groupupdate core -y
sudo dnf install rpmfusion-free-release-tainted -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# install apps (vscode, chrome, brave, gnome-tweaks, htop, neofetch, vim, open-jdk, R, flutter)
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

sudo dnf config-manager --set-enabled google-chrome
sudo dnf makecache

sudo dnf install -y git dnf-plugins-core python3-pip clang cmake ninja-build pkg-config gtk3-devel xz-devel google-chrome-stable brave-browser htop neofetch vim-enhanced gnome-tweaks  java-latest-openjdk R rstudio-desktop code
git config --global core.compression 0  # turn off compression
git clone https://github.com/flutter/flutter.git -b stable ~/flutter
echo "export PATH=$PATH:$HOME/flutter/bin" >> $HOME/.bashrc
source $HOME/.bashrc
# ~/flutter/bin/flutter precache
~/flutter/bin/flutter doctor

# install media codecs
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
sudo dnf install lame\* --exclude=lame-devel -y
sudo dnf group upgrade --with-optional Multimedia -y

# # install dracula theme
# git clone https://github.com/dracula/gtk.git /usr/share/themes/Dracula
# gsettings set org.gnome.desktop.interface gtk-theme 'Dracula' 
# gsettings set org.gnome.desktop.wm.preferences theme 'Dracula'

# wallpapers
mkdir $HOME/.local/share/gnome-background-properties
cp assets/yu-kato.xml assets/yu-kato-l.webp assets/yu-kato-d.webp $HOME/.local/share/gnome-background-properties

# install orchis theme
sudo dnf install -y sassc libsass
git clone https://github.com/vinceliuice/Orchis-theme.git $HOME/.themes/orchis
chmod u+x $HOME/.themes/orchis/install.sh
$HOME/.themes/orchis/install.sh -l -t grey --tweaks macos
$HOME/.themes/orchis/install.sh -l -t green --tweaks macos
$HOME/.themes/orchis/install.sh -l -t default --tweaks macos
rm -rf $HOME/.themes/orchis

gsettings set org.gnome.desktop.interface gtk-theme 'Orchis-Green-Dark' 
gsettings set org.gnome.desktop.wm.preferences theme 'Orchis-Green-Dark' 

echo "export GTH_THEME=Orchis-Green-Dark-Compact" >> $HOME/.bashrc

# install whitesur, tela, and cursor icons
git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git $HOME/.icons/whitesur
chmod u+x $HOME/.icons/whitesur/install.sh
$HOME/.icons/whitesur/install.sh -a -b --theme grey
$HOME/.icons/whitesur/install.sh -a -b --theme green

git clone https://github.com/vinceliuice/Tela-icon-theme.git $HOME/.icons/tela
chmod u+x $HOME/.icons/tela/install.sh
$HOME/.icons/tela/install.sh -c green
$HOME/.icons/tela/install.sh -c black

rm -rf $HOME/.icons
sudo dnf install -y la-capitaine-cursor-theme

gsettings set org.gnome.desktop.interface icon-theme 'WhiteSur-grey-dark' 
gsettings set org.gnome.desktop.interface cursor-theme 'capitaine-cursors' 


# install user-theme, dash-to-dock, pop shell, AppIndicator, and SoundOutputDeviceChooser
sudo dnf install gnome-extensions-app gnome-shell-extension-user-theme gnome-shell-extension-dash-to-dock gnome-shell-extension-pop-shell gnome-shell-extension-appindicator gnome-shell-extension-sound-output-device-chooser google-noto-fonts-common mscore-fonts-all fira-code-fonts xprop -y
# install netspeed
git clone https://github.com/AlynxZhou/gnome-shell-extension-net-speed.git ~/.local/share/gnome-shell/extensions/netspeed@alynx.one
gsettings set org.gnome.shell.extensions.pop-shell tile-by-default true
gsettings set org.gnome.shell.extensions.pop-shell hint-color-rgba "rgb(66,103,212)"
gsettings set org.gnome.shell.extensions.pop-shell gap-outer 0
gsettings set org.gnome.shell.extensions.pop-shell gap-inner 0

# font settings
gsettings set org.gnome.desktop.interface document-font-name 'Noto Sans 11'
gsettings set org.gnome.desktop.interface font-name 'Noto Sans 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Code Regular 11'
gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Noto Sans 11'

# other settings
gsettings set org.gnome.desktop.interface clock-format '24h'
gsettings set org.gnome.desktop.interface clock-show-date true
gsettings set org.gnome.desktop.interface clock-show-seconds true
gsettings set org.gnome.desktop.interface clock-show-weekday false

# recover maximize, minimize button
gsettings set org.gnome.desktop.wm.preferences button-layout ":minimize,maximize,close"

# set new windows centered
gsettings set org.gnome.mutter center-new-windows true

# hide desktop icons
gsettings set org.gnome.desktop.background show-desktop-icons false
