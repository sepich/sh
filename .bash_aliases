# git clone --bare https://github.com/sepich/sh.git $HOME/.cfg && alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME' && config config --local status.showUntrackedFiles no && config reset --hard
alias config='git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias sudobash='sudo env HOME=$HOME SSH_AUTH_SOCK=$SSH_AUTH_SOCK bash -l'
alias ls='ls --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias less='`find /usr/share/vim -name less.sh || less`'
# mouse support in screen
#alias mc='mc -x'

# docker
complete -F _known_hosts rdocker
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

# k8s
complete -o default -F __start_kubectl kubectl k kw ks
alias k='kubectl'
alias kw="watch -d kubectl"
alias ks="EDITOR='code -w' KUBE_EDITOR=~/bin/kube-secret-editor.py kubectl"
function kexec {
  local pod=`kubectl get po -o custom-columns=:metadata.name | grep "$1" | head -1` c
  [ "$2" ] && c="-c $2"
  kubectl exec -it $pod $c env COLUMNS=`tput cols` LINES=`tput lines` bash
}
function kgrep {
  kubectl get po -o wide -A | grep "$@" | column -t
}
# https://github.com/kubermatic/fubectl
alias _inline_fzf="fzf --multi --ansi -i -1 --height=50% --reverse -0 --header-lines=1 --inline-info"
alias _inline_fzf_nh="fzf --multi --ansi -i -1 --height=50% --reverse -0 --inline-info"
# choose container to see logs
klog() {
  local line_count=10
  if [[ $1 =~ ^[-]{0,1}[0-9]+$ ]]; then
    line_count="$1"
    shift
  fi

  local arg_pair=$(kubectl get po --all-namespaces | _inline_fzf | awk '{print $1, $2}')
  [ -z "$arg_pair" ] && printf "klog: no pods found. no logs can be shown.\n" && return
  local containers_out=$(echo "$arg_pair" | xargs kubectl get po -o=jsonpath='{.spec.containers[*].name} {.spec.initContainers[*].name}' -n | sed 's/ $//')
  local container_choosen=$(echo "$containers_out" |  tr ' ' "\n" | _inline_fzf_nh)
  kubectl logs -n ${arg_pair} -c "${container_choosen}" --tail="${line_count}" "$@"
}
# change context/namespace
_kns() {
    local res
    if [ $COMP_CWORD -eq 1 ]; then
        res='off -n '`kubectl config get-contexts -o name`
    elif [ $COMP_CWORD -eq 2 ]; then
        res=`kubectl get ns -o custom-columns=:metadata.name --no-headers`
    fi
    [ "$res" ] && COMPREPLY=(`compgen -W "$res" -- ${COMP_WORDS[COMP_CWORD]}`)
}
complete -F _kns kns
kns() {
    local ps1_cache='/tmp/.kns' context ns
    if [ "$1" == "off" ]; then
      [ -f $ps1_cache ] && rm $ps1_cache
      return
    elif [ "$1" == "-n" ]; then
      ns="$2"
      kubectl config set-context --current --namespace="${ns}"
      context=$(kubectl config current-context)
    else
      context="$1"
      kubectl config set current-context "${context}"
      ns="$(kubectl config get-contexts $context --no-headers | awk '{print $NF}')"
    fi
    [ "$ns" == "kube-system" ] && ns="k-s"
    echo -n "$context:$ns"$'\u2388 ' > $ps1_cache
}
