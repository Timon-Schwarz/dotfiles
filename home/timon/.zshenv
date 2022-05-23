#########################
# Environment variables #
#########################
# Export PATH the zsh way
# path is a unique array and zsh syncs this array with PATH automatically
typeset -U path
path=(~/bin ~/.local/bin /usr/bin /usr/sbin /usr/local/bin /usr/local/sbin)
path+=(/opt/scripts)
path+=($path)
export PATH

# Export EDITOR and VISUAL (SSH aware)
if [ -n "$SSH_CONNECTION" ]; then
  EDITOR='vim'
  VISUAL='vim'
else
  EDITOR='nvim'
  VISUAL='nvim'
fi
export EDITOR
export VISUAL

# Default programs
export TERMINAL='alacritty'
export PAGER='less'
export BROWSER='firefox'
export READER='zathura'
export FILEMANAGER='thunar'
export CM_LAUNCHER='rofi'

# Export other environment variables
export LANG='en_US.UTF-8'
export LIBVIRT_DEFAULT_URI='qemu:///system'
export QT_QPA_PLATFORMTHEME='gtk2'
