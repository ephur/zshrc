# Profile this...
# thanks to: https://www.dribin.org/dave/blog/archives/2024/01/01/zsh-performance/
#: "${PROFILE_STARTUP:=false}"
#: "${PROFILE_ALL:=false}"
# Run this to get a profile trace and exit: time zsh -i -c echo
# Or: time PROFILE_STARTUP=true /bin/zsh -i --login -c echo
#if [[ "$PROFILE_STARTUP" == true || "$PROFILE_ALL" == true ]]; then
#    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
#    PS4=$'%D{%H:%M:%S.%.} %N:%i> '
#    #zmodload zsh/datetime
#    #PS4='+$EPOCHREALTIME %N:%i> '
#    exec 3>&2 2>/tmp/zsh_profile.$$
#    setopt xtrace prompt_subst
#fi

# Set the base paths
if [[ -f /etc/arch-release ]]; then
  # arch gets a slightly stripped down path
  export PATH=${HOME}/bin:${HOME}/.cargo/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/X11/bin
elif [[ -f ~/.zsh/wsl ]]; then
  # running in WSL
  export PATH=${PATH}:${HOME}/bin:${HOME}/.cargo/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/usr/X11/bin
else
  export PATH=${HOME}/bin:/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/bin:/usr/X11/bin:/var/lib/snapd/snap/bin
fi

# Set the base .zsh directory and cache
ZSH=${HOME}/.zsh
export ZSH_CACHE_DIR=${ZSH}/cache
if [ ! -d ${ZSH_CACHE_DIR} ]; then
  mkdir -p ${ZSH_CACHE_DIR}
fi

# setup antidote, compile plugins, etc...
source ${ZSH}/.antidote/antidote.zsh

# Set key binds
export KEYTIMEOUT=1
bindkey -v

# Load the ZSH profiler
# zmodload zsh/zprof
# autoload -U read-from-minibuffer

# Handle dircolors, must be done before applying zstyles that use them
case $OSTYPE in
  darwin*)
    if [[ -f /opt/homebrew/bin/gdircolors && -f ${ZSH}/dircolors ]]  ; then
      eval $(/opt/homebrew/bin/gdircolors -b ${ZSH}/dircolors)
    else
      export CLICOLOR=1
      export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
      export TERM="xterm-256color"
    fi
  ;;
  linux*)
    if [[ -f ${ZSH}/dircolors ]]; then
      eval `dircolors ${ZSH}/dircolors`
    fi
  ;;
esac

# initialize completions early
autoload -Uz compinit;
# use zcompdump if available and less than 1 day old
zcompdump="${HOME}/.zcompdump"
if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
  zcompile "$zcompdump"
fi
compinit -C

zstyle ':completion:*' cache-path "${ZSH}/cache/.zcompcache"          # set cache path for completions
zstyle ':completion:*' completer _extensions _complete _approximate   # choose completers to use
zstyle ':completion:*' group-name ''                                  # group completion items together
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}                 # define colors for completion list
zstyle ':completion:*' menu select                                    # enable fancy selection of completions
# zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache true                                 # enable cache, helpful for large completion lists but can be problematic for things like kubectl
zstyle ':completion:*' verbose true
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '%F{green}%B%d%b%f'
zstyle ':completion:*:messages' format '%F{purple}%d%f'
zstyle ':completion:*:warnings' format '%F{red}No matches for: %d%f'

# case-insensitive (all), partial-word and then substring completion
zstyle ":completion:*" matcher-list \
  "m:{a-zA-Z}={A-Za-z}" \
  "r:|[._-]=* r:|=*" \
  "l:|=* r:|=*"

# early load extra resources
for filename in environment.zsh tools.zsh powerlevel10k.zsh antidote_setup.zsh; do
  if [ -f "${ZSH}/${filename}" ]; then
    source ${ZSH}/${filename}
  fi
done

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

# Set directory stack behavior
setopt autopushd
setopt pushdminus
setopt pushdsilent
setopt pushdtohome

# Misc Options
setopt extended_glob

# final loading extra resources
for filename in aliases.zsh functions.zsh secrets.zsh work.zsh do;
    if [ -f "${ZSH}/${filename}" ]; then
        . ${ZSH}/${filename}
fi

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
if ! [[ -z ${SUSPECTED_TERM_PID} ]]; then
  if [[ $(ps --no-header -p ${SUSPECTED_TERM_PID} -o comm | egrep '(yakuake|konsole|alacritty)' ) ]]; then
    for wid in $(xdotool search --pid $PPID); do
      xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id $wid  >/dev/null 2>&1
    done
  fi
fi

# remove duplicates from path
# thanks: https://unix.stackexchange.com/questions/40749/remove-duplicate-path-entries-with-awk-command
if [ -n "$PATH" ]; then
  if [ ${IS_WINDOWS} -eq 1 ]; then
    [[ -f ${ZSH}/win_path.zsh ]] && source ${ZSH}/win_path.zsh
  fi
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

# finally reload and compile completions
compinit -C
{
  zcompdump="${HOME}/.zcompdump"
  if [[ -s "$zcompdump" && (! -s "${zcompdump}.zwc" || "$zcompdump" -nt "${zcompdump}.zwc") ]]; then
    zcompile "$zcompdump"
  fi
} &!

# use completions from kubectl for kubecolor if it is present
if (which kubecolor >/dev/null 2>&1); then
  compdef kubecolor=kubectl
fi

# dump this pig
# test -e /Users/rmaynard/.iterm2_shell_integration.zsh && source /Users/rmaynard/.iterm2_shell_integration.zsh || true
if [[ "$PROFILE_STARTUP" == true || "$PROFILE_ALL" == true ]]; then
    unsetopt xtrace
fi

# Randomly...
export PATH="/opt/homebrew/opt/mysql/bin:$PATH"
