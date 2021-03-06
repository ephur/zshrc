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
  local minikube_version=${1:="v1.17.4"}
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
          --extra-config=controller-manager.address=0.0.0.0
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

kflog() {
  if [ -z "${1}" ]; then
    echo "usage: joblog search-string [container]"
  else
    if [ ! -z "${2}" ]; then
      export CONTAINER="-c ${2}"
    else
      export CONTAINER=""
    fi
    COUNT=$(kubectl -n kubeflow get pods | grep Running | grep ${1} | awk '{ print $1 }' | wc -l)
    if [ $COUNT -lt 1 ]; then
      echo "no Running pods matching ${1}"
    elif [ $COUNT -gt 1 ]; then
      echo "multiple matching running jobs found, be more specific with your search string"
      kubectl -n kubeflow get pods | grep Running | grep ${1}
    else
      kubectl -n kubeflow get pods | grep Running | grep ${1} | awk '{ print $1 }' | head -1 | xargs kubectl -n kubeflow logs -f ${CONTAINER}
    fi
  fi
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

# powerlevel 10 custom kube_context segment
prompt_kube_context() {
  # powerlevel10 has a builtin context, but want some extra features
  CLUSTER_FILE=${ZSH_CACHE_DIR}/or-clusters
  local context=`test -f ~/.kube/config && grep current-context ~/.kube/config | cut -d\  -f2`
  if [[ -z $context ]]; then
   context='unknown'
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

# used in conjunction with custom kube_context segment
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

watch_nodes(){
  if [[ -z $1 ]]; then
    ctx_string=""
  else
    ctx_string="--context=$1"
  fi

  watch -n1 kubectl $ctx_string get nodes --sort-by='.metadata.labels.node-role\.objectrocket\.cloud'
}

function update_completions(){
	# Add kubectl/minikube/helm completions, any argument sources existing caches only
  # while running with no arguments will also generate new completions
	local source_only=${1}
	for i in kubectl minikube helm; do
    local cfile="${ZSH_CACHE_DIR}/${i}.completion"
		if ! [[ -z ${source_only} ]] && (which $i 2>/dev/null 1>/dev/null); then
      ${i} completion zsh > ${cfile}
    fi
    [[ -f ${cfile} ]] && source ${cfile}
  done
}

function nfs_mount(){
  if [[ -f "/etc/nfstab" ]]; then 
    sudo mount -aT /etc/nfstab
  fi 
  echo "/etc/nfstab doesn't exist"
}

