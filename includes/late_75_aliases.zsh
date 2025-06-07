# Default params for common utils
command -v dust &>/dev/null && alias du='dust -bd 1'
command -v nvim &>/dev/null && alias vi='nvim'
alias df='df -kTh'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias mkdir='mkdir -p'
alias more='less -R'
alias grep='grep --color=auto'
alias plasma_save_session='qdbus org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.saveCurrentSession'
alias ssh='TERM=xterm-256color ssh'
alias dirs='dirs -v'
alias rmpyc='find . -name "*.pyc" -print -exec rm {} \;'
alias lsaws='aws ec2 describe-instances | jq '"'"'.Reservations[].Instances[] | select(.State.Code != 48) | [.LaunchTime, .State.Name, .PrivateIpAddress, (.Tags[]|select(.Key=="Name")|.Value)]'"'"
alias sudo='sudo '
alias ipsort='sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n'

# Git aliases
alias gpthis='git push origin HEAD:$(git_current_branch)'
alias gpthisdown='git push downstream HEAD:$(git_current_branch)'
alias gpfthis='git push --force origin HEAD:$(git_current_branch)'

# Make it easier to read zsh paths and library paths
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'


# Avoid breaking zoxide when running as root
[ -f /bin/zsh ] && alias rootme='_ZO_DATA_DIR=/root/.local/share/zoxide/ sudo -E /bin/zsh'
[ -f /usr/bin/zsh ] && alias rootme='_ZO_DATA_DIR=/root/.local/share/zoxide/ sudo -E /usr/bin/zsh'

# tmux alias
if command -v tmux &>/dev/null && [[ -z ${TMUX} ]]; then
  alias tmux='tmux -2'
  alias t='tmux attach-session -t default || tmux new-session -s default'
  alias tnew='tmux new-session -s default'
  alias tlist='tmux list-sessions'
  alias tk='tmux kill-session -t default'
else
  alias t='echo "tmux not found or already in a session"'
fi

# Package management aliases
if command -v dnf &>/dev/null; then
  alias di='sudo dnf install'
  alias dr='sudo dnf remove'
  alias ds='dnf search'
fi

# Smart ls aliasing
if command -v lsd &>/dev/null; then
  alias ls='lsd'
  alias ll='lsd -Al'
elif command -v exa &>/dev/null; then
  alias ls='exa'
  alias ll='exa -al --git'
  alias exanew='exa -al -s modified --git'
  alias exaold='exa -al -s modified --git -r'
fi

# Want some more colors? OK!
if command -v kubecolor &>/dev/null; then
  alias kubectl='kubecolor'
#  alias k='kubecolor --force-colors'
fi
if command -v bat &>/dev/null; then
  export BAT_THEME="Dracula"
  alias cat='bat'
fi
alias cgrep='grep --color=always'
alias cless='less -R'

# Some platform specific items
case ${OSTYPE} in
  linux*)
    if [ ${IS_WSL} -eq 0 ]; then
      alias pbcopy='xsel --clipboard --input'
      alias pbpaste='xsel --clipboard --output'
    fi
    ;;
esac
