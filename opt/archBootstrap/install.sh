#!/bin/bash
set -e
set -x



#########################
#		Variables		#
#########################
# Set variables
CURRENT_USERNAME='timon'	# Do not change this
TIMEZONE='Europe/Vienna'
MIRROR_COUNTRIES='Austria,Germany'
VCONSOLE_KEYBOARD_LAYOUT='de-latin1-nodeadkeys'
X11_KEYBOARD_LAYOUT='at'
X11_KEYBOARD_VARIANT='nodeadkeys'
X11_KEYBOARD_MODEL='pc105'
USERNAME=timon
ROOT_PASSWORD=''
IS_LAPTOP='true'
GIT_USERNAME='Timon-Schwarz'
GIT_EMAIL='timon.anmeldung@gmail.com'
GIT_REMOTE_DOTFILE_REPOSITORY='git@github.com:Timon-Schwarz/dotfiles.git'
# This should be the memory of your Windows VM
# divided by your hugepagesize. It is then recommended to add some more pages for headroom
# Use "grep Hugepagesize /proc/meminfo" to determine hugepagesize
NR_HUGEPAGES='4200'



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

# Check if home directory is empty
[[ rmdir "/home/$USERNAME" ]] \
	|| error "The home directory of $USERNAME should be empty. Please remove all files and then run the script again"
	&& exit 1



#########################################
#		Move to current home dir		#
#########################################
mv "/home/$CURRENT_USERNAME" "/home/$USERNAME"



#####################
#		Locale		#
#####################
# Generate needed locales
locale-gen



#########################
#		Keyboard		#
#########################
# Set keyboard layout
localectl set-x11-keymap --no-convert "$X11_KEYBOARD_LAYOUT" "$X11_KEYBOARD_MODEL" "$X11_KEYBOARD_VARIANT"
localectl set-keymap --no-convert "$VCONSOLE_KEYBOARD_LAYOUT"



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

# Update remote repository
sed -i "s/\(url\s=\s\)\(.*\)/\1$GIT_REMOTE_DOTFILE_REPOSITORY/" "/home/$USERNAME/.bare-repositories/dotfiles/git/config"



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



#########################
#		AUR helper		#
#########################
git clone https://aur.archlinux.org/paru.git
cd paru
makepkg -si
rm -rf paru



#####################################
#		Package distribution		#
#####################################
# Install flatpak packages
pacman -S flatpak

# Add flathub repository to flatpak
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

# Install snap packages
paru -S snapd

# Start snap daemon when needed
systemctl enable --now snapd.socket



#####################
#		Shell		#
#####################
# Install bash packages (if we ever need to use it)
pacman -S bash bash-completion

# Install zsh packages
pacman -S zsh zsh-theme-powerlevel10k zsh-syntax-highlighting

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
pacman -S mesa intel-ucode vulkan-intel

# Install nvidia packages
pacman -S nvidia nvidia-utils nvidia-settings

# Check if the system is a laptop
if [ "$IS_LAPTOP" = true ]; then
	# Install hybrid graphics packages
	pacman -S nvidia-prime
fi



#############################
#		Window manager		#
#############################
# Install window manager packages
pacman -S awesome



#########################
#		Auto login		#
#########################
# Auto login is already configured after cloning
# But the username is probably wrong so we update it
sed "s/\(--autologin\s\)\(\w*\)\(\s\)/\1$USERNAME\3/" /etc/systemd/system/getty@tty1.service.d/autologin.conf



#########################
#		Compositor		#
#########################
# Install compositor packages
pacman -S picom



#########################
#		Toolkits		#
#########################
# Install GTK toolkit packages
pacman -S gtk2 gtk3 gtk4 gtk-engine-murrine

# Install QT toolkit packages
pacman -S qt5-base qt6-base qt5-svg qt6-svg

# Install QT GTK style packages
paru -S qt5-styleplugins qt6gtk2



#####################
#		Font		#
#####################
# Install normal font packages
pacman -S noto-fonts noto-fonts-emoji noto-fonts-extra ttf-dejavu ttf-liberation ttf-droid ttf-opensans ttf-roboto ttf-ubuntu-font-family cantarell-conts

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
	pacman -S auto-cpufreq

	# Enable laptop power control service
	systemctl enable auto-cpufreq
fi



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
#		Torrent		#
#####################
# Install torrent packages
pacman -S qbittorrent



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

# Install hard coded tray icons fix packages
paru -S hardcode-tray


#########################
#		Tray icon		#
#########################
# Install network tray icon packages
pacman -S network-manager-applet

# Install sound try icon packages
pacman -S volumeicon



#############################
#		File manager		#
#############################
# Install grahical file manger packages
pacman -S pcmanfm



#####################
#		Archive		#
#####################
# Install graphical archive packages
pacman -S xarchiver



#####################
#		Reader		#
#####################
# Install reader packages
pacman -S zathura zathura-pdf-poppler



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



#############################
#		Notifications		#
#############################
# AwesomeWM comes with naughty as notification server
# No need to use something else



#########################
#		Backlight		#
#########################
# Install backlight control packages
paru -S brillo

# Set minimum backlight
brillo -c -S 2

# Add user to video group to allow backlight control
usermod -aG video "$USERNAME"



#############################
#		Screen capture		#
#############################
# Install screenshot packages
pacman -S flameshot

# Install screen recorder packages
pacman -S obs-studio

# Install video encoder packages
pacman -S handbrake



#########################
#		Markdown		#
#########################
# Install markdown packages
# TODO



#####################
#		LaTeX		#
#####################
# Install LaTeX packages
pacman -S texive-most



#############################
#		Communication		#
#############################
# Install communication packages
pacman -S dicord
paru -S teams



#################################
#		Reduced eye strain		#
#################################
# Install red light reduction packages
pacman -S redshift



#############################
#		Partitioning		#
#############################
# Install partitioning packages
pacman -S gparted



#########################
#		Database		#
#########################
# Install database packages
pacman -S mariadb



#########################
#		Monitoring		#
#########################
# Install monitoring packages
pacman -S htop nvtop



#################################
#		KVM virtualization		#
#################################
# Install qemu/kvm vitalization packages
pacman -S qemu-full edk2-ovmf vde2 dmidecode

# Install virtualization managers
pacman -S virt-manager

# Enable virtualization management service
systemctl enable libvirtd

# Give user access to virtualization management
usermod -aG libvirt "$USERNAME"
usermod -aG kvm "$USERNAME"



#####################################
#		VMware virtualization		#
#####################################
# Install VMware Workstation packages
paru -S vmware-workstation

# Enable VMware services
systemctl enable vmware-networks
systemctl enable vmware-usbarbitrator



#########################
#		Windows VM		#
#########################
# Update the hugepageszize
sed -i "s/\(vm.nr_hugepages\s=\s\)\(.*\)/\1$NR_HUGEPAGES/" "/etc/sysctl.d/40-hugepage.conf"



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
sudo snapper -c home create-config -t /usr/share/snapper/custom /home

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
echo 'Some files need to be added manually because they are not save for the internet.
	This includes:
	- /etc/swanctl/conf.d/secrets.conf
	- /etc/ssh_host_*'
