########################################
# Kubernetes Helper Functions
#
# Functions for Kubernetes/Minikube operations:
# - kubeme: Start minikube with configuration
# - docker_kube: Set docker to use minikube's docker daemon
########################################

# Start minikube with appropriate configuration for the platform
# Usage: kubeme [kubernetes-version]
# Example: kubeme v1.19.6
function kubeme() {
  local minikube_version=${1:="v1.19.6"}
  minikube status >/dev/null 2>&1
  if [ $? -ne 0 ]; then
    case ${OSTYPE} in
      linux*)
        minikube start --kubernetes-version ${minikube_version} --vm-driver kvm2 \
          --cpus 4 \
          --memory 8192 \
          --extra-config=kubelet.authorization-mode=Webhook \
          --extra-config=scheduler.address=0.0.0.0 \
          --extra-config=controller-manager.address=0.0.0.0 \
          --addons ingress
      ;;
      darwin*)
        minikube --kubernetes-version ${minikube_version} start
      ;;
    esac
  fi
  kubectl config use-context minikube >/dev/null 2>&1
}

# Configure docker to use minikube's docker daemon
# Usage: docker_kube
function docker_kube() {
  eval $(minikube docker-env)
}
