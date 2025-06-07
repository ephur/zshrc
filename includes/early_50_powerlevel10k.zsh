# Custom Prompt Segments
function prompt_pyenv_version() {
  local version

  # 1. Check PYENV_VERSION (env override or shell override)
  if [[ -n "$PYENV_VERSION" ]]; then
    version="$PYENV_VERSION"
  fi

  # 2. Walk upward for .python-version
  if [[ -z "$version" ]]; then
    local dir=$PWD
    while [[ "$dir" != "/" ]]; do
      if [[ -f "$dir/.python-version" ]]; then
        version=$(<"$dir/.python-version")
        break
      fi
      dir="${dir:h}"
    done
  fi

  # 3. Fallback to global version file
  if [[ -z "$version" && -f "${PYENV_ROOT:-$HOME/.pyenv}/version" ]]; then
    version=$(<"${PYENV_ROOT:-$HOME/.pyenv}/version")
  fi

  [[ -n "$version" ]] && p10k segment -i $'\uE235' -t " ${version}"
}

# Custom goenv prompt segment, matches pyenv logic for speed and accuracy
function prompt_goenv_version() {
  local version

  # 1. Check GOENV_VERSION if explicitly set
  if [[ -n "$GOENV_VERSION" ]]; then
    version="$GOENV_VERSION"
  fi

  # 2. Walk upward for .go-version (used by goenv)
  if [[ -z "$version" ]]; then
    local dir=$PWD
    while [[ "$dir" != "/" ]]; do
      if [[ -f "$dir/.go-version" ]]; then
        version=$(<"$dir/.go-version")
        break
      fi
      dir="${dir:h}"
    done
  fi

  # 3. Fallback to global goenv version file
  if [[ -z "$version" && -f "${GOENV_ROOT:-$HOME/.goenv}/version" ]]; then
    version=$(<"${GOENV_ROOT:-$HOME/.goenv}/version")
  fi

  [[ -z "$version" ]] && version="system"
  p10k segment -i $'\uE626' -t " ${version}"
}

# powerlevel 10 custom kube_context segment
prompt_kube_context() {
  # powerlevel10 has a builtin context, but want some extra features
  CLUSTER_FILE=${ZSH_CACHE_DIR}/k8s-clusters
  local context=`test -f ~/.kube/config && grep current-context ~/.kube/config | cut -d\  -f2`
  if [[ -z $context ]]; then
    context='unknown'
  fi
  if [[ "$context" =~ "arn:aws*" ]]; then
    context=${context#*/}
  fi
  local namespace=`kubectl config get-contexts --no-headers | grep '^\*' | awk '{ print $5 }'`
  if [ "${namespace}" = "" ]; then
    namespace='default'
  fi
  local env=$(test -f ${CLUSTER_FILE} && grep ${context} ${CLUSTER_FILE} | cut -d\; -f1)
  if [ -z "${env}" ]; then
    env="unknown"
  fi
  p10k segment -s ${env} -i $'\uE7B2' -t "${context}/${namespace}"
}

# Easily switch primary foreground/background colors
typeset -g DEFAULT_BACKGROUND=237
typeset -g ALT_BACKGROUND=6

typeset -g ALT_FOREGROUND=237
typeset -g DEFAULT_FOREGROUND=6

# Set the font mode and default behaviors
typeset -g POWERLEVEL9K_MODE="nerdfont-complete"
typeset -g POWERLEVEL9K_{LEFT,RIGHT}_{LEFT,RIGHT}_WHITESPACE=" "
typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SEGMENT_SEPARATOR="\uE0C8"
typeset -g POWERLEVEL9K_{LEFT,RIGHT}_SUBSEGMENT_SEPARATOR=""
typeset -g POWERLEVEL9K_PROMPT_ON_NEWLINE=false
typeset -g POWERLEVEL9K_PROMPT_ADD_NEWLINE=true
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=()

# set segments, don't include context unless SSH connected
if [ -z "${SSH_CLIENT}" ]; then
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon
    command_execution_time
    status
    aws
    # goenv
    # goenv_version
    # pyenv_version
    vcs
    newline
    dir_writable
    dir
    root_indicator
    prompt_char
  )
else
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    os_icon
    command_execution_time
    status
    time
    vcs
    newline
    context
    dir_writable
    dir
    root_indicator
    prompt_char
  )

fi
# OS Icon config
typeset -g POWERLEVEL9K_OS_ICON_FOREGROUND="${DEFAULT_FOREGROUND}"
typeset -g POWERLEVEL9K_OS_ICON_BACKGROUND="${DEFAULT_BACKGROUND}"

