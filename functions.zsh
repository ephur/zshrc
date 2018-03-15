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

function retag(){
  git tag -d ${1}
  git tag ${1}
  git push origin :${1}
  git push origin ${1}
}

function awsregion() {
    if [ -z ${1} ]; then
        echo 'awsregion region_to_set_as_default'
    else
        export AWS_DEFAULT_REGION=${1}
    fi
}

function getRoles() {
    local kind="${1}"
    local name="${2}"
    local namespace="${3:-}"

    kubectl get clusterrolebinding -o json | jq -r "
      .items[]
      |
      select(
        .subjects[]?
        |
        select(
            .kind == \"${kind}\"
            and
            .name == \"${name}\"
            and
            (if .namespace then .namespace else \"\" end) == \"${namespace}\"
        )
      )
      |
      (.roleRef.kind + \"/\" + .roleRef.name)
    "

    kubectl get rolebinding -o json | jq -r "
      .items[]
      |
      select(
        .subjects[]?
        |
        select(
            .kind == \"${kind}\"
            and
            .name == \"${name}\"
            and
            (if .namespace then .namespace else \"\" end) == \"${namespace}\"
        )
      )
      |
      (.roleRef.kind + \"/\" + .roleRef.name)
    "
}

# Find a file with a pattern in name:
function ff() { find . -type f -iname '*'$*'*' -ls ; }

# Find a file with pattern $1 in name and Execute $2 on it:
function fe() { find . -type f -iname '*'${1:-}'*' -exec ${2:-file} {} \;  ; }

function kubeme(){
    minikube status >/dev/null 2>&1
    if [ $? -ne 0 ]; then
        minikube start --vm-driver kvm2 --loglevel 0 --logtostderr
    fi
    eval $(minikube docker-env)
    kubectl config use-context minikube >/dev/null 2>&1
}

### These functions are for prompt customization
zsh_wifi_signal(){
	local signal=$(nmcli -t device wifi 2>/dev/null | grep '^*' | awk -F':' '{print $6}')
    local color="009"
    [[ $signal -gt 75 ]] && color="green"
    [[ $signal -lt 50 ]] && color="red"
    echo -n "%F{$color}\uf1eb" # \uf1eb is 
}

zsh_go_version(){
    local goversion=`go version | awk ' { print $3}'`
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
    local context=`kubectl config current-context`
    local namespace=`kubectl config get-contexts --no-headers | awk '$2 == "minikube" { print $5 }'`
    if [ "${namespace}" = "" ]; then
        namespace='default'
    fi
    echo -n "\uE7B2 k8s: ${context}/${namespace}"
}
