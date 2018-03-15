# Set the base path
export PATH=${HOME}/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/bin:/usr/X11/bin

# ZSH Profile; Now with more oh-my-zsh per gallon
ZSH=${HOME}/.zsh

# Settings for zplug plugins
ZSH_TMUX_AUTOSTART=true
_Z_DATA=~/.zsh_dir_history

# Bootstrap .oh-my-zsh settings
if [ -f "${ZSH}/powerline9k.zsh" ]; then
  . ${ZSH}/powerline9k.zsh
fi

# ZSH Plugins
if [ -f "${ZSH}/zplug.zsh" ]; then
    . ${ZSH}/zplug.zsh
fi



#######################################################################
### Oh MY Zsh is not _MY_ zsh, so it still needs a little more work ###
#######################################################################
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
#bindkey "^R" history-incremental-pattern-search-backward
bindkey "^F" history-incremental-pattern-search-forward
bindkey "^i" expand-or-complete-prefix
bindkey '^[^?' backward-kill-word

# Set history behavior
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt append_history           # Dont overwrite history
setopt extended_history         # Also record time and duration of commands.
setopt share_history            # Share history between multiple shells
setopt hist_expire_dups_first   # Clear duplicates when trimming internal hist.
setopt hist_find_no_dups        # Dont display duplicates during searches.
setopt hist_ignore_dups         # Ignore consecutive duplicates.
setopt hist_reduce_blanks       # Remove superfluous blanks.
setopt hist_save_no_dups        # Omit older commands in favor of newer ones.

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

# Add kubectl/minikube completion
for i in kubectl minikube; do
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
if [ -f ${ZSH}/dircolors ]; then
    eval `dircolors ${ZSH}/dircolors`
fi

# Setup pyenv
if [ "-d ${HOME}/.pyenv" ]; then
    export PYENV_VIRTUALENV_DISABLE_PROMPT=1
    export PYENV_ROOT="${HOME}/.pyenv"
    export PATH="${PYENV_ROOT}/bin:${PATH}"
    eval "$(pyenv init -)"
fi

# Setup goenv
if [ "-d ${HOME}/.goenv" ]; then
    export GOENV_ROOT="${HOME}/.goenv"
    export PATH="${HOME}/.goenv/bin:${PATH}"
    eval "$(goenv init -)"
fi

# Misc stuff
awsregion us-east-1
