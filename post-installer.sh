#!/bin/bash

sudo dnf update
sudo dnf upgrade --refresh
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
sudo dnf install dnf-plugins-core -y
sudo flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

# install apps (vscode, chrome, brave, gnome-tweaks, htop, neofetch, vim, open-jdk, R, flutter)
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc

sudo dnf config-manager --set-enabled google-chrome
sudo dnf makecache

sudo dnf install -y git dnf-plugins-core clang cmake ninja-build pkg-config gtk3-devel xz-devel google-chrome-stable brave-browser htop neofetch vim-enhanced gnome-tweaks  java-latest-openjdk R rstudio-desktop code
git clone https://github.com/flutter/flutter.git -b stable ~/flutter
# ~/flutter/bin/flutter precache
~/flutter/bin/flutter doctor

# install media codecs
sudo dnf install gstreamer1-plugins-{bad-\*,good-\*,base} gstreamer1-plugin-openh264 gstreamer1-libav --exclude=gstreamer1-plugins-bad-free-devel -y
sudo dnf install lame\* --exclude=lame-devel -y
sudo dnf group upgrade --with-optional Multimedia -y

# install dracula theme
sudo git clone https://github.com/dracula/gtk.git /usr/share/themes/Dracula
gsettings set org.gnome.desktop.interface gtk-theme 'Dracula' 
gsettings set org.gnome.desktop.wm.preferences theme 'Dracula'

# install pop shell, AppIndicator, and SoundOutputDeviceChooser
sudo dnf install gnome-shell-extensions gnome-shell-extension-dash-to-dock gnome-shell-extension-pop-shell gnome-shell-extension-appindicator gnome-shell-extension-sound-output-device-chooser google-noto-fonts-common mscore-fonts-all fira-code-fonts xprop -y
git clone https://github.com/AlynxZhou/gnome-shell-extension-net-speed.git ~/.local/share/gnome-shell/extensions/netspeed@alynx.one
gsettings set org.gnome.shell.extensions.pop-shell tile-by-default true
gsettings set org.gnome.shell.extensions.pop-shell hint-color-rgba "rgb(66,103,212)"
gsettings set org.gnome.shell.extensions.pop-shell gap-outer 0
gsettings set org.gnome.shell.extensions.pop-shell gap-inner 0

# font settings
gsettings set org.gnome.desktop.interface document-font-name 'Noto Sans 11'
gsettings set org.gnome.desktop.interface font-name 'Noto Sans 11'
gsettings set org.gnome.desktop.interface monospace-font-name 'Fira Mono Regular 11'
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
