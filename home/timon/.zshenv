#########################
# Environment variables #
#########################
# Export PATH the zsh way
typeset -U path PATH
path=(
	~/bin
	~/.local/bin
	/usr/bin
	/usr/sbin
	/usr/local/bin
	/usr/local/sbin
	/opt/scripts
	$path)
export PATH

# Export EDITOR (SSH aware)
if [[ -n $SSH_CONNECTION ]]
then
  EDITOR='vim'
else
  EDITOR='nvim'
fi
export EDITOR

# Export other variables
export LANG=en_US.UTF-8
export LIBVIRT_DEFAULT_URI="qemu:///system"
export BROWSER="firefox"
export READER="zathura"
export TERMINAL="alacritty"
