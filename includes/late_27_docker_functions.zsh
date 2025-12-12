########################################
# Docker Helper Functions
#
# Functions for Docker operations:
# - dclean: Clean up dangling images and stopped containers
# - dexec: Interactive container exec (fzf)
# - dlogs: Interactive container logs (fzf)
# - dstop: Stop all running containers
########################################

# Clean up dangling images, stopped containers, and unused volumes
# Usage: dclean
function dclean() {
  echo "Cleaning up Docker resources..."
  docker system prune -f
  docker volume prune -f
  echo "Docker cleanup complete"
}

# Interactive container exec using fzf
# Usage: dexec [shell]
# Example: dexec /bin/bash
function dexec() {
  if ! command -v fzf &>/dev/null; then
    echo "Error: fzf not installed"
    docker ps --format '{{.Names}}'
    return 1
  fi
  local shell="${1:-/bin/sh}"
  local container=$(docker ps --format '{{.Names}}' | fzf)
  [[ -n "$container" ]] && docker exec -it "$container" "$shell"
}

# Interactive container logs using fzf
# Usage: dlogs
function dlogs() {
  if ! command -v fzf &>/dev/null; then
    echo "Error: fzf not installed"
    docker ps --format '{{.Names}}'
    return 1
  fi
  local container=$(docker ps --format '{{.Names}}' | fzf)
  [[ -n "$container" ]] && docker logs -f "$container"
}

# Stop all running containers
# Usage: dstop
function dstop() {
  local containers=$(docker ps -q)
  if [[ -z "$containers" ]]; then
    echo "No running containers to stop"
  else
    docker ps -q | xargs docker stop
    echo "All containers stopped"
  fi
}
