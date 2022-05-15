#########################
# Environment variables #
#########################
# Export PATH the zsh way -> path is a unique array and zsh syncs this array with PATH automatically
typeset -U path
path=(~/bin ~/.local/bin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin)
path+=(/opt/scripts)
path+=($path)
export PATH

# Export EDITOR (SSH aware)
if [[ -n $SSH_CONNECTION ]]
then
  EDITOR='vim'
else
  EDITOR='nvim'
fi
export EDITOR

# Export other environment variables
export LANG=en_US.UTF-8
export TERMINAL='alacritty'
export BROWSER='firefox'
export READER='zathura'
export FILEMANAGER='thunar'
export CM_LAUNCHER='rofi'
export LIBVIRT_DEFAULT_URI='qemu:///system'
export QT_QPA_PLATFORMTHEME='gtk2'
