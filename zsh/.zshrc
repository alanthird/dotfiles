# /etc/zshrc: .zshrc file for zsh(1).
#
# This file is sourced only for interactive shells. It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#
# Global Order: zshenv, zprofile, zshrc, zlogin

# meta key
#[[ $TERM = "xterm" ]] && bindkey -m

# urxvt sets $TERM to something zsh doesn't understand
if [[ $TERM = "rxvt-unicode" ]]; then
    bindkey "\e[5~" beginning-of-history # PageUp
    bindkey "\e[6~" end-of-history # PageDown
    bindkey "\e[2~" quoted-insert # Ins
    bindkey "\e[3~" delete-char # Del
    bindkey "\e[Z"  reverse-menu-complete # Shift+Tab
    bindkey "\e[7~" beginning-of-line # Home
    bindkey "\e[8~" end-of-line # End
fi

# prompt

case `hostname` in
    colt) PROMPTCOLOUR=4;;
    warhorse) PROMPTCOLOUR=3;;
    galloway*) PROMPTCOLOUR=5;;
    faroe) PROMPTCOLOUR=4;;
    *) PROMPTCOLOUR=1;;
esac

#PS1='%m:%/>'
PS1=$'%{\e[3'${PROMPTCOLOUR}$';1m%}%m%{\e[0;29m%}:%/>'
[[ $TERM == "vt420" ]] && PS1=$'\e[32;1m%m\e[0;29m:%/>'
#[[ $UID == 0 ]] && PS1='%m:%/ # '
[[ $UID == 0 ]] && PS1=$'%{\e[32;1m%}%m%{\e[0;29m%}:%/ # '
[[ $TERM == "vt420" && $UID == 0 ]] && PS1=$'\e[32;1m%m\e[0;29m:%/ # '

# History

HISTSIZE=200
HISTFILE=~/.zsh_history
SAVEHIST=200

autoload -U compinit
compinit

# Options

setopt AUTO_CD
setopt PROMPT_CR
setopt AUTO_MENU
setopt HIST_IGNORE_DUPS
setopt EXTENDED_GLOB

# Remove '/' from WORDCHARS so delete word, etc. work as I expect.
WORDCHARS=${WORDCHARS/\/}

# try to use the GPG agent if available
unset SSH_AGENT_PID
export SSH_AUTH_SOCK=$HOME/.gnupg/S.gpg-agent.ssh

# set up some hosts for hostname completion out of the
# ~/.zhosts file if it exists
[[ -a $HOME/.zhosts ]] && hosts=(${(f)"$(<$HOME/.zhosts)"})
zstyle ':completion:*:hosts' hosts $hosts

iplegal() {
if [[ $1 == ([1-9]||[1-9][0-9]||1[0-9][0-9]||[2[0-4][0-9]||25[0-5]).([0-9]||[1-9][0-9]||1[0-9][0-9]||[2[0-4][0-9]||25[0-5]).([0-9]||[1-9][0-9]||1[0-9][0-9]||[2[0-4][0-9]||25[0-5]).([0-9]||[1-9][0-9]||1[0-9][0-9]||[2[0-4][0-9]||25[0-5]) ]]
then
	echo legal
else
	echo illegal
fi
}

# Precmd, executed before every prompt
precmd() {
	# add any hostnames from the last command to the 
	# hostname completion array
	lastargs=(`fc -ln -1`)

	for stuff in $lastargs
	do
		if [[ $stuff == (*.org||*.com||*.net||*.edu||*.??~*.[[:digit:]][[:digit:]]) || `iplegal $stuff` == legal ]]
		then
			hosts=($hosts $stuff)
			zstyle ':completion:*:hosts' hosts $hosts
		fi
	done

	# set the xterm title bar
	[[ -t 1 ]] || return
	case $TERM in
			sun-cmd) print -Pn "\e]l%~\e\\"
				;;
		*xterm*|rxvt*|(dt|k|E)term) print -Pn "\e]2;%n@%m\a"
			;;
	vt420) print -Pn "\e]2;%n@%m\a"
			;;
	esac
}

# Aliases
case `uname -s` in
    "Darwin") alias ls='ls -G $@';;
    *) alias ls='ls --color $@';;
esac

# include any local configuration
[ -f ~/.zshrc-local ] && . ~/.zshrc-local
