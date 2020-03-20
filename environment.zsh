# Set the ZSH cache directory
export ZSH_CACHE_DIR=${ZSH}/cache
if [ ! -d ${ZSH_CACHE_DIR} ]; then
  mkdir -p ${ZSH_CACHE_DIR}
fi

# Set some useful environment vars
(which nvim >/dev/null 2>&1) && export EDITOR=nvim || export EDITOR=vi
export LESS='-i -N -w  -z-4 -g -e -M -X -F -R -P%t?f%f \
:stdin .?pb%pb\%:?lbLine %lb:?bbByte %bb:-...'
export LESSCHARSET='latin1'
export LESSOPEN='|/usr/bin/lesspipe.sh %s 2>&-'
export PAGER=less

# Disable accessibility bridge features
export NO_AT_BRIDGE=1

### konsole/yakuake don't handle blurring in KDE/Plasa 5 right, so work around
### this needs to happen early before tmux or antibody runs
if [[ ${XDG_SESSION_DESKTOP} = "KDE" ]] && [[ -z ${SUSPECTED_TERM_PID} ]]; then
  SUSPECTED_TERM_PID=${PPID}
fi

# Some tweaks if WSL (windows subsytem for linux) is in use
if [ -f ${ZSH}/wsl ]; then
  IS_WINDOWS=1
else
  IS_WINDOWS=0
fi

# Add cuda to library path
if [ -d /opt/cuda/lib64 ]; then
  export LD_LIBRARY_PATH="/opt/cuda/lib64:${LD_LIBRARY_PATH}"
fi

# Default color doesn't work well with my gnome-terminal settings
case $OSTYPE in
  linux*)
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=59'
  ;;
esac

# z/zoxide paths
_Z_DATA=~/.zsh_dir_history
_ZO_DATA=~/.zo

# control history
export HISTFILE=~/.zsh_history
export HISTSIZE=100000
export SAVEHIST=${HISTSIZE}
