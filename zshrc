# Set the base paths
if [[ -f /etc/arch-release ]]; then
  # arch gets a slightly stripped down path
  export PATH=${HOME}/bin:${HOME}/.cargo/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/X11/bin
else
  export PATH=${HOME}/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/bin:/usr/X11/bin:/var/lib/snapd/snap/bin
fi
ZSH=${HOME}/.zsh

# Set key binds
export KEYTIMEOUT=1
bindkey -v

# Load the ZSH profiler
zmodload zsh/zprof
autoload -Uz compinit
# autoload -U read-from-minibuffer
compinit

# Handle dircolors, must be done before applying zstyles that use them
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

# initialize completions early
zstyle ':completion:*' rehash true
zstyle ':completion:*' verbose yes
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*' group-name ''

# case-insensitive (all), partial-word and then substring completion
zstyle ":completion:*" matcher-list \
  "m:{a-zA-Z}={A-Za-z}" \
  "r:|[._-]=* r:|=*" \
  "l:|=* r:|=*"


# load prompt, env tools, and antibody early
. ${ZSH}/environment.zsh
. ${ZSH}/env_tools.zsh
. ${ZSH}/powerlevel10k.zsh
. ${ZSH}/antibody_setup.zsh

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

# Source all of the other things
for filename in functions.zsh secrets.zsh aliases.zsh do;
    if [ -f "${ZSH}/${filename}" ]; then
        . ${ZSH}/${filename}
fi

# Get 1password completions
if which op >/dev/null 2>&1; then 
  local op=$(which op | head -1)
  local shl=$(echo ${SHELL} | awk -F/ '{print $NF}')
  eval "$($op completion $shl)"
  compdef _op op
fi

# Use zoxide for dir history
$(which zoxide >/dev/null 2>&1) && eval "$(zoxide init zsh)"

# Source in the completions before compiling everything
update_completions true

# AzureCLI Auto Completions, if exists (via AUR)
[ -f "/opt/azure-cli/az.completion" ] && source "/opt/azure-cli/az.completion"

# compile completions
{
  zcompdump="${HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# Enable VI editing for current command line
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd '!' edit-command-line

### Some terminals need VTE sourced in
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi

### Use find-the-command if it's installed
[[ -f "/usr/share/doc/find-the-command/ftc.zsh" ]] && source /usr/share/doc/find-the-command/ftc.zsh

### Check if suspected terminal is in a list we want to blur background of
if [[ $(ps --no-header -p ${SUSPECTED_TERM_PID} -o comm | egrep '(yakuake|konsole|alacritty)' ) ]]; then
  for wid in $(xdotool search --pid $PPID); do
    xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $wid  >/dev/null 2>&1
  done
fi

# remove duplicates from path
# thanks: https://unix.stackexchange.com/questions/40749/remove-duplicate-path-entries-with-awk-command
if [ -n "$PATH" ]; then
  old_PATH=$PATH:; PATH=
  while [ -n "$old_PATH" ]; do
    x=${old_PATH%%:*}       # the first remaining entry
    case $PATH: in
      *:"$x":*) ;;          # already there
      *) PATH=$PATH:$x;;    # not there yet
    esac
    old_PATH=${old_PATH#*:}
  done
  PATH=${PATH#:}
  unset old_PATH x
fi
echo PATH=${PATH} > ~/.profile
