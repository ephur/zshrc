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
          minikube start --kubernetes-version v1.14.4 --vm-driver kvm2 \
            --logtostderr \
            --stderrthreshold 0 \
            --cpus 6 \
            --memory 8192 \
            --extra-config=kubelet.authentication-token-webhook=true \
            --extra-config=kubelet.authorization-mode=Webhook \
            --extra-config=scheduler.address=0.0.0.0 \
            --extra-config=controller-manager.address=0.0.0.0
        ;;
        darwin*)
          minikube --kubernetes-version v1.14.4 start
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

prompt_go_version(){
    # local goversion=`go version | awk ' { print $3}'`
    local goversion=`goenv version | cut -d\  -f1`
    #echo -n "\uE626 go: ${goversion/go/}"
    p10k segment -i $'\uE626' -t "go: ${goversion/go/}"
}

prompt_python_version() {
    local pyversion=`python --version 2>&1 | awk ' { print ($NF)}'`
    if [[ -n "${PYENV_VERSION}" ]]; then
      pyversion=${PYENV_VERSION}
    fi
    p10k segment -i $'\uE73C' -t "python: ${pyversion}"
}

prompt_kube_context() {
    # local context=`kubectl config current-context`
    CLUSTER_FILE=${ZSH_CACHE_DIR}/or-clusters
    local context=`grep current-context ~/.kube/config | cut -d\  -f2`
    local namespace=`kubectl config get-contexts --no-headers | awk '$2 == "${context}" { print $5 }'`
    if [ "${namespace}" = "" ]; then
        namespace='default'
    fi
    local env=$(test -f ${CLUSTER_FILE} && grep ${context} ${CLUSTER_FILE} | cut -d\; -f1) 
    if [ -z "${env}" ]; then
      env="unknown"
    fi
    p10k segment -s ${env} -i $'\uE7B2' -t "k8s: ${context}/${namespace}"
}

joblog() {
  if [ -z "${1}" ]; then
    echo "usage: joblog search-string [context]"
  else
    if [ ! -z "${2}" ]; then
      export CONTEXT="--context ${2}"
    else
      export CONTEXT=""
    fi
    COUNT=$(kubectl `eval echo ${CONTEXT}` -n jobs get pods | grep Running | grep ${1} | awk '{ print $1 }' | wc -l)
    if [ $COUNT -lt 1 ]; then
      echo "no Running pods matching ${1}"
    elif [ $COUNT -gt 1 ]; then
      echo "multiple matching running jobs found, be more specific with your search string"
      kubectl `eval echo ${CONTEXT}` -n jobs get pods | grep Running | grep ${1}
    else
      kubectl `eval echo ${CONTEXT}` -n jobs get pods | grep Running | grep ${1} | awk '{ print $1 }' | head -1 | xargs kubectl `eval echo ${CONTEXT}` -n jobs logs -fc main
    fi
  fi
}

docker_auth(){
  # activates a docker auth, expects ~/.docker/config-<name>.json for auth to activate
  if [ -f ${HOME}/.docker/config-${1}.json ]; then
    /bin/cp -bf ${HOME}/.docker/config-${1}.json ${HOME}/.docker/config.json
  else
    echo "Can't find expected docker auth config: ${HOME}/.docker/config-${1}.json"
  fi
}

wttr() {
    curl -H "Accept-Language: ${LANG%_*}" https://wttr.in/"${1:-San%20Antonio,TX}"
}

function codec() {
  ffmpeg -i "$1" 2>&1 | grep Stream | grep -Eo '(Audio|Video)\: [^ ,]+'
}

update_cluster_map(){ 
  CLUSTER_FILE=${ZSH_CACHE_DIR}/or-clusters
  ## this is not a very portable function, relies on specific objectrocket stuff
  if [ -f ${CLUSTER_FILE}.tmp ]; then
    rm ${CLUSTER_FILE}.tmp
  fi

  eval dev
  for i in `or-infra cluster get | jq --raw-output .name`; do 
    echo "dev;$i" >> ${CLUSTER_FILE}.tmp
  done

  eval stage
  for i in `or-infra cluster get | jq --raw-output .name`; do 
    echo "stage;$i" >> ${CLUSTER_FILE}.tmp
  done

  eval prod
  for i in `or-infra cluster get | jq --raw-output .name`; do 
    echo "prod;$i" >> ${CLUSTER_FILE}.tmp
  done

  mv ${CLUSTER_FILE}.tmp ${CLUSTER_FILE}
}
 
