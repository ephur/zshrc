# Setup homebrew paths
if $IS_OSX && [[ -d /opt/homebrew/bin ]]; then
  export PATH="/opt/homebrew/bin:${PATH}"
  fpath+=("/opt/homebrew/share/zsh/site-functions")
  export HOMEBREW_PREFIX="/opt/homebrew"
  export HOMEBREW_REPOSITORY="/opt/homebrew"
  export HOMEBREW_CELLAR="/opt/homebrew/Cellar"
fi

# # Setup pyenv, defer full init until first use
# if [ -d "${HOME}/.pyenv" ]; then
#   export PYENV_VIRTUALENV_DISABLE_PROMPT=1
#   export PYENV_ROOT="${HOME}/.pyenv"
#   export PATH="${PYENV_ROOT}/bin:${PATH}"

#   pyenv_init_cache="${ZSH_CACHE_DIR}/pyenv_init.zsh"

#   # Refresh init cache in background if stale
#   if is_stale_file "${pyenv_init_cache}"; then
#     (pyenv init - > "${pyenv_init_cache}") &!
#   fi

#   # Lazy load pyenv init on first use
#   _pyenv_lazy_init() {
#     source_compiled "${pyenv_init_cache}"
#     unfunction _pyenv_lazy_init
#   }

#   function pyenv() {
#     _pyenv_lazy_init
#     pyenv "$@"
#   }
# fi
if [ -d "${HOME}/.pyenv" ]; then
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
  export PYENV_ROOT="${HOME}/.pyenv"
  export PATH="${PYENV_ROOT}/bin:${PYENV_ROOT}/shims:${PATH}"

  pyenv_init_cache="${ZSH_CACHE_DIR}/pyenv_init.zsh"

  # Refresh init cache in background if stale
  if is_stale_file "${pyenv_init_cache}"; then
    (pyenv init - > "${pyenv_init_cache}") &!
  fi

  # Lazy load pyenv init on first use
  _pyenv_lazy_init() {
    source_compiled "${pyenv_init_cache}"
    unfunction _pyenv_lazy_init
  }

  function pyenv() {
    _pyenv_lazy_init
    pyenv "$@"
  }
fi

# setup for nvm
export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source  "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && source_compiled "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# setup for goenv (requires goenv 2+)
if [ -d "${HOME}/.goenv" ]; then
  export GOENV_GOPATH_PREFIX="${HOME}/Projects/go"
  export GOENV_ROOT="${HOME}/.goenv"
  export PATH="${GOENV_ROOT}/bin:${GOENV_ROOT}/shims:${PATH}"

  goenv_init_cache="${ZSH_CACHE_DIR}/goenv_init.zsh"

  if is_stale_file "${goenv_init_cache}"; then
    (goenv init - > "${goenv_init_cache}") &!
  fi

  _goenv_lazy_init() {
    source_compiled "${goenv_init_cache}"
    unfunction _goenv_lazy_init
  }

  function goenv() {
    _goenv_lazy_init
    goenv "$@"
  }
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
  source_compiled ${rbenv_init_cache}
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
if [ -f "$HOME/.rvm/scripts/rvm" ]; then
  source_compiled "$HOME/.rvm/scripts/rvm"
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
  source_compiled ${circle_completion_cache}
fi

# Get 1password completions
if which op >/dev/null 2>&1; then
  op_completions="${ZSH_CACHE_DIR}/op_completions.zsh"
  if is_stale_file "${op_completions}"; then
    op completion zsh > ${op_completions}
  fi
  source_compiled "${op_completions}"
  compdef _op op
fi

# Use zoxide for dir history if it's available
if which zoxide >/dev/null 2>&1; then
  export _ZO_ECHO=1
  export _ZO_FZF_OPTS=${FZF_DEFAULT_OPTS}
  zoxide_init_cache="${ZSH_CACHE_DIR}/zoxide_init.zsh"
  is_stale_file "${zoxide_init_cache}" && zoxide init zsh > "${zoxide_init_cache}"
  eval "$(cat "${zoxide_init_cache}")"
else
  echo "zoxide not found, consider installing it!"
fi

# if PHP composer is installed, add it to the path
[ -d "${HOME}/.composer/vendor/bin" ] && export PATH="${HOME}/.composer/vendor/bin:${PATH}"

# use completions from kubectl for kubecolor if it is present
if (which kubecolor >/dev/null 2>&1); then
  compdef kubecolor=kubectl
fi
