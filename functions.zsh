function kssh(){
  if [ -n "${KLUSTER}" ]; then
     ssh -F ${HOME}/.ssh/config-${KLUSTER} ${1}
  else
    if [ -z "${1}" -o -z "${2}" ]; then
      echo 'to use either export KLUSTER=cluster-name and then kssh host'
      echo 'or use kssh cluster-name host'
    else
      ssh -F ${HOME}/.ssh/config-${1} ${2}
    fi
  fi
}

function kc(){
  if [ -n "${1}" ]; then
    echo 'kc "context"'
  fi 

  kubectl config use-context ${1}
}

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
    minikube status >/dev/null 2>&1
    if [ $? -ne 0 ]; then
      case ${OSTYPE} in
        linux*)
          minikube start --vm-driver kvm2 --loglevel 0 --logtostderr \
            --cpus 6 \
            --memory 8192 \
            --extra-config=kubelet.authentication-token-webhook=true \
            --extra-config=kubelet.authorization-mode=Webhook \
            --extra-config=scheduler.address=0.0.0.0 \
            --extra-config=controller-manager.address=0.0.0.0 
        ;;
        darwin*)
          minikube start --loglevel 0 --logtostderr
        ;;
      esac
    fi
    # eval $(minikube docker-env)
    kubectl config use-context minikube >/dev/null 2>&1
}

function docker_kube(){
    eval $(minikube docker-env)
}

### These functions are for prompt customization
zsh_wifi_signal(){
  case ${OSTYPE} in
    darwin*)
      local signal=$(/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport -I | grep CtlRSSI | awk '{print $2}')
      local color="yellow"
      [[ $signal -gt -50 ]] && color="green"
      [[ $signal -lt -75 ]] && color="red"
    ;;
    linux*)
      local signal=$(nmcli -t device wifi 2>/dev/null | grep '^*' | awk -F':' '{print $6}')
      local color="009"
      [[ $signal -gt 75 ]] && color="green"
      [[ $signal -lt 50 ]] && color="red"
    ;;
  esac
  echo -n "%F{$color}\uf1eb" # \uf1eb is 
}

zsh_go_version(){
    # local goversion=`go version | awk ' { print $3}'`
    local goversion=`goenv version | cut -d\  -f1`
    echo -n "\uE626 go: ${goversion/go/}"
}

zsh_python_version() {
    local pyversion=`python --version 2>&1 | awk ' { print ($NF)}'`
    echo -n "\uE73C python: ${pyversion} "
    if [[ -n "${PYENV_VERSION}" ]]; then
        echo -n "(${PYENV_VERSION})"
    fi
}

zsh_kube_context() {
    # local context=`kubectl config current-context`
    local context=`grep current-context ~/.kube/config | cut -d\  -f2`
    local namespace=`kubectl config get-contexts --no-headers | awk '$2 == "${context}" { print $5 }'`
    if [ "${namespace}" = "" ]; then
        namespace='default'
    fi
    echo -n "\uE7B2 k8s: ${context}/${namespace}"
}

wttr() {
    curl -H "Accept-Language: ${LANG%_*}" https://wttr.in/"${1:-San%20Antonio,TX}"
}

