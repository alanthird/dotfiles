# Prevent loading ZSH startup from files /etc on macOS. The /etc/zprofile file
# screws around with PATH, so we want to avoid it, and instead manually load the
# files we care about. (Nabbed from https://github.com/jimeh/dotfiles/)
if [[ "$OSTYPE" == "darwin"* ]]; then
  # Disable loading startup files from /etc
  unsetopt GLOBAL_RCS

  # Setup default PATH just like /etc/zprofile does
  if [ -x "/usr/libexec/path_helper" ]; then
    eval $(/usr/libexec/path_helper -s)
  fi
fi

path=($path /home/alan/.local/bin /home/alan/.local/share/gem/ruby/3.0.0/bin)

export EMAIL="alan@idiocy.org"
export NAME="Alan Third"

if [ -n "$(which emacsclient)" ]; then
   export EDITOR='emacsclient -t -a emacs'
else
   export EDITOR='zile'
fi

export VISUAL=$EDITOR
export MAILREADER='/usr/bin/mutt'

#skip_global_compinit=1
