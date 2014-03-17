[ -z "$PS1" ] && return
export GREP_OPTIONS='--color=auto'
HISTCONTROL=ignoreboth; shopt -s histappend; PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\$ '
man() { env LESS_TERMCAP_md=$(printf "\e[1;32m") LESS_TERMCAP_me=$(printf "\e[0m") man "$@"; }
if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases;fi
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then . /etc/bash_completion;fi
