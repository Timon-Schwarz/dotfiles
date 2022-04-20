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
# Completion #
##############
autoload -Uz compinit
compinit
_comp_options+=(globdots)
zstyle :compinstall filename '/home/timon/.zshrc'
zstyle ':completion:*' rehash true
zstyle ':completion::complete:*' gain-privileges 1



###########
# Aliases #
###########
# Sudo alias -> Allow aliases to be run with sudo
alias sudo='sudo '

# Other aliases
alias dotfiles='sudo git --git-dir=/home/timon/.bare-repositories/dotfiles/git --work-tree=/'
