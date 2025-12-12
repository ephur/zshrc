########################################
# Git Helper Functions
#
# Functions for common git operations:
# - retag: Delete and recreate a git tag, then force push to origin
# - gb: Interactive branch switcher (fzf)
# - gca: Quick commit amend without editing message
# - glo: Git log with fzf preview
# - gnb: Create branch and push with tracking
########################################

# Re-tag and force push a git tag
# Usage: retag <tag-name>
# Example: retag v1.0.0
function retag() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: retag <tag-name>"
    echo "Example: retag v1.0.0"
    return 1
  fi
  git tag -d "${1}"
  git tag "${1}"
  git push origin :"${1}"
  git push origin "${1}"
}

# Interactive branch switcher using fzf
# Usage: gb
function gb() {
  if ! command -v fzf &>/dev/null; then
    echo "Error: fzf not installed"
    return 1
  fi
  local branch
  branch=$(git branch | fzf)
  if [[ -n "$branch" ]]; then
    branch=$(echo "$branch" | sed 's/^[* ]*//')  # Remove leading spaces and asterisk
    git checkout "$branch"
  fi
}

# Quick commit amend without editing message
# Usage: gca
function gca() {
  git commit --amend --no-edit
}

# Show git log with fzf preview
# Usage: glo
function glo() {
  if ! command -v fzf &>/dev/null; then
    echo "Error: fzf not installed"
    return 1
  fi
  git log --oneline --color=always | \
    fzf --ansi --preview 'git show --color=always {1}' --preview-window=right:60%
}

# Create branch and push with tracking
# Usage: gnb <branch-name>
# Example: gnb feature/new-api
function gnb() {
  if [[ -z "$1" ]]; then
    echo "Usage: gnb <branch-name>"
    echo "Example: gnb feature/new-api"
    return 1
  fi
  git checkout -b "$1" && git push -u origin "$1"
}
