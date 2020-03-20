# Setup pyenv/before plugins that require python
 if [ "-d ${HOME}/.pyenv" ]; then
  export PYENV_VIRTUALENV_DISABLE_PROMPT=1
  export PYENV_ROOT="${HOME}/.pyenv"
  export PATH="${PYENV_ROOT}/bin:${PATH}"
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

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
if [ -f "$HOME/.rvm/scripts/rvm" ]; then
  source "$HOME/.rvm/scripts/rvm"
  export PATH="$PATH:$HOME/.rvm/bin"
fi

# KREW (kubectl plugin manager)
if which kubectl-krew >/dev/null 2>&1; then
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

function update_completions(){
	# Add kubectl/minikube/helm completion
	local source_only=${1}
	for i in kubectl minikube helm; do
    local cfile="${ZSH_CACHE_DIR}/${i}.completion"
		if ! [[ -z ${source_only} ]] && `which $i`; then
      ${i} completion zsh > ${cfile}
    fi
    [[ -f ${cfile} ]] && source ${cfile}
  done
}
