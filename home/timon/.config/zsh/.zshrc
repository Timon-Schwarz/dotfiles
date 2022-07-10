#####################
# Environment check	#
#####################
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



###########
# History #
###########

[[ -f ~/.cache/zsh ]] || mkdir -p ~/.cache/zsh

# History settings
HISTFILE=~/.cache/zsh/histfile
HISTSIZE=10000
SAVEHIST=10000



############
# vim mode #
############
# Enable vim keybindings
bindkey -v
KEYTIMEOUT=1

# Change cursor shape for different vim modes
function zle-keymap-select () {
    case $KEYMAP in
        vicmd) echo -ne '\e[1 q';;      # block
        viins|main) echo -ne '\e[5 q';; # beam
    esac
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.



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



###############
# Keybindings #
###############
# Edit line in vim with ctrl-v
autoload edit-command-line; zle -N edit-command-line
bindkey '^v' edit-command-line

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char



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
# zsh-syntax-highlighting plugin
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# zsh-autosuggestions plugin
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
