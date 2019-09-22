# Easily switch primary foreground/background colors
typeset -g DEFAULT_BACKGROUND=235
typeset -g DEFAULT_FOREGROUND=006
typeset -g ALT_BACKGROUND=006
typeset -g ALT_FOREGROUND=235

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
    time
    load
    go_version
    python_version
    kube_context
    vcs
    newline
    status
    command_execution_time
    dir_writable
    dir
    root_indicator
  )
else 
  typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
    time
    load
    go_version
    python_version
    kube_context
    vcs
    newline
    status
    command_execution_time
    context
    dir_writable
    dir
    root_indicator
  )

fi

# context segment config, only show when SSH'd to host
typeset -g POWERLEVEL9K_CONTEXT_TEMPLATE="\uF109 %m"
typeset -g POWERLEVEL9K_CONTEXT_DEFAULT_FOREGROUND="${DEFAULT_FOREGROUND}"
typeset -g POWERLEVEL9K_CONTEXT_DEFAULT_BACKGROUND="${DEFAULT_BACKGROUND}"
typeset -g POWERLEVEL9K_CONTEXT_ROOT_FOREGROUND="${DEFAULT_FOREGROUND}"
typeset -g POWERLEVEL9K_CONTEXT_ROOT_BACKGROUND="${DEFAULT_BACKGROUND}"
typeset -g POWERLEVEL9K_ALWAYS_SHOW_CONTEXT=true

# vcs segment setup
typeset -g POWERLEVEL9K_VCS_{CLEAN,MODIFIED,UNTRACKED}_FOREGROUND="${DEFAULT_BACKGROUND}"
typeset -g POWERLEVEL9K_VCS_CLEAN_BACKGROUND="green"
typeset -g POWERLEVEL9K_VCS_MODIFIED_BACKGROUND="yellow"
typeset -g POWERLEVEL9K_VCS_UNTRACKED_BACKGROUND="magenta"

# directory segment setup
typeset -g POWERLEVEL9K_DIR_SHORTEN_DIR_LENGTH=5
typeset -g POWERLEVEL9K_DIR_SHORTEN_STRATEGY="truncate_to_unique"
typeset -g POWERLEVEL9K_DIR_{HOME,HOME_SUBFOLDER,DEFAULT,WRITABLE_FORBIDDEN}_BACKGROUND="${ALT_BACKGROUND}"
typeset -g POWERLEVEL9K_DIR_{HOME,HOME_SUBFOLDER,DEFAULT,WRITABLE_FORBIDDEN}_FOREGROUND="${ALT_FOREGROUND}"

# status segment setup
typeset -g POWERLEVEL9K_STATUS_VERBOSE=true
typeset -g POWERLEVEL9K_STATUS_CROSS=false
typeset -g POWERLEVEL9K_STATUS_OK_FOREGROUND="green"
typeset -g POWERLEVEL9K_STATUS_{ERROR,OK}_BACKGROUND="${DEFAULT_BACKGROUND}"
typeset -g POWERLEVEL9K_STATUS_ERROR_FOREGROUND="red"

# time segment setup
typeset -g POWERLEVEL9K_TIME_FORMAT="%D{%T }" # 15:29:33
typeset -g POWERLEVEL9K_TIME_FOREGROUND="${DEFAULT_FOREGROUND}"
typeset -g POWERLEVEL9K_TIME_BACKGROUND="${DEFAULT_BACKGROUND}"
typeset -g POWERLEVEL9K_TIME_VISUAL_IDENTIFIER_EXPANSION=''

# execution time segment setup
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_THRESHOLD=0
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_PRECISION=3
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_FOREGROUND="${DEFAULT_FOREGROUND}"
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_BACKGROUND="${DEFAULT_BACKGROUND}"
typeset -g POWERLEVEL9K_COMMAND_EXECUTION_TIME_ICON="\u23F1"

# root indicator segment setup
#typeset -g POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND="${DEFAULT_FOREGROUND}"
#typeset -g POWERLEVEL9K_ROOT_INDICATOR_FOREGROUND="magenta"
#typeset -g POWERLEVEL9K_ROOT_INDICATOR_BACKGROUND="${DEFAULT_BACKGROUND}"
#typeset -g POWERLEVEL9K_USER_ROOT_ICON=$'\uF198'  # 

#load segment setup
typeset -g POWERLEVEL9K_LOAD_VISUAL_IDENTIFIER_EXPANSION=''
typeset -g POWERLEVEL9K_LOAD_WHICH=1

# custom segments setup
typeset -g POWERLEVEL9K_GO_VERSION_BACKGROUND="${DEFAULT_BACKGROUND}"
typeset -g POWERLEVEL9K_GO_VERSION_FOREGROUND="${DEFAULT_FOREGROUND}"
typeset -g POWERLEVEL9K_PYTHON_VERSION_BACKGROUND="${ALT_BACKGROUND}"
typeset -g POWERLEVEL9K_PYTHON_VERSION_FOREGROUND="${ALT_FOREGROUND}"
typeset -g POWERLEVEL9K_KUBE_CONTEXT_BACKGROUND="${DEFAULT_BACKGROUND}"
typeset -g POWERLEVEL9K_KUBE_CONTEXT_FOREGROUND="${DEFAULT_FOREGROUND}"
typeset -g POWERLEVEL9K_KUBE_CONTEXT_DEV_FOREGROUND="green"
typeset -g POWERLEVEL9K_KUBE_CONTEXT_STAGE_FOREGROUND="yellow"
typeset -g POWERLEVEL9K_KUBE_CONTEXT_PROD_FOREGROUND="red"
