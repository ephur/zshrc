########################################
# General Utility Functions
#
# Functions for various utility operations:
# - ff: Find files by pattern in name
# - fe: Find files by pattern and execute command on them
# - wttr: Get weather from wttr.in
# - codec: Get video codec information using ffmpeg
# - extract: Universal archive extraction
# - uuid: Generate UUID
# - b64e / b64d: Base64 encode/decode
# - ts: Timestamp conversion
# - mkcd: Create directory and cd into it
# - up: Go up N directories
# - large: Find largest files/dirs in current directory
# - pkill-fzf: Kill process by name with fzf
# - portproc: Find process using a port
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
  find . -type f -iname '*'"$*"'*' -ls
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
  find . -type f -iname '*'"${1:-}"'*' -exec "${2:-file}" {} \;
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

# Universal archive extraction
# Usage: extract <archive-file>
# Example: extract archive.tar.gz
function extract() {
  if [[ ! -f "$1" ]]; then
    echo "Error: '$1' is not a valid file"
    return 1
  fi

  case "$1" in
    *.tar.bz2|*.tbz2) tar xjf "$1" ;;
    *.tar.gz|*.tgz)   tar xzf "$1" ;;
    *.tar.xz|*.txz)   tar xJf "$1" ;;
    *.tar)            tar xf "$1" ;;
    *.bz2)            bunzip2 "$1" ;;
    *.gz)             gunzip "$1" ;;
    *.zip)            unzip "$1" ;;
    *.Z)              uncompress "$1" ;;
    *.7z)             7z x "$1" ;;
    *.rar)            unrar x "$1" ;;
    *) echo "Error: '$1' cannot be extracted via extract()"; return 1 ;;
  esac
}

# Generate UUID (lowercase)
# Usage: uuid
function uuid() {
  uuidgen | tr '[:upper:]' '[:lower:]'
}

# Base64 encode
# Usage: b64e <string>
# Example: b64e "hello world"
function b64e() {
  if [[ -z "$1" ]]; then
    echo "Usage: b64e <string>"
    return 1
  fi
  echo -n "$1" | base64
}

# Base64 decode
# Usage: b64d <encoded-string>
# Example: b64d "aGVsbG8gd29ybGQ="
function b64d() {
  if [[ -z "$1" ]]; then
    echo "Usage: b64d <encoded-string>"
    return 1
  fi
  echo -n "$1" | base64 -d
}

# Timestamp conversion
# Usage: ts [unix-timestamp]
# Example: ts           # Get current timestamp
# Example: ts 1638360000  # Convert timestamp to date
function ts() {
  if [[ -z "$1" ]]; then
    date +%s
  else
    date -r "$1"
  fi
}

# Go up N directories
# Usage: up [N]
# Example: up 3   # Go up 3 directories
function up() {
  local levels=${1:-1}
  local path=""
  for ((i=0; i<levels; i++)); do
    path="../$path"
  done
  cd "$path" || return
}

# Find largest files/dirs in current directory
# Usage: large [N]
# Example: large 10   # Show top 10 largest
function large() {
  local count=${1:-20}
  du -h -d 1 | sort -h -r | head -n "$count"
}

# Kill process by name with fzf selector
# Usage: pkill-fzf
function pkill-fzf() {
  if ! command -v fzf &>/dev/null; then
    echo "Error: fzf not installed"
    return 1
  fi
  local pid
  pid=$(ps aux | fzf | awk '{print $2}')
  if [[ -n "$pid" ]]; then
    echo "Killing process $pid..."
    kill "$pid"
  fi
}

# Find process using a specific port
# Usage: portproc <port>
# Example: portproc 8080
function portproc() {
  if [[ -z "$1" ]]; then
    echo "Usage: portproc <port>"
    echo "Example: portproc 8080"
    return 1
  fi
  local pids
  pids=$(lsof -ti ":$1")
  if [[ -n "$pids" ]]; then
    echo "$pids" | xargs ps -p
  else
    echo "No process found using port $1"
  fi
}
