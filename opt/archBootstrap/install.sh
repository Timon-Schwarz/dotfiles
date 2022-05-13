#!/bin/bash
set -e
set -x



#########################
#		Variables		#
#########################
# Set variables
TIMEZONE='Europe/Vienna'
MIRROR_COUNTRIES='Austria,Germany'
KEYMAP='de-latin1-nodeadkeys'
USERNAME=timon
ROOT_PASSWORD=''
IS_LAPTOP='true'
GIT_USERNAME='Timon-Schwarz'
GIT_EMAIL='timon.anmeldung@gmail.com'



#####################################
#		Installation criteria		#
#####################################
# Check system requirements
pacman -Sy \
	|| error "To run this script you need to be logged in as root on an arch system with internet connection. At least one does not seem to apply. Exiting..." \
	&& exit 1

# Check user requirements
[[ id "$USERNAME" ]] \
	|| error "The specified user "$USERNAME" does not exist. Please create it and then run the script again" \
	&& exit 1

# Check software requirements
# TODO: check if git is installed



#####################
#		Locale		#
#####################
# Generate needed locales
locale-gen



#########################
#		Keyboard		#
#########################
# Set keyboard layout
localectl set-keymap "$KEYMAP"



#########################
#		Timezone		#
#########################
# Set timezone
timedatectl set-timezone "$TIMEZONE"

# Sync hardware with system clock
hwclock --systohc

# Enable NTP
timedatectl set-ntp true



#####################
#		Users		#
#####################
# Set the root password (useful for system recovery when something breaks)
echo "root:$ROOT_PASSWORD" | chpasswd



#################
#		Git		#
#################
# Update git username
git config --global user.name "$GIT_USERNAME"

# Update git username
git config --global user.email "$GIT_EMAIL"



#########################
#		Mirror list		#
#########################
# Install reflector
pacman -S reflector

# Use reflector to update mirror list
reflector --country "$MIRROR_COUNTRIES" --protocol https --latest 30 --sort rate --save /etc/pacman.d/mirrorlist

# Update repositories and packages
pacman -Syu

# Periodically update mirror list
systemctl enable reflector.timer



#################################
#		Essential packages		#
#################################
# Install essential packages
pacman -S base base-devel linux linux-headers linux-firmware



#############################################
#		Configuration file housekeeping		#
#############################################
# Install xdg packages
pacman -S xdg-user-dirs xdg-utils

# Create xdg user dirs
xdg-user-dirs-update



#################
#		Git		#
#################
# Install git packages
pacman -S git git-filter-repo



#####################
#		Editors		#
#####################
# Install editor packages
pacman -S vim neovim



#############################
#		Package manager		#
#############################
# Install package manager packages
sudo pacman -S pacman-contrib

# Periodically remove old cached packages
systemctl enable paccache.timer



#####################################
#		Package distribution		#
#####################################
# Install flatpak packages
pacman -S flatpak

# Add flathub repository to flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo



#########################
#		AUR helper		#
#########################
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
rm -rf paru



#####################
#		Shell		#
#####################
# Install bash packages (if we ever need to use it)
pacman -S bash bash-completion

# Install zsh packages
pacman -S zsh zsh-theme-powerlevel10k

# Change default shell
chsh -s /bin/zsh root
chsh -s /bin/zsh $USERNAME



#########################
#		Shell tools		#
#########################
# Install locate packages
pacman -S plocate



#########################
#		File system		#
#########################
# Install virtual file system packages
pacman -S gvfs gvfs-mtp gvfs-smb

# Install btrfs packages
pacman -S btrfs-progs

# Install fat packages
pacman -S mtools dosfstools

# Install ntfs packags
pacman -S ntfs-3g



#########################
#		Bootloader		#
#########################
# Install bootloader packages
pacman -S grub grub-btrfs efibootmgr

# Build initramfs
mkinitcpio -P

# Setup grub
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=GRUB
grub-mkconfig -o /boot/grub/grub.cfg



#################################
#		Network file system		#
#################################
# Install nfs packages
pacman -S nfs-utils

# Install smb packages
pacman -S samba smbclient



#########################
#		Networking		#
#########################
# Install networking packages
pacman -S networkmanager wireless_tools wpa_supplicant inetutils dnsutils avahi nss-mdns bridge-utils dnsmasq bind openbsd-netcat

# Start NetworkManager on boot
systemctl enable NetworkManager

# Start mDNS service on boot
systemctl enable avahi-daemon



#################
#		VPN		#
#################
# Install Ike/IPsec VPN packages
pacman -S strongswan

# Install wireguard VPN packages
# TODO

# Install openVPN VPN packages
# TODO


#########################
#		Firewall		#
#########################
# Remove conflicting firewall packages
pacman -R iptables

# Install firewall packages
pacman -S iptables-nft firewalld

# Start firewall service on boot
systemctl enable firewalld



#################################
#		Remote management		#
#################################
# Install remote management packages
pacman -S openssh virt-viewer

# Enable ssh deamon
systemctl enable sshd



