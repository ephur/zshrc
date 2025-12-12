########################################
# Git Helper Functions
#
# Functions for common git operations:
# - retag: Delete and recreate a git tag, then force push to origin
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
  git tag -d ${1}
  git tag ${1}
  git push origin :${1}
  git push origin ${1}
}
