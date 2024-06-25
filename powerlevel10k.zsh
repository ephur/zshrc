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
    goenv
    pyenv
    kube_context
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

#load segment setup
typeset -g POWERLEVEL9K_LOAD_VISUAL_IDENTIFIER_EXPANSION=''
typeset -g POWERLEVEL9K_LOAD_WHICH=1

# pyenv/goenv setup
typeset -g POWERLEVEL9K_GOENV_FOREGROUND="${DEFAULT_FOREGROUND}"
typeset -g POWERLEVEL9K_GOENV_BACKGROUND="${DEFAULT_BACKGROUND}"
typeset -g POWERLEVEL9K_GOENV_PROMPT_ALWAYS_SHOW=true
typeset -g POWERLEVEL9K_PYENV_FOREGROUND="${ALT_FOREGROUND}"
typeset -g POWERLEVEL9K_PYENV_BACKGROUND="${ALT_BACKGROUND}"
typeset -g POWERLEVEL9K_PYENV_PROMPT_ALWAYS_SHOW=true

# custom segments setup
typeset -g POWERLEVEL9K_KUBE_CONTEXT_BACKGROUND="${DEFAULT_BACKGROUND}"
typeset -g POWERLEVEL9K_KUBE_CONTEXT_FOREGROUND="${DEFAULT_FOREGROUND}"

# DEV/STAGE/PROD refers to the context of k8s context segments
typeset -g POWERLEVEL9K_KUBE_CONTEXT_DEV_FOREGROUND="10"
typeset -g POWERLEVEL9K_KUBE_CONTEXT_STAGE_FOREGROUND="11"
typeset -g POWERLEVEL9K_KUBE_CONTEXT_PROD_FOREGROUND="9"
