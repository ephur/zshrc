# Set the base paths
export PATH=${PATH}:${HOME}/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/bin:/usr/X11/bin
ZSH=${HOME}/.zsh

# Load the ZSH profiler
zmodload zsh/zprof

# initialize completions early
autoload -Uz compinit
compinit

export ZSH_CACHE_DIR=${ZSH}/cache
if [ ! -d ${ZSH_CACHE_DIR} ]; then
  mkdir -p ${ZSH_CACHE_DIR}
fi


_Z_DATA=~/.zsh_dir_history
# Some tweaks if WSL (windows subsytem for linux) is in use
if [ -f ${ZSH}/wsl ]; then
  IS_WINDOWS=1
  ZSH_TMUX_AUTOSTART=false
  ZSH_TMUX_AUTOCONNECT=false
else
  IS_WINDOWS=0
  ZSH_TMUX_AUTOSTART=true
  ZSH_TMUX_AUTOCONNECT=false
fi

case $OSTYPE in
  linux*)
  # Default color doesn't work well with my gnome-terminal settings
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=6'
  ;;
esac

# load prompt, env tools, and antibody early
. ${ZSH}/env_tools.zsh
. ${ZSH}/powerlevel10k.zsh
. ${ZSH}/antibody_setup.zsh

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

# Source all of the other things
for filename in aliases.zsh environment.zsh functions.zsh secrets.zsh do;
    if [ -f "${ZSH}/${filename}" ]; then
        . ${ZSH}/${filename}
fi

# compile completions
{
  zcompdump="${HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# Set OS specific options, WSL shell sets linux options + is_windows options
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

if [ ${IS_WINDOWS} -eq 1 ]; then
  alias z=_z
fi