#####################
#		Sound		#
#####################
# Install sound packages
pacman -S alsa-utils wireplumber pipewire pipewire-alsa pipewire-pulse pipewire-jack sof-firmware

# Install sound control packages
pacman -S pavucontrol qpwgraph



#########################
#		Bluetooth		#
#########################
# Install Bluetooth packages
pacman -S bluez bluez-utils

# Start Bluetooth service on boot
systemctl enable bluetooth



#####################
#		Printer		#
#####################
# Install printer packages
pacman -S cups cups-pdf

# Start printing service on boot
systemctl enable cups.service



#################################################
#		Authentication and authorization		#
#################################################
# Install authentication and authorization packages
pacman -S polkit polkit-gnome



#####################
#		Graphic		#
#####################
# Install display server packages
pacman -S xorg xorg-server

# Install session initialization packages
pacman -S xorg-xinit

# Install intel packages
pacman -S intel-ucode xf86-video-intel

# Install nvidia packages
pacman -S nvidia nvidia-utils nvidia-settings

# Create nvidia xorg configuration
nvidia-xconfig



#############################
#		Window manager		#
#############################
# Install window manager packages
pacman -S awesome



#########################
#		Compositor		#
#########################
# Install compositor packages
pacman -S picom



#####################
#		Font		#
#####################
# Install normal font packages
pacman -S noto-fonts noto-fonts-emoji noto-fonts-extra ttf-dejavu ttf-liberation ttf-droid ttf-opensans

# Install nerd font packages
paru -S nerd-fonts-jetbrains-mono



#################################
#		Terminal emulator		#
#################################
# Install terminal emulator packages
pacman -S alacritty



#############################
#		Power control		#
#############################
# Install power control packages
pacman -S acpi acpi_call acpid

# Enable power control service
systemctl enable acpid

# Check if the system is a laptop
if [ "$IS_LAPTOP" = true ]; then
	# Install laptop power control packages
	pacman -S tlp

	# Enable laptop power control service
	systemctl enable tlp
fi

# Install graphical power control package
# TODO



#################################
#		Screen management		#
#################################
# Install screen management packages
pacman -S arandr



#############################
#		Session locker		#
#############################
# Install session locker packages
# TODO


#####################
#		Menu		#
#####################
# Install menu packages
pacman -S dialog rofi

# Install rofi-dmenu compatibility packages
paru -S rofi-dmenu



#####################
#		Browser		#
#####################
# Install browser packages
pacman -S firefox



#########################
#		Icon theme		#
#########################
# Install icon theme packages
pacman -S papirus-icon-theme



#########################
#		Tray icon		#
#########################
# Install network tray icon packages
pacman -S network-manager-applet

# Install sound try icon packages
paru -S pnmixer



#############################
#		File manager		#
#############################
# Install grahical file manger packages # TODO: maybe switch?
pacman -S thunar thunar-archive-plugin thunar-volman



#####################
#		Archive		#
#####################
# Install graphical archive packages
pacman -S xarchiver



#############################
#		Image viewer		#
#############################
# Install image viewer packages
pacman -S feh



#########################
#		Clipboard		#
#########################
# Install clipboard packages
pacman -S xclip clipmenu

# Start clipmenud on boot
systemctl --user enable clipmenud



#########################
#		Screenshot		#
#########################
# Install screenshot packages
pacman -S flameshot



#########################
#		Markdown		#
#########################
# Install markdown packages
# TODO



#####################
#		Latex		#
#####################
# Install latex packages
# TODO



#############################
#		Communication		#
#############################
# Install communication packages
pacman -S dicord



#############################
#		Virtualization		#
#############################
# Install qemu/kvm vitalization packages
pacman -S qemu-full edk2-ovmf vde2 dmidecode

# Install virtualization managers
pacman -S virtsh virt-manager

# Enable virtualization management service
systemctl enable libvirtd

# Give user access to virtualization management
usermod -aG libvirt "$USERNAME"



#####################
#		Backup		#
#####################
# Install backup packages
pacman -S snapper snap-pac rsync

# Remove the /.snapshots directory so snapper can recreate it
umount /.snapshots
sudo rmdir /.snapshots

# Setup snapper from template configuration
sudo snapper -c root create-config -t /usr/share/snapper/custom /

# Snapper creates its own .snapshots subvolume
# We can delete it because we are using @.snpshots instead
btrfs subvolume delete /.snapshots

# Ensure that everyone can read the snapshots
chmod a+rx /.snapshots

# Give the user snapshot permissions
groupadd snapshot
usermod -aG snapshot "$USERNAME"

# Automatically update snapshot entries in grub
systemctl enable grub-btrfs.path

# Periodically create snapshots
systemctl enable snapper-timeline.timer

# Periodically remove old snapshots
systemctl enable snapper-cleanup.timer



################
# Finalization #
################
echo 'Done!'
echo 'Type umount -a and exit. After that you can reboot into your new system.'
echo 'Type startx after the reboot to start your graphical environment'
