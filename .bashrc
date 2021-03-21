#Non interactive shell
[ -z "$PS1" ] && return
[ -z "$BASH_VERSION" ] && return

#History
shopt -s checkjobs
shopt -s histappend
HISTCONTROL=ignoredups
HISTSIZE=1000
HISTFILESIZE=10000
HISTIGNORE='exit:cd:ls:bg:fg:history'
PROMPT_DIRTRIM=5  # truncate long paths to ".../foo/bar/baz"
PROMPT_COMMAND='history -a'

#Colorizing
man() { env LESS_TERMCAP_md=$(printf "\e[1;32m") LESS_TERMCAP_me=$(printf "\e[0m") man "$@"; }
if [ ! -f ~/.nanorc ]; then
  echo -e "set matchbrackets \"(<[{)>]}\"\nset tabsize 2\nset tabstospaces" > ~/.nanorc
  for I in /usr/share/nano/*.nanorc; do echo "include $I">>~/.nanorc; done
fi

#Hooks
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then . /etc/bash_completion; fi
if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi

#UTF8
export LANG="en_US.UTF-8"
export LC_ALL="en_US.UTF-8"

#Prompt
__kns() { [ -r /tmp/.kns ] && cat /tmp/.kns; }
if type __git_ps1 >/dev/null 2>&1; then
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[33;1m\]$(__git_ps1 "(%s)")\[\033[00m\]\$ '
else
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\$ '
fi
PS1='\[\033];\h\007\]$(__kns)'$PS1 #update window title

[ -d "$HOME/.local/bin" ] && PATH="$HOME/.local/bin:$PATH"  # pip --user
[ -f ~/.bashrc.local ] && source ~/.bashrc.local
