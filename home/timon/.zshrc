#################
# Powerlevel10k #
#################
# Set the Powerline10k Theme
ZSH_THEME="powerlevel10k/powerlevel10k"

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Source the Powerline10k prompt -> To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh



###########
# History #
###########
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
zstyle :compinstall filename '/home/timon/.zshrc'
zstyle ':completion::complete:*' gain-privileges 1
compinit
_comp_options+=(globdots)



###########
# Aliases #
###########
# Sudo alias -> Allow aliases to be run with sudo
alias sudo='sudo '

# Dotfiles bare git repository alias
alias dotfiles='sudo git --git-dir=$HOME/.bare-repositories/dotfiles/git --work-tree=/'



###########
# Plugins #
###########
plugins=(
	git
	zsh-completions
	zsh-autosuggestions
	zsh-syntax-highlighting)



###################
# oh-my-zsh stuff #
###################
export ZSH="oh-my-zsh"
source $ZSH/oh-my-zsh.sh
