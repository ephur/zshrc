########################################
# Kubernetes Helper Functions
#
# Functions for Kubernetes/Minikube operations:
# - kubeme: Start minikube with configuration
# - docker_kube: Set docker to use minikube's docker daemon
# - kctx: Quick context switch (fzf)
# - kns: Quick namespace switch (fzf)
# - klogs: Get pod logs with fzf selector
# - kexec: Exec into pod with fzf selector
# - kpf: Port forward with fzf selector
########################################

# Start minikube with appropriate configuration for the platform
# Usage: kubeme [kubernetes-version]
# Example: kubeme v1.19.6
function kubeme() {
  local minikube_version=${1:="v1.19.6"}
  if ! minikube status >/dev/null 2>&1; then
    case ${OSTYPE} in
      linux*)
        minikube start --kubernetes-version "${minikube_version}" --vm-driver kvm2 \
          --cpus 4 \
          --memory 8192 \
          --extra-config=kubelet.authorization-mode=Webhook \
          --extra-config=scheduler.address=0.0.0.0 \
          --extra-config=controller-manager.address=0.0.0.0 \
          --addons ingress
      ;;
      darwin*)
        minikube --kubernetes-version "${minikube_version}" start
      ;;
    esac
  fi
  kubectl config use-context minikube >/dev/null 2>&1
}

# Configure docker to use minikube's docker daemon
# Usage: docker_kube
function docker_kube() {
  eval "$(minikube docker-env)"
}

# Quick context switch using fzf
# Usage: kctx [context-name-or-filter]
# Example: kctx                 # Interactive selection
# Example: kctx prod            # Switch to 'prod' or filter by 'prod'
function kctx() {
  if ! command -v fzf &>/dev/null; then
    echo "Error: fzf not installed"
    return 1
  fi

  if [[ -n "$1" ]]; then
    # Check if $1 is an exact match for a context
    if kubectl config get-contexts -o name | grep -q "^${1}$"; then
      kubectl config use-context "$1"
    else
      # Use $1 as a filter for fzf
      local context
      context=$(kubectl config get-contexts -o name | fzf --query="$1" --select-1)
      [[ -n "$context" ]] && kubectl config use-context "$context"
    fi
  else
    # No argument, show all contexts
    local context
    context=$(kubectl config get-contexts -o name | fzf)
    [[ -n "$context" ]] && kubectl config use-context "$context"
  fi
}
alias kubectx=kctx

# Quick namespace switch using fzf
# Usage: kns [namespace-name-or-filter]
# Example: kns                  # Interactive selection
# Example: kns default          # Switch to 'default' or filter by 'default'
function kns() {
  if ! command -v fzf &>/dev/null; then
    echo "Error: fzf not installed"
    return 1
  fi

  if [[ -n "$1" ]]; then
    # Check if $1 is an exact match for a namespace
    if kubectl get namespaces -o name | cut -d/ -f2 | grep -q "^${1}$"; then
      kubectl config set-context --current --namespace="$1"
    else
      # Use $1 as a filter for fzf
      local namespace
      namespace=$(kubectl get namespaces -o name | cut -d/ -f2 | fzf --query="$1" --select-1)
      [[ -n "$namespace" ]] && kubectl config set-context --current --namespace="$namespace"
    fi
  else
    # No argument, show all namespaces
    local namespace
    namespace=$(kubectl get namespaces -o name | cut -d/ -f2 | fzf)
    [[ -n "$namespace" ]] && kubectl config set-context --current --namespace="$namespace"
  fi
}
alias kubens=kns

# Get pod logs with fzf selector
# Usage: klogs
function klogs() {
  if ! command -v fzf &>/dev/null; then
    echo "Error: fzf not installed"
    return 1
  fi
  local pod
  pod=$(kubectl get pods -o name | fzf)
  [[ -n "$pod" ]] && kubectl logs -f "$pod"
}

# Exec into pod with fzf selector
# Usage: kexec [shell]
# Example: kexec /bin/bash
function kexec() {
  if ! command -v fzf &>/dev/null; then
    echo "Error: fzf not installed"
    return 1
  fi
  local shell="${1:-/bin/sh}"
  local pod
  pod=$(kubectl get pods -o name | fzf)
  [[ -n "$pod" ]] && kubectl exec -it "$pod" -- "$shell"
}

# Port forward with fzf selector
# Usage: kpf [local-port[:remote-port]]
# Example: kpf 8080
# Example: kpf 8080:80
function kpf() {
  if ! command -v fzf &>/dev/null; then
    echo "Error: fzf not installed"
    return 1
  fi
  local port="${1:-8080}"
  local pod
  pod=$(kubectl get pods -o name | fzf)
  [[ -n "$pod" ]] && kubectl port-forward "$pod" "$port"
}
