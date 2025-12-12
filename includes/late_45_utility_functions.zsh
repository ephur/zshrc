########################################
# General Utility Functions
#
# Functions for various utility operations:
# - ff: Find files by pattern in name
# - fe: Find files by pattern and execute command on them
# - wttr: Get weather from wttr.in
# - codec: Get video codec information using ffmpeg
########################################

# Find files with a pattern in name
# Usage: ff <pattern>
# Example: ff "*.txt"
# Example: ff config
function ff() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: ff <pattern>"
    echo "Example: ff '*.txt'"
    echo "Example: ff config"
    return 1
  fi
  find . -type f -iname '*'$*'*' -ls
}

# Find files with pattern and execute command on them
# Usage: fe <pattern> [command]
# Example: fe "*.log" cat
# Example: fe config file
function fe() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: fe <pattern> [command]"
    echo "Example: fe '*.log' cat"
    echo "Example: fe config file"
    return 1
  fi
  find . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;
}

# Get weather from wttr.in
# Usage: wttr [location]
# Example: wttr "New York"
# Example: wttr Tokyo
function wttr() {
  curl -H "Accept-Language: ${LANG%_*}" https://wttr.in/"${1:-San%20Antonio,TX}"
}

# Get video codec information using ffmpeg
# Usage: codec <video-file>
# Example: codec movie.mp4
function codec() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: codec <video-file>"
    echo "Example: codec movie.mp4"
    return 1
  fi
  ffmpeg -i "$1" 2>&1 | grep Stream | grep -Eo '(Audio|Video)\: [^ ,]+'
}
