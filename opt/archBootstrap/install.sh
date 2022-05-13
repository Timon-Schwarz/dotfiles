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



#####################################
#		Installation criteria		#
#####################################
# Check system requirements
pacman -Sy \
	|| error "To run this script you need to be logged in as root on an arch system with internet connection. At least one does not seem to apply. Exiting..." \
	&& exit 1

# Check prerequisites
[[ id "$USERNAME" ]] \
	|| error "The specified user "$USERNAME" does not exist. Please create it and then run the script again" \
	&& exit 1



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
pacman -S base-devel linux-headers



#############################################
#		Configuration file housekeeping		#
#############################################
# Install xdg packages
pacman -S xdg-user-dirs xdg-utils

# Create xdg user dirs
xdg-user-dirs-update



#############################
#		Power control		#
#############################
# Install power control packages
acpi acpi_call acpid git

# Enable power control service
systemctl enable acpid

# Check if the system is a laptop
if [ "$IS_LAPTOP" = true ]; then
	# Install laptop power control packages
	pacman -S tlp

	# Enable laptop power control service
	systemctl enable tlp
fi



#########################
#		File system		#
#########################
# Install virtual file system packages
pacman -S gvfs gvfs-mtp gvfs-smb

# Install btrfs packages
btrfs-progs

# Install fat packages
mtools dosfstools

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



#####################
#		Shell		#
#####################
# Install bash packages (if we ever need to use it)
pacman -S bash-completion

# Install zsh packages
pacman -S zsh

# Change default shell
chsh -s /bin/zsh root
chsh -s /bin/zsh $USERNAME



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
pacman -S networkmanager network-manager-applet dialog wireless_tools wpa_supplicant inetutils dnsutils avahi nss-mdns inetutils bridge-utils dnsmasq openbsd-netcat

# Start NetworkManager on boot
systemctl enable NetworkManager

# Start mDNS service on boot
systemctl enable avahi-daemon



#########################
#		Firewall		#
#########################
# Remove conflicting firewall packages
pacman -R iptables

# Install firewall packages
pacman -S iptables-nft firewalld

# Start firewall service on boot
systemctl enable firewalld



#####################
#		Sound		#
#####################
# Install sound packages
pacman -S alsa-utils wireplumber pipewire pipewire-alsa pipewire-pulse pipewire-jack sof-firmware



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



#################################
#		Remote management		#
#################################
# Install remote management packages
pacman -S openssh virt-viewer

# Enable ssh deamon
systemctl enable sshd



#####################
#		Graphic		#
#####################
# Install window manager packages
pacman -S xorg xorg-server

# Install session initialization packages
pacman -S xorg-xinit

# Install intel packages
pacman -S intel-ucode xf86-video-intel

# Install nvidia packages
pacman -S nvidia nvidia-utils nvidia-settings

# Install window manager
pacman -S awesome



#####################
#		Browser		#
#####################
# Install browser packages
pacman -S firefox



#################################################
#		Authentication and authorization		#
#################################################
# Install authentication and authorization packages
pacman -S polkit



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