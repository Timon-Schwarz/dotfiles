export ZSH="oh-my-zsh"
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh

plugins=(
	git
	zsh-completions
	zsh-autosuggestions
	zsh-syntax-highlighting)

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:/opt/scripts:$PATH"
fi

# Situation specific editor
if [[ -n $SSH_CONNECTION ]]; then
  EDITOR='vim'
else
  EDITOR='nvim'
fi

# Exports
export PATH
export EDITOR
export LANG=en_US.UTF-8
export LIBVIRT_DEFAULT_URI="qemu:///system"
export BROWSER="firefox"
export READER="zathura"
export TERMINAL="alacritty"

# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000
bindkey -e

zstyle :compinstall filename '/home/timon/.zshrc'
zstyle ':completion:*' rehash true
zstyle ':completion::complete:*' gain-privileges 1

autoload -Uz compinit
compinit
_comp_options+=(globdots)

# Enable aliases to run with sudo
#alias sudo='sudo '

# Aliases
alias dotfiles='sudo /usr/bin/git --git-dir=/home/timon/.bare-repositories/dotfiles/git --work-tree=/'
