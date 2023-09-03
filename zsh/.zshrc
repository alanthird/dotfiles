# /etc/zshrc: .zshrc file for zsh(1).
#
# This file is sourced only for interactive shells. It
# should contain commands to set up aliases, functions,
# options, key bindings, etc.
#
# Global Order: zshenv, zprofile, zshrc, zlogin

# Emacs Tramp has trouble with the rest of the configuration.
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ ' && return

# prompt

if [ -t 1 ]; then
    PROMPTCOLOURS=(blue yellow magenta red cyan)
    PROMPTCOLOUR=${PROMPTCOLOURS[$((1 + (36#${HOST[1]} % ${#PROMPTCOLOURS})))]}

    PS1="%F{${PROMPTCOLOUR}}%m%f:%/%(!. #.>)"
else
    PS1='%m:%/%(!. #.>)'
fi

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

# Remove '/', '-' and '.' from WORDCHARS so delete word, etc. work as
# I expect.
WORDCHARS='*?_[]~=&;!#$%^(){}<>'

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
    [[ -t 1 ]] && print -Pn "\e]2;%n@%m\a"
}

# Aliases
case $OSTYPE in
    darwin*)
        alias ls='ls -G $@'
        ;;
    *)
        alias ls='ls --color $@'
        ;;
esac

# Turn on zmv.
autoload zmv

# Use C-xC-e to open the current command line in EDITOR.
autoload edit-command-line
zle -N edit-command-line
bindkey '\Cx\Ce' edit-command-line

# Copy the Emacs open-line command. It's not very different from just
# using M-return, but it leaves the cursor in the same place as Emacs.
function emacs-open-line () {
  BUFFER="${LBUFFER}
${RBUFFER}"
}
zle -N emacs-open-line
bindkey '\Co' emacs-open-line

# Key setup
if [[ $TERM = "rxvt"* ]]; then
    bindkey "\e\e[D" emacs-backward-word        # alt-left
    bindkey "\eOd" emacs-backward-word          # C-left
    bindkey "\e\e[C" emacs-forward-word         # alt-right
    bindkey "\eOc" emacs-forward-word           # C-right
elif [[ $TERM = "xterm"* ]]; then
    bindkey "\e[1;3D" emacs-backward-word
    bindkey "\e[1;5D" emacs-backward-word
    bindkey "\e[1;3C" emacs-forward-word
    bindkey "\e[1;5C" emacs-forward-word
fi

bindkey "$terminfo[kpp]" beginning-of-history    # PageUp
bindkey "$terminfo[knp]" end-of-history          # PageDown
bindkey "$terminfo[kcbt]"  reverse-menu-complete # Shift+Tab

# include any local configuration
[ -f ~/.zshrc-local ] && . ~/.zshrc-local
