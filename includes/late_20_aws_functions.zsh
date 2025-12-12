########################################
# AWS Helper Functions
#
# Functions for AWS operations:
# - awsregion: Get or set AWS_DEFAULT_REGION
# - unset_aws: Clear all AWS_* environment variables
# - awsp: List and switch AWS profiles
# - ssm: Get SSM parameter value
# - secret: Get secret from Secrets Manager
# - whoami-aws: Show current AWS identity
########################################

# Get or set AWS default region
# Usage: awsregion [region]
# Example: awsregion us-west-2
function awsregion() {
  if [[ -z ${1} ]]; then
    echo "Current AWS region: ${AWS_DEFAULT_REGION:-<not set>}"
  else
    export AWS_DEFAULT_REGION=${1}
    echo "AWS region set to: ${AWS_DEFAULT_REGION}"
  fi
}

# Clear all AWS environment variables
# Usage: unset_aws
function unset_aws() {
  for i in `env | grep '^AWS' | cut -d= -f1`; do
    unset $i
  done
  echo "All AWS_* environment variables cleared"
}

# List and switch AWS profiles (interactive with fzf if available)
# Usage: awsp [profile-name]
# Example: awsp production
function awsp() {
  if [[ -z "$1" ]]; then
    if command -v fzf &>/dev/null && [[ -f ~/.aws/config ]]; then
      local profile=$(grep '^\[profile' ~/.aws/config | sed 's/\[profile \(.*\)\]/\1/' | fzf)
      if [[ -n "$profile" ]]; then
        export AWS_PROFILE="$profile"
        echo "Switched to profile: $AWS_PROFILE"
      fi
    else
      echo "Current AWS profile: ${AWS_PROFILE:-<not set>}"
      echo "Available profiles:"
      grep '^\[profile' ~/.aws/config 2>/dev/null | sed 's/\[profile \(.*\)\]/  \1/'
    fi
  else
    export AWS_PROFILE="$1"
    echo "AWS profile set to: $AWS_PROFILE"
  fi
}

# Show current AWS identity
# Usage: whoami-aws
function whoami-aws() {
  aws sts get-caller-identity
}
