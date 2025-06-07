####################################
### FUNCTIONS FOR INITIALIZATION ###
#####################################
is_stale_file() {
  local file="$1"
  local max_age_seconds="${2:-86400}"  # default: 24 hours

  if [[ ! -e "$file" ]]; then
    return 0  # Treat missing files as stale
  fi

  local now epoch
  now=$(date +%s)
  epoch=$(stat -f %m "$file" 2>/dev/null)

  (( (now - epoch) > max_age_seconds ))
}

prepend_path() {
  local dir="$1"
  [[ -d "$dir" ]] || return
  [[ ":$PATH:" == *":$dir:"* ]] || PATH="${dir}:${PATH}"
}

append_path() {
  local dir="$1"
  [[ -d "$dir" ]] || return
  [[ ":$PATH:" == *":$dir:"* ]] || PATH="${PATH}:${dir}"
}

remove_path() {
  local dir="$1"
  PATH=$(print -r -- $PATH | tr ':' '\n' | grep -vFx "$dir" | paste -sd:)
}

clean_path() {
  PATH=$(print -r -- $PATH | tr ':' '\n' | awk '!seen[$0]++' | paste -sd:)
}

source_compiled() {
  local file="$1"
  [[ -f "$file" ]] || return 1
  [[ ! -f "${file}.zwc" || "$file" -nt "${file}.zwc" ]] && zcompile "$file"
  source "$file"
}

##########################################################
### INLINE DECLARATIONS REQUIRED FOR OTHER ZSH SCRIPTS ###
##########################################################
# Are we running in WSL?
if [[ -r /proc/sys/kernel/osrelease ]] && grep -qEi 'microsoft|wsl' /proc/sys/kernel/osrelease; then
  export IS_WSL=1
else
  export IS_WSL=0
fi

# Are we running on OSX?
case "$OSTYPE" in
  darwin*) export IS_MACOS=1 ;;
  *)       export IS_MACOS=0 ;;
esac

all_paths=(
  "${HOME}/bin"
  "/usr/local/bin"
  "/usr/local/sbin"
  "/usr/bin"
  "/usr/sbin"
  "/usr/X11/bin"
  "/bin"
  "/sbin"
  "/mnt/c/Windows"
  "/mnt/c/Users/richa/AppData/Local/Microsoft/WindowsApps"
  "/mnt/c/Program Files/Microsoft VS Code/bin"
  "/mnt/c/Windows/System32"
  "/mnt/c/Program Files/Kubernetes/Minikube"
  "/var/lib/snapd/snap/bin"
  "/opt/homebrew/opt/mysql/bin"
)

for dir in "${all_paths[@]}"; do
  append_path "$dir"
done
