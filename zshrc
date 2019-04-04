# Set the base path
export PATH=${PATH}:${HOME}/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/bin:/usr/X11/bin

# ZSH Profile; Now with more oh-my-zsh per gallon
ZSH=${HOME}/.zsh

# Settings for zplug plugins
ZSH_TMUX_AUTOSTART=true
ZSH_TMUX_AUTOCONNECT=false
_Z_DATA=~/.zsh_dir_history

# Bootstrap .oh-my-zsh settings
if [ -f "${ZSH}/powerlevel9k.zsh" ]; then
  . ${ZSH}/powerlevel9k.zsh
fi

# Setup pyenv/before plugins that require python
if [ "-d ${HOME}/.pyenv" ]; then
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    export PYENV_ROOT="${HOME}/.pyenv"
    export PATH="${PYENV_ROOT}/bin:${PATH}"
    eval "$(pyenv init -)"
fi

# Setup rbenv/before plugins that require python
#if [ "-d ${HOME}/.rbenv" ]; then
#    export RBENV_ROOT="${HOME}/.rbenv"
#    export PATH="${RBENV_ROOT}/bin:${PATH}"
#    eval "$(rbenv init -)"
#fi

# Setup goenv/before plugins that require go
export GOPATH=~/Projects/go
if [ "-d ${HOME}/.goenv" ]; then
    export GOENV_ROOT="${HOME}/.goenv"
    export PATH="${HOME}/.goenv/bin:${PATH}:${GOPATH}/bin"
    eval "$(goenv init -)"
    if [ "-f ${HOME}/.goenv/completions/goenv.zsh" ]; then
        . ${HOME}/.goenv/completions/goenv.zsh
    fi
fi

# ZSH Plugins
if [ -f "${ZSH}/zplug.zsh" ]; then
    . ${ZSH}/zplug.zsh
fi

# Finish setting ZSH options that are not handled by zplug
# Include other parts of the zsh profile

# Set key binds
bindkey -e
bindkey '^[^[[C' forward-word
bindkey '^[^[[D' backward-word
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word
bindkey "^a" beginning-of-line
bindkey "^e" end-of-line
bindkey "^f" forward-word
bindkey "^b" backward-word
bindkey "^k" kill-line
bindkey "^d" delete-char
bindkey "^y" accept-and-hold
bindkey "^w" backward-kill-word
bindkey "^u" backward-kill-line
# Using custom history
# bindkey "^R" history-incremental-pattern-search-backward
bindkey "^F" history-incremental-pattern-search-forward
bindkey "^i" expand-or-complete-prefix
bindkey '^[^?' backward-kill-word

# Set history behavior
HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=${HISTSIZE}
setopt append_history           # Dont overwrite history
setopt extended_history         # Also record time and duration of commands.
setopt share_history            # Share history between multiple shells
setopt hist_expire_dups_first   # Clear duplicates when trimming internal hist.
setopt hist_find_no_dups        # Dont display duplicates during searches.
setopt hist_ignore_dups         # Ignore consecutive duplicates.
setopt hist_ignore_space        # Ignore items that start with a space
setopt hist_reduce_blanks       # Remove superfluous blanks.
setopt hist_save_no_dups        # Omit older commands in favor of newer ones.
# bindkey -s "\C-r" "\eqhh\n"     # Use hstr for history searches

# Misc Options
setopt extended_glob

zstyle ':completion:*' rehash true
zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# case-insensitive (all), partial-word and then substring completion
zstyle ":completion:*" matcher-list \
  "m:{a-zA-Z}={A-Za-z}" \
  "r:|[._-]=* r:|=*" \
  "l:|=* r:|=*"

zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}

# Add kubectl/minikube/helm completion
for i in kubectl minikube helm; do
    if [ -f "${HOME}/bin/${i}" ]; then
        source <(${HOME}/bin/${i} completion zsh)
    fi
done

# Source all of the other things
for filename in aliases.zsh environment.zsh functions.zsh secrets.zsh do;
    if [ -f "${ZSH}/${filename}" ]; then
        . ${ZSH}/${filename}
fi

# Bring in dir colors
case $OSTYPE in
  darwin*)
    export CLICOLOR=1
    export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
    export TERM="xterm-256color"
    alias z=_z
  ;;
  linux*)
    if [ -f ${ZSH}/dircolors ]; then
          eval `dircolors ${ZSH}/dircolors`
    fi
  ;;
esac

# KREW
if which kubectl-krew >/dev/null 2>&1; then
  export PATH="${KREW_ROOT:-$HOME/.krew}/bin:$PATH"
fi

# PYenv 
if which pyenv > /dev/null 2>&1; then 
  eval "$(pyenv init -)"
  eval "$(pyenv virtualenv-init -)"
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
