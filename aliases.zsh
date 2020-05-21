# Default params for common utils
(which dust > /dev/null 2>&1) && alias du='dust -bd 1'
(which nvim > /dev/null 2>&1) && alias vi='nvim'
alias df='df -kTh'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias mkdir='mkdir -p'
alias more='less'
alias grep='grep --color=auto'
alias i='or-infra'
alias plasma_save_session='qdbus org.kde.ksmserver /KSMServer org.kde.KSMServerInterface.saveCurrentSession'

# Extra handy things
alias resrc="source ~/.zshrc"
alias gpthis='git push origin HEAD:$(git_current_branch)'
alias gpfthis='git push --force origin HEAD:$(git_current_branch)'
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
alias rmpyc='find . -name "*.pyc" -print -exec rm {} \;'
alias lsaws='aws ec2 describe-instances | jq '"'"'.Reservations[].Instances[] | select(.State.Code != 48) | [.LaunchTime, .State.Name, .PrivateIpAddress, (.Tags[]|select(.Key=="Name")|.Value)]'"'"
alias rootme='sudo -E /bin/zsh'

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

alias tf9='rm -f ${HOME}/bin/terraform && ln -s ${HOME}/bin/terraform9 ${HOME}/bin/terraform'
alias tf11='rm -f ${HOME}/bin/terraform && ln -s ${HOME}/bin/terraform11 ${HOME}/bin/terraform'
alias tf12='rm -f ${HOME}/bin/terraform && ln -s ${HOME}/bin/terraform12 ${HOME}/bin/terraform'

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
