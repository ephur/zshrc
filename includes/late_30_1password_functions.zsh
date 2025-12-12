########################################
# 1Password CLI Functions
#
# Functions for 1Password CLI operations:
# - check_op: Verify op CLI is installed
# - ops: Sign in to 1Password
# - opg: Get password from 1Password and copy to clipboard
########################################

# Check if 1Password CLI is installed
function check_op() {
  if which op >/dev/null 2>&1; then
    return 0
  else
    echo "1password CLI tool not installed, get it at: https://support.1password.com/command-line-getting-started/"
    return 1
  fi
}

# Sign in to 1Password account
# Usage: ops <account>
# Example: ops my-account
function ops() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: ops <account>"
    echo "Example: ops my-account"
    return 1
  fi
  check_op || return 1
  eval $(op signin $1)
}

# Get password from 1Password and copy to clipboard
# Usage: opg <account> <item-name>
# Example: opg my-account "GitHub"
function opg() {
  if [[ $# -lt 2 ]]; then
    echo "Usage: opg <account> <item-name>"
    echo "Example: opg my-account 'GitHub'"
    return 1
  fi
  check_op || return 1
  op_account=$1
  shift
  item="$@"
  op --account ${op_account} get item ${item} --fields password | pbcopy
}
