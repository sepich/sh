[ -z "$PS1" ] && return
export GREP_OPTIONS='--color=auto'

shopt -s checkjobs
shopt -s histappend
HISTCONTROL=ignoredups
HISTSIZE=1000
HISTFILESIZE=10000
PROMPT_COMMAND="history -a; $PROMPT_COMMAND"

if type __git_ps1 >/dev/null 2>&1; then
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\e[33;1m$(__git_ps1 "(%s)")\[\033[00m\]\$ '
else
  PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;36m\]\w\[\033[00m\]\$ '
fi

man() { env LESS_TERMCAP_md=$(printf "\e[1;32m") LESS_TERMCAP_me=$(printf "\e[0m") man "$@"; }
if [ -f ~/.bash_aliases ]; then . ~/.bash_aliases; fi
if [ -f /etc/bash_completion ] && ! shopt -oq posix; then . /etc/bash_completion; fi
