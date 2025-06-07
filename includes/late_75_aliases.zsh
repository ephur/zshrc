# Default params for common utils
(which dust > /dev/null 2>&1) && alias du='dust -bd 1'
(which nvim > /dev/null 2>&1) && alias vi='nvim'
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

# Extra handy things
alias resrc='rm -rf "${ZSH_CACHE_DIR:?}/"* "${ZSH_CACHE_DIR:?}/".* 2>/dev/null; exec zsh'
alias gpthis='git push origin HEAD:$(git_current_branch)'
alias gpthisdown='git push downstream HEAD:$(git_current_branch)'
alias gpfthis='git push --force origin HEAD:$(git_current_branch)'
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
alias rmpyc='find . -name "*.pyc" -print -exec rm {} \;'
alias lsaws='aws ec2 describe-instances | jq '"'"'.Reservations[].Instances[] | select(.State.Code != 48) | [.LaunchTime, .State.Name, .PrivateIpAddress, (.Tags[]|select(.Key=="Name")|.Value)]'"'"
alias sudo='sudo '
alias ipsort='sort -t . -k 1,1n -k 2,2n -k 3,3n -k 4,4n'
[ -f /bin/zsh ] && alias rootme='_ZO_DATA_DIR=/root/.local/share/zoxide/ sudo -E /bin/zsh'
[ -f /usr/bin/zsh ] && alias rootme='_ZO_DATA_DIR=/root/.local/share/zoxide/ sudo -E /usr/bin/zsh'

# start tmux and attach or create session "default"
if (which tmux > /dev/null 2>&1); then
  alias ta='tmux new-session -A -s default'
fi

if (which dnf >/dev/null 2>&1); then
  alias di='sudo dnf install'
  alias dr='sudo dnf remove'
  alias ds='dnf search'
fi

# exa is a better ls
if (which exa >/dev/null 2>&1); then
  alias ls='exa'
  alias ll='exa -al --git'
  alias exanew='exa -al -s modified --git'
  alias exaold='exa -al -s modified --git -r'
fi

# but lsd is even better
if (which lsd >/dev/null 2>&1); then
  alias ls='lsd'
  alias ll='lsd -Al'
fi

# Want some more colors? OK!
if (which kubecolor >/dev/null 2>&1); then
  alias kubectl='kubecolor'
#  alias k='kubecolor --force-colors'
fi
if (which bat >/dev/null 2>&1); then
  export BAT_THEME="Dracula"
  alias cat='bat'
fi
alias cgrep='grep --color=always'
alias cless='less -R'



alias tf1='rm -f ${HOME}/bin/terraform && ln -s ${HOME}/bin/terraform1 ${HOME}/bin/terraform'
alias tf9='rm -f ${HOME}/bin/terraform && ln -s ${HOME}/bin/terraform9 ${HOME}/bin/terraform'
alias tf11='rm -f ${HOME}/bin/terraform && ln -s ${HOME}/bin/terraform11 ${HOME}/bin/terraform'
alias tf12='rm -f ${HOME}/bin/terraform && ln -s ${HOME}/bin/terraform12 ${HOME}/bin/terraform'
alias tf13='rm -f ${HOME}/bin/terraform && ln -s ${HOME}/bin/terraform13 ${HOME}/bin/terraform'
alias tf14='rm -f ${HOME}/bin/terraform && ln -s ${HOME}/bin/terraform14 ${HOME}/bin/terraform'
alias tf15='rm -f ${HOME}/bin/terraform && ln -s ${HOME}/bin/terraform15 ${HOME}/bin/terraform'

# Some platform specific items
case ${OSTYPE} in
  linux*)
    if [ ${IS_WINDOWS} -eq 0 ]; then
      alias pbcopy='xsel --clipboard --input'
      alias pbpaste='xsel --clipboard --output'
    fi
    ;;
esac

# copy some music formats from a file...
if [ -f "~/formats.txt" ]; then
  alias va="cat ~/formats.txt| tail -1 | tr -d '\n' | pbcopy"
  alias ca="cat ~/formats.txt| head -1 | tr -d '\n' | pbcopy"
fi

# Plexamp requires some silly handling on arch, even this doesn't allow it to bind media keys though :(
if [ -f "/usr/lib64/libcrypto.so.1.0.0" ] && [ -f "/usr/bin/Plexamp.AppImage" ]; then
  alias plexamp="LD_PRELOAD=/usr/lib64/libcrypto.so.1.0.0 /usr/bin/Plexamp.AppImage \
                 --disable-seccomp-filter-sandbox >/dev/null 2>&1 &"
fi
