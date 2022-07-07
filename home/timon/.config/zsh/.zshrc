#################################
#		Environment check		#
#################################
# If not running interactively, don't do anything
[[ $- != *i* ]] && return



########################
# Powerlevel10k plugin #
########################
# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
	source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Check if criteria for using Powerline10k prompt is met
if zmodload zsh/terminfo && (( terminfo[colors] >= 256 )); then
	# Source the theme
	source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme

	# Source the prompt
	[[ -f "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.p10k.zsh" ]] && source "${XDG_CONFIG_HOME:-$HOME/.config}/zsh/.p10k.zsh"
fi



#############################################
#		zsh-syntax-highlighting plugin		#
#############################################
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh



###########
# History #
###########
# Create destination folder for the history file if it does not exist
[[ -f ~/.cache/zsh ]] || mkdir -p ~/.cache/zsh

# History settings
HISTFILE=~/.cache/zsh/histfile
HISTSIZE=10000
SAVEHIST=10000



###############
# Keybindings #
###############
# Enable vi keybindings
bindkey -e

# Edit line in vim with ctrl-v
autoload edit-command-line; zle -N edit-command-line
bindkey '^v' edit-command-line



##############
# Completion #
##############
autoload -Uz compinit
zmodload zsh/complist
zstyle ':completion:*' menu select
zstyle :compinstall filename "$HOME/.zshrc"
zstyle ':completion::complete:*' gain-privileges 1
compinit -d "$XDG_CACHE_HOME"/zsh/zcompdump-"$ZSH_VERSION"
_comp_options+=(globdots)



###########
# Aliases #
###########
# Sudo alias -> Allow aliases to be run with sudo
alias sudo='sudo '

# Dotfiles bare git repository alias
alias dotfiles="sudo git --git-dir=$HOME/.bare-repositories/dotfiles/git --work-tree=/"



###########
# Plugins #
###########
#plugins=(
#	git
#	zsh-completions
#	zsh-autosuggestions
#	zsh-syntax-highlighting)
