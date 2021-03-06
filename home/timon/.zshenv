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

# XDG
export XDG_DATA_HOME=$HOME/.local/share
export XDG_CONFIG_HOME=$HOME/.config
export XDG_STATE_HOME=$HOME/.local/state
export XDG_CACHE_HOME=$HOME/.cache

# Home cleanup
export ZDOTDIR="$HOME"/.config/zsh
export HISTFILE="${XDG_STATE_HOME}"/bash/history
export CARGO_HOME="$XDG_DATA_HOME"/cargo
export CUDA_CACHE_PATH="$XDG_CACHE_HOME"/nv
export GNUPGHOME="$XDG_DATA_HOME"/gnupg
export GTK2_RC_FILES="$XDG_CONFIG_HOME"/gtk-2.0/gtkrc
export LESSHISTFILE="$XDG_CACHE_HOME"/less/history
export PARALLEL_HOME="$XDG_CONFIG_HOME"/parallel

# Default programs
export TERMINAL='alacritty'
export PAGER='less'
export EDITOR='nvim'
export VISUAL'nvim'
export BROWSER='firefox'
export READER='zathura'
export FILEMANAGER='thunar'
export CM_LAUNCHER='rofi'

# Export other environment variables
export LANG='en_US.UTF-8'
export LIBVIRT_DEFAULT_URI='qemu:///system'
export QT_QPA_PLATFORMTHEME='gtk2'
