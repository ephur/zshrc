# Default params for common utils
alias ls='ls -hF --color=auto'
alias du='du -kh'
alias df='df -kTh'
alias rm='rm -i'
alias mv='mv -i'
alias cp='cp -i'
alias mkdir='mkdir -p'
alias more='less'
alias h='history'
alias j='jobs -l'
alias which='type -a'
alias grep='grep --color=auto'

# Extra handy things
alias resrc="source ~/.zshrc"
alias gpthis='git push origin HEAD:$(git_current_branch)'
alias gpfthis='git push --force origin HEAD:$(git_current_branch)'
alias path='echo -e ${PATH//:/\\n}'
alias libpath='echo -e ${LD_LIBRARY_PATH//:/\\n}'
alias rmpyc='find . -name "*.pyc" -print -exec rm {} \;'
alias lsaws='aws ec2 describe-instances | jq '"'"'.Reservations[].Instances[] | select(.State.Code != 48) | [.LaunchTime, .State.Name, .PrivateIpAddress, (.Tags[]|select(.Key=="Name")|.Value)]'"'"
alias rootme='sudo -E /bin/zsh'

# Some platform specific items
case `uname` in
    Linux)
        alias pbcopy='xsel --clipboard --input'
        alias pbpaste='xsel --clipboard --output'
        alias tf9='sudo rm /usr/local/bin/terraform && sudo ln -s /usr/local/bin/terraform9 /usr/local/bin/terraform'
        alias tf11='sudo rm /usr/local/bin/terraform && sudo ln -s /usr/local/bin/terraform11 /usr/local/bin/terraform'
    ;;
    Darwin)
        alias tf9='rm /usr/local/bin/terraform && ln -s /usr/local/bin/terraform9 /usr/local/bin/terraform'
        alias tf11='rm /usr/local/bin/terraform && ln -s /usr/local/bin/terraform11 /usr/local/bin/terraform'
    ;;
esac
