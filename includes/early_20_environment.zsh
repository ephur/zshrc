# Set some useful environment vars
(which nvim >/dev/null 2>&1) && export EDITOR=nvim || export EDITOR=vi
export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f \
:stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'
export LESSCHARSET='latin1'
export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
export PAGER=less
export KEYTIMEOUT=1


# Disable accessibility bridge features
export NO_AT_BRIDGE=1

# setup SSH agent socket
case $OSTYPE in
  linux*)
    export XDG_RUNTIME_DIR=/run/user/$(id -u)
    ;;
  darwin*)
    export XDG_RUNTIME_DIR=${HOME}/Library/Caches/xdg
    ;;
esac

# Setup SSH agent
# eval "$(ssh-agent -s)" >/dev/null 2>&1

### konsole/yakuake don't handle blurring in KDE/Plasa 5 right, so work around
### this needs to happen early before tmux or antibody runs
if [[ ${XDG_SESSION_DESKTOP} = ("KDE"|"plasma") ]] && [[ -z ${SUSPECTED_TERM_PID} ]]; then
  SUSPECTED_TERM_PID=${PPID}
fi

# Some tweaks if WSL (windows subsytem for linux) is in use
if [ -f ${ZSH}/wsl ]; then
  IS_WINDOWS=1
else
  IS_WINDOWS=0
fi

# Check some special paths to add/update env
[ -d "${HOME}/.cargo/bin" ] && export PATH=${HOME}/.cargo/bin:$PATH
[ -d "${HOME}/Projects" ] && export PROJECTS=${HOME}/Projects

# Check for CUDA and add to path
[ -d /opt/cuda/ ] && export LD_LIBRARY_PATH="/opt/cuda/lib64:${LD_LIBRARY_PATH}"
[ -d /opt/cuda ] && export PATH=/opt/cuda/bin:${PATH}
[ -d /usr/local/cuda/ ] && export LD_LIBRARY_PATH="/usr/local/cuda/lib64:${LD_LIBRARY_PATH}"
[ -d /usr/local/cuda/ ] && export PATH=/usr/local/cuda/bin:${PATH}

# Default color doesn't work well with my gnome-terminal settings
case $OSTYPE in
  linux*)
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=4'
  ;;
esac

# z/zoxide paths
_Z_DATA=~/.zsh_dir_history
_ZO_DATA=~/.zo

# control history
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=${HISTSIZE}
export DIRSTACKSIZE=32

# ensure a consistent XDG_CONFIG_HOME
export XDG_CONFIG_HOME="${HOME}/.config"

# environment for some plugins
ZSH_COLORIZE_STYLE="dracula"

# FZF Dracula colors
export FZF_DEFAULT_OPTS='
  --color fg:255,bg:236,hl:84,fg+:8,bg+:6,hl+:9
  --color info:141,prompt:84,spinner:212,pointer:212,marker:212
  --height 100%
'