# context segment config, only show when SSH'd to host
typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE="\uF109 %m"
typeset -g POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="${DEFAULT_FOREGROUND}"
typeset -g POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND="${DEFAULT_BACKGROUND}"
typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="${DEFAULT_FOREGROUND}"
typeset -g POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND="${DEFAULT_BACKGROUND}"
typeset -g POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true

# vcs segment setup
typeset -g POWERLEVEL9K_VCS_{CLEAN,MODIFIED,UNTRACKED}_FOREGROUND="${DEFAULT_BACKGROUND}"
typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND="10"
typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="11"
typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="13"

# directory segment setup
typeset -g POWERLEVEL9K_SHORTEN_DIR_LENGTH=3
typeset -g POWERLEVEL9K_SHORTEN_STRATEGY="truncate_to_unique"
typeset -g POWERLEVEL9K_DIR_{HOME,HOME_SUBFOLDER,DEFAULT,WRITABLE_FORBIDDEN}_BACKGROUND="${DEFAULT_BACKGROUND}"
typeset -g POWERLEVEL9K_DIR_{HOME,HOME_SUBFOLDER,DEFAULT,WRITABLE_FORBIDDEN}_FOREGROUND="${DEFAULT_FOREGROUND}"

# status segment setup
typeset -g POWERLEVEL9K_STATUS_VERBOSE=true
typeset -g POWERLEVEL9K_STATUS_CROSS=false
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND="${ALT_FOREGROUND}"
typeset -g POWERLEVEL9K_STATUS_{ERROR,OK}_BACKGROUND="${ALT_BACKGROUND}"
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND="1"

# time segment setup
typeset -g POWERLEVEL9K_TIME_FORMAT="%D{%T }" # 15:29:33
typeset -g POWERLEVEL9K_TIME_FOREGROUND="${ALT_FOREGROUND}"
typeset -g POWERLEVEL9K_TIME_BACKGROUND="${ALT_BACKGROUND}"
typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=''

# execution time segment setup
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=3
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="${ALT_FOREGROUND}"
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="${ALT_BACKGROUND}"
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_ICON="\u23F1"

# root indicator segment setup
typeset -g POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND="${DEFAULT_FOREGROUND}"
typeset -g POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND="magenta"
typeset -g POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="${DEFAULT_BACKGROUND}"
typeset -g POWERLEVEL9K_USER_ROOT_ICON=$'\uF198'  # 

# Prompt char
typeset -g POWERLEVEL9K_PROMPT_CHAR_FOREGROUND="${ALT_FOREGROUND}"
typeset -g POWERLEVEL9K_PROMPT_CHAR_BACKGROUND="${ALT_BACKGROUND}"

# load segment setup
typeset -g POWERLEVEL9K_LOAD_VISUAL_IDENTIFIER_EXPANSION=''
typeset -g POWERLEVEL9K_LOAD_WHICH=1

# pyenv/goenv setup
typeset -g POWERLEVEL9K_GOENV_VERSION_FOREGROUND="${DEFAULT_FOREGROUND}"
typeset -g POWERLEVEL9K_GOENV_VERSION_BACKGROUND="${DEFAULT_BACKGROUND}"
typeset -g POWERLEVEL9K_GOENV_VERSION_PROMPT_ALWAYS_SHOW=true
typeset -g POWERLEVEL9K_PYENV_VERSION_FOREGROUND="${ALT_FOREGROUND}"
typeset -g POWERLEVEL9K_PYENV_VERSION_BACKGROUND="${ALT_BACKGROUND}"
typeset -g POWERLEVEL9K_PYENV_VERSION_PROMPT_ALWAYS_SHOW=true

# custom segments setup
typeset -g POWERLEVEL9K_KUBE_CONTEXT_BACKGROUND="${DEFAULT_BACKGROUND}"
typeset -g POWERLEVEL9K_KUBE_CONTEXT_FOREGROUND="${DEFAULT_FOREGROUND}"

# DEV/STAGE/PROD refers to the context of k8s context segments
typeset -g POWERLEVEL9K_KUBE_CONTEXT_DEV_FOREGROUND="10"
typeset -g POWERLEVEL9K_KUBE_CONTEXT_STAGE_FOREGROUND="11"
typeset -g POWERLEVEL9K_KUBE_CONTEXT_PROD_FOREGROUND="9"
