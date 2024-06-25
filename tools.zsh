# If Homebrew is installed, use its completions and add it to the path
[[ -f /opt/homebrew/bin/brew ]] && export PATH=${PATH}:/opt/homebrew/bin && FPATH=/opt/homebrew/share/zsh/site-functions:$FPATH

# Setup pyenv/before plugins that require python
 if [ "-d ${HOME}/.pyenv" ]; then
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
  export PYENV_ROOT="${HOME}/.pyenv"
  export PATH="${PYENV_ROOT}/bin:${PATH}"
  # Don't think this is needed anymore, it just creates
  # the shims, but pyenv init - does that too
  # eval "$(pyenv init --path)"

  # save these to a cache dir, and only update them if they're older than a week
  pyenv_init_cache="${ZSH_CACHE_DIR}/pyenv_init.zsh"
  if [[ ! -f "${pyenv_init_cache}" ]]; then
    $(pyenv init - > ${pyenv_init_cache})
  fi
  # do not refresh the pyenv cache, the way it determines
  # the shim paths is slow; and should not cause problems
  # not being there
  # for f in ${pyenv_init_cache}(N.mh+24); do
  #   $(pyenv init - > ${pyenv_init_cache})
  # done
  source ${pyenv_init_cache}

  pyenv_virtualenv_init_cache="${ZSH_CACHE_DIR}/pyenv_virtualenv_init.zsh"
  if [[ ! -f "${pyenv_virtualenv_init_cache}" ]]; then
    $(pyenv virtualenv-init - > ${pyenv_virtualenv_init_cache})
  fi
  for f in ${pyenv_virtualenv_init_cache}(N.mh+24); do
    $(pyenv virtualenv-init - > ${pyenv_virtualenv_init_cache})
  done
  source ${pyenv_virtualenv_init_cache}
fi

# setup for nvm
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# setup for goenv (requires goenv 2+)
if [ "-d ${HOME}/.goenv" ]; then
    export GOENV_GOPATH_PREFIX="${HOME}/Projects/go"
    export GOENV_ROOT="${HOME}/.goenv"
    export PATH="${GOENV_ROOT}/bin:${PATH}"
    goenv_init_cache="${ZSH_CACHE_DIR}/goenv_init.zsh"
    if [[ ! -f "${goenv_init_cache}" ]]; then
        $(goenv init - > ${goenv_init_cache})
    fi
    for f in ${goenv_init_cache}(N.mh+24); do
        $(goenv init - > ${goenv_init_cache})
    done
    source ${goenv_init_cache}
fi

# setup for rbenv
if [ -d "${HOME}/.rbenv" ]; then
  export PATH="${HOME}/.rbenv/bin:${PATH}"
  rbenv_init_cache="${ZSH_CACHE_DIR}/rbenv_init.zsh"
  if [[ ! -f "${rbenv_init_cache}" ]]; then
    $(rbenv init - zsh > ${rbenv_init_cache})
  fi
  for f in ${rbenv_init_cache}(N.mh+24); do
    $(rbenv init - zsh > ${rbenv_init_cache})
  done
  source ${rbenv_init_cache}
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

# CircleCI CLI tool
if which circleci > /dev/null 2>&1; then
  export CIRCLECI_CLI_SKIP_UPDATE_CHECK=1
  circle_completion_cache="${ZSH_CACHE_DIR}/circle_completion.zsh"
  if [[ ! -f "${circle_completion_cache}" ]]; then
    circleci completion zsh > ${circle_completion_cache}
  fi
  for f in ${circle_completion_cache}(N.mh+24); do
    circleci completion zsh > ${circle_completion_cache}
  done
  source ${circle_completion_cache}
fi

# Get 1password completions
if which op >/dev/null 2>&1; then
  op_completions="${ZSH_CACHE_DIR}/op_completions.zsh"
  if ! [[ -f "${op_completions}" ]] || find "${op_completions}" -mtime +30 | grep -q .; then
    op completion zsh > ${op_completions}
  fi
  source "${op_completions}"
  compdef _op op
fi

# Use zoxide for dir history if it's available
if which zoxide >/dev/null 2>&1; then
  # export _ZO_DATA_DIR="${HOME}/.zoxide_data_dir}"
  export _ZO_ECHO=1
  export _ZO_FZF_OPTS=${FZF_DEFAULT_OPTS}
  zoxide_init_cache="${ZSH_CACHE_DIR}/zoxide_init.zsh"
  if [[ ! -f "${zoxide_init_cache}" ]]; then
    $(zoxide init zsh > ${zoxide_init_cache})
  fi
  for f in ${zoxide_init_cache}(N.mh+24); do
    $(zoxide init zsh > ${zoxide_init_cache})
  done
  source ${zoxide_init_cache}
else
    echo "zoxide not found, consider installing it!"
fi

# AzureCLI Auto Completions, if exists (via AUR)
[ -f "/opt/azure-cli/az.completion" ] && source "/opt/azure-cli/az.completion"

# if PHP composer is installed, add it to the path
[ -d "${HOME}/.composer/vendor/bin" ] && export PATH="${HOME}/.composer/vendor/bin:${PATH}"
