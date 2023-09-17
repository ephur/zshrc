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

# powerlevel 10 custom kube_context segment
prompt_kube_context() {
  # powerlevel10 has a builtin context, but want some extra features
  CLUSTER_FILE=${ZSH_CACHE_DIR}/k8s-clusters
  local context=`test -f ~/.kube/config && grep current-context ~/.kube/config | cut -d\  -f2`
  if [[ -z $context ]]; then
   context='unknown'
  fi
  if [[ "$context" =~ "arn:aws*" ]]; then
    context=${context#*/}
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

#watch_nodes(){
#  if [[ -z $1 ]]; then
#    ctx_string=""
#  else
#    ctx_string="--context=$1"
#  fi
#
#  watch -n1 kubectl $ctx_string get nodes --sort-by='.metadata.labels.node-role\.objectrocket\.cloud'
#}

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
  [[ -z "$1" ]] && echo "dq <domain>" && exit 1

  g=$(dig +noall +answer +short @8.8.8.8 $1)
  c=$(dig +noall +answer +short @1.1.1.1 $1)
  o=$(dig +noall +answer +short @208.67.222.222 $1)
  d=$(dig +noall +answer +short +identify $1)

  echo "Various Results for $1"
  echo ""
  echo "${d}"
  echo ""
  echo "${g} via google/8.8.8.8"
  echo "${c} via cloudflare/1.1.1.1"
  echo "${o} via opendns/208.67.222.222"
}

function tdl() {
  # a terraform dev deploy
  limit=$1; shift;
  ./terraform-deploy -d ${PROJECTS} -l $limit $@
}
