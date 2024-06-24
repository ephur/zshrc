# If Homebrew is installed, use its completions and add it to the path
[[ -f /opt/homebrew/bin/brew ]] && export PATH=${PATH}:/opt/homebrew/bin && FPATH=$(brew --prefix)/share/zsh/site-functions:$FPATH

# Setup pyenv/before plugins that require python
 if [ "-d ${HOME}/.pyenv" ]; then
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
  export PYENV_ROOT="${HOME}/.pyenv"
  export PATH="${PYENV_ROOT}/bin:${PATH}"
  eval "$(pyenv init --path)"
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# setup for goenv (requires goenv 2+)
if [ "-d ${HOME}/.goenv" ]; then
    export GOENV_GOPATH_PREFIX="${HOME}/Projects/go"
    export GOENV_ROOT="${HOME}/.goenv"
    export PATH="${GOENV_ROOT}/bin:${PATH}"
    eval "$(goenv init -)"
    if [ "-f ${HOME}/.goenv/completions/goenv.zsh" ]; then
        . ${HOME}/.goenv/completions/goenv.zsh
    fi
    #export PATH="${GOROOT}/bin:$PATH"
    #export PATH="${GOPATH}/bin:$PATH"
fi

# setup for rbenv
if [ -d "${HOME}/.rbenv" ]; then
  export PATH="${HOME}/.rbenv/bin:${PATH}"
  eval "$(rbenv init - zsh)"
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
if [ -f "$HOME/.rvm/scripts/rvm" ]; then
  source "$HOME/.rvm/scripts/rvm"
  export PATH="$PATH:$HOME/.rvm/bin"
fi

# KREW (kubectl plugin manager)
if which kubectl-krew >/dev/null 2>&1; then
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

# CircleCI CLI
if which circleci > /dev/null 2>&1; then
  export CIRCLECI_CLI_SKIP_UPDATE_CHECK=1
  if ! [[ -f "${ZSH_CACHE_DIR}/circleci_completion.zsh" ]]; then
    circleci completion zsh > "${ZSH_CACHE_DIR}/circleci_completion.zsh"
  fi
  eval $(cat "${ZSH_CACHE_DIR}/circleci_completion.zsh")
  compdef circleci
fi

# Get 1password completions
if which op >/dev/null 2>&1; then
  local op=$(which op | head -1)
  local shl=$(echo ${SHELL} | awk -F/ '{print $NF}')
  eval "$($op completion $shl)"
  compdef _op op
fi

# Use zoxide for dir history if it's available
# if which zoxide >/dev/null 2>&1; then
#   # export _ZO_DATA_DIR="${HOME}/.zoxide_data_dir}"
#   export _ZO_ECHO=1
#   export _ZO_FZF_OPTS=${FZF_DEFAULT_OPTS}
#   eval "$(zoxide init zsh)"
# else
# echo "zoxide not found, consider installing it!"
# fi

# AzureCLI Auto Completions, if exists (via AUR)
[ -f "/opt/azure-cli/az.completion" ] && source "/opt/azure-cli/az.completion"

# if PHP composer is installed, add it to the path
[ -d "${HOME}/.composer/vendor/bin" ] && export PATH="${HOME}/.composer/vendor/bin:${PATH}"
