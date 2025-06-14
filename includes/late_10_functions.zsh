function retag(){
  git tag -d ${1}
  git tag ${1}
  git push origin :${1}
  git push origin ${1}
}

function awsregion() {
    if [ -z ${1} ]; then
        echo "awsregion is ${AWS_DEFAULT_REGION}"
    else
        export AWS_DEFAULT_REGION=${1}
    fi
}

# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'$*'*' -ls ; }

# Find a file with pattern $1 in name and Execute $2 on it:
function fe() { find . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;  ; }

function kubeme(){
  local minikube_version=${1:="v1.19.6"}
  minikube status >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    case ${OSTYPE} in
      linux*)
        # --logtostderr \
        # --stderrthreshold 0 \
        minikube start --kubernetes-version ${minikube_version} --vm-driver kvm2 \
          --cpus 4 \
          --memory 8192 \
          --extra-config=kubelet.authorization-mode=Webhook \
          --extra-config=scheduler.address=0.0.0.0 \
          --extra-config=controller-manager.address=0.0.0.0 \
          --addons ingress
          #--extra-config=kubelet.authentication-token-webhook=true \
          #--extra-config=apiserver.enable-admission-plugins=PodSecurityPolicy
      ;;
      darwin*)
        minikube --kubernetes-version ${minikube_version} start
      ;;
    esac
  fi
  kubectl config use-context minikube >/dev/null 2>&1
}

function docker_kube(){
  eval $(minikube docker-env)
}

wttr() {
  curl -H "Accept-Language: ${LANG%_*}" https://wttr.in/"${1:-San%20Antonio,TX}"
}

function codec() {
  ffmpeg -i "$1" 2>&1 | grep Stream | grep -Eo '(Audio|Video)\: [^ ,]+'
}

function nfs_mount(){
  if [[ -f "/etc/nfstab" ]]; then
    sudo mount -aT /etc/nfstab
  fi
  echo "/etc/nfstab doesn't exist"
}

function unset_aws(){
  for i in `env | grep '^AWS' | cut -d= -f1`;
    do
    unset $i
  done
}

function check_op() {
  if which op >/dev/null 2>&1; then
    return 0
  else
    echo "1password CLI tool not installed, get it at: https://support.1password.com/command-line-getting-started/"
    return 1
  fi
}

function ops() {
  check_op || return 1
  eval $(op signin $1)
}

function opg() {
  check_op || return 1
  op_account=$1
  shift
  item="$@"
  op --account ${op_account} get item ${item} --fields password | pbcopy
}

function dq() {
  if [[ -z "$1" ]]; then
    echo "Usage: dq <domain> [record_type]"
    return 1
  fi
  local domain="$1"
  local type="${2:-ANY}"
  local g=$(dig +noall +answer +short @8.8.8.8 "$domain" "$type")
  local c=$(dig +noall +answer +short @1.1.1.1 "$domain" "$type")
  local o=$(dig +noall +answer +short @208.67.222.222 "$domain" "$type")

  echo "Various Results for $domain ($type)"
  echo ""
  echo "$g via google/8.8.8.8"
  echo "$c via cloudflare/1.1.1.1"
  echo "$o via opendns/208.67.222.222"
}

# Some functions to allow for better control of display and power management
# Validation function: Validates the duration and ensures required commands are available
validate_caffeinate_and_duration() {
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

# General function to run cmatrix with specified sleep prevention
run_with_cmatrix() {
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

# Prevent sleep and display sleep with fullscreen cmatrix
nosleep() {
  run_with_cmatrix "nosleep" "$1"
}

# Prevent lock screen with fullscreen cmatrix
nolock() {
  run_with_cmatrix "nolock" "$1"
}

resrc() {
  if [[ "$1" == "plugins" ]]; then
    find "$ZSH_CACHE_DIR" -mindepth 1 -delete
  else
    find "$ZSH_CACHE_DIR" -mindepth 1 ! -type d -maxdepth 1 -delete
  fi
  exec zsh
}
