###################
# oh-my-zsh stuff #
###################
export ZSH="oh-my-zsh"
ZSH_THEME="robbyrussell"
source $ZSH/oh-my-zsh.sh

###########
# Plugins #
###########
plugins=(
	git
	zsh-completions
	zsh-autosuggestions
	zsh-syntax-highlighting)

###########
# History #
###########
HISTFILE=~/.histfile
HISTSIZE=10000
SAVEHIST=10000

###############
# Keybindings #
###############
bindkey -e


##############
# completion #
##############
autoload -Uz compinit
compinit
_comp_options+=(globdots)
zstyle :compinstall filename '/home/timon/.zshrc'
zstyle ':completion:*' rehash true
zstyle ':completion::complete:*' gain-privileges 1

# Enable aliases to run with sudo
#alias sudo='sudo '

# Aliases
alias dotfiles='sudo /usr/bin/git --git-dir=/home/timon/.bare-repositories/dotfiles/git --work-tree=/'
