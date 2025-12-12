########################################
# System/Display Management Functions
#
# Functions for system power and display management:
# - nosleep: Prevent system and display sleep with fullscreen cmatrix (macOS)
# - nolock: Prevent lock screen with fullscreen cmatrix (macOS)
# - nfs_mount: Mount NFS shares from /etc/nfstab
#
# Internal functions:
# - validate_caffeinate_and_duration: Validate prerequisites for nosleep/nolock
# - run_with_cmatrix: Core implementation for nosleep/nolock
########################################

# Validate caffeinate prerequisites and duration parameter
function validate_caffeinate_and_duration() {
  local duration=$1

  # Check if `caffeinate` is available
  if ! command -v caffeinate >/dev/null 2>&1; then
    echo "Error: 'caffeinate' is not installed or not in your PATH."
    return 1
  fi

  # Check if `cmatrix` is available
  if ! command -v cmatrix >/dev/null 2>&1; then
    echo "Error: 'cmatrix' is not installed or not in your PATH."
    return 1
  fi

  # Check if Alacritty is available
  if ! command -v alacritty >/dev/null 2>&1; then
    echo "Error: 'alacritty' is not installed or not in your PATH."
    return 1
  fi

  # Validate duration as a positive integer
  if ! [[ "$duration" =~ ^[0-9]+$ ]]; then
    echo "Error: Invalid duration '$duration'. Please provide a positive integer in minutes."
    return 1
  fi

  return 0
}

# Core implementation for running cmatrix with sleep prevention
function run_with_cmatrix() {
  local mode=$1 # "nosleep" or "nolock"
  local duration=${2:-60} # Default to 60 minutes

  # Validate inputs
  validate_caffeinate_and_duration "$duration" || return 1

  # Convert duration to seconds
  local duration_in_seconds=$((duration * 60))

  # Determine caffeinate flags as an array
  local caffeinate_flags=()
  if [[ "$mode" == "nosleep" ]]; then
    caffeinate_flags=(-d -i) # Prevent system and display sleep
  elif [[ "$mode" == "nolock" ]]; then
    caffeinate_flags=(-i) # Prevent lock screen but allow display sleep
  else
    echo "Invalid mode: $mode. Use 'nosleep' or 'nolock'."
    return 1
  fi

  # Launch cmatrix in Alacritty fullscreen
  echo "Running '$mode' mode with fullscreen cmatrix for $duration minutes..."
  alacritty --config-file ~/.config/alacritty/alacritty.toml \
            --class cmatrix \
            --option "window.startup_mode=\"Fullscreen\"" \
            --command sh -c "cmatrix -b; sleep $duration_in_seconds" &

  # Keep the system awake
  caffeinate "${caffeinate_flags[@]}" -t "$duration_in_seconds"

  # Kill the Alacritty window after duration
  pkill -f "cmatrix"
}

# Prevent system and display sleep with fullscreen cmatrix (macOS only)
# Usage: nosleep [duration-in-minutes]
# Example: nosleep 30
function nosleep() {
  if [[ $IS_MACOS -eq 0 ]]; then
    echo "Error: nosleep is only available on macOS"
    return 1
  fi
  if [[ $# -eq 0 ]]; then
    echo "Usage: nosleep <duration-in-minutes>"
    echo "Example: nosleep 30"
    return 1
  fi
  run_with_cmatrix "nosleep" "$1"
}

# Prevent lock screen with fullscreen cmatrix (macOS only)
# Usage: nolock [duration-in-minutes]
# Example: nolock 120
function nolock() {
  if [[ $IS_MACOS -eq 0 ]]; then
    echo "Error: nolock is only available on macOS"
    return 1
  fi
  if [[ $# -eq 0 ]]; then
    echo "Usage: nolock <duration-in-minutes>"
    echo "Example: nolock 120"
    return 1
  fi
  run_with_cmatrix "nolock" "$1"
}

# Mount NFS shares from /etc/nfstab
# Usage: nfs_mount
function nfs_mount() {
  if [[ -f "/etc/nfstab" ]]; then
    sudo mount -aT /etc/nfstab
  else
    echo "/etc/nfstab doesn't exist"
  fi
}
