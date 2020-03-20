# Set the base paths
unset PATH
if [[ -f /etc/arch-release ]]; then
  # arch gets a slightly stripped down path
  export PATH=${HOME}/bin:${HOME}/.cargo/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/X11/bin
else
  export PATH=${HOME}/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/bin:/usr/X11/bin:/var/lib/snapd/snap/bin
fi
ZSH=${HOME}/.zsh

# Load the ZSH profiler
zmodload zsh/zprof

# initialize completions early
autoload -Uz compinit
compinit

# load prompt, env tools, and antibody early
. ${ZSH}/environment.zsh
. ${ZSH}/env_tools.zsh
. ${ZSH}/powerlevel10k.zsh
. ${ZSH}/antibody_setup.zsh

# Set key binds
bindkey -v

# Set history behavior
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
for filename in functions.zsh secrets.zsh aliases.zsh do;
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
    if [[ -f ${ZSH}/dircolors ]]; then
      eval `dircolors ${ZSH}/dircolors`
    fi
  ;;
esac

### Some terminals need VTE sourced in
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi

### Check if suspected terminal is in a list we want to blur background of
if [[ $(ps --no-header -p ${SUSPECTED_TERM_PID} -o comm | egrep '(yakuake|konsole|alacritty)' ) ]]; then
  for wid in $(xdotool search --pid $PPID); do
    xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $wid  >> ~/ppid.log 2>&1
  done
fi

update_completions true
echo PATH=${PATH} > ~/.profile
