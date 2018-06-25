# git clone --bare https://github.com/sepich/sh.git $HOME/.cfg && alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME' && config config --local status.showUntrackedFiles no && config reset --hard
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias sudobash='sudo env HOME=$HOME SSH_AUTH_SOCK=$SSH_AUTH_SOCK bash -l'
alias ls='ls --color=auto --group-directories-first'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias grep='grep --color=auto'
alias less='`find /usr/share/vim -name less.sh || less`'
alias k='kubectl'
# mouse support in screen
alias mc='mc -x'

# docker
alias dclean='docker ps -aqf status=exited | xargs -r docker rm'
function dps {
  docker ps --format "table {{.Names}}\\t{{.Status}}\\t{{.Image}}\\t{{.Ports}}" $@ |
  sed '
    s/ seconds/s/g;
    s/ minutes/m/g;
    s/ hours/h/g;
    s/ days/d/g;
    s/ weeks/w/g;
    s/About a minute/1m/g;
    s/About an hour/1h/g;
    s/Exited (\([0-9]\+\)) \(.*\)ago/exit(\1)~\2/;
    s/->/→/g;
    s/ [a-z0-9\._-]\+\/\([a-z0-9\._-]\+\/\)\?\([a-z0-9\._-]\+\:[a-z0-9\._-]\+\) /®\/\2/g;
    s/0\.0\.0\.0:/:/g;
    s/(healthy)/\*/g;
    s/^\([a-z0-9_-]\+\.\([0-9]\+\.\)\?\)\(...\)[a-z0-9\.]\+/\1\3 …/g;
    s/  \+/;/g
  ' | column -s\; -t | sed "1s/.*/\x1B[1m&\x1B[m/" | sort | sed "s/\(\*\)/\x1B[32m\1\x1B[m/g"
}
function dexec {
  local args="-e COLUMNS=`tput cols` -e LINES=`tput lines`"
  [ "$http_proxy" ] && args="$args -e http_proxy=$http_proxy -e https_proxy=$https_proxy -e no_proxy=$no_proxy"
  docker exec -itu root $args `docker ps -qf name=$@ | head -1` /bin/bash
}
