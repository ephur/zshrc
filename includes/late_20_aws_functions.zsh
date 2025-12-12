########################################
# AWS Helper Functions
#
# Functions for AWS operations:
# - awsregion: Get or set AWS_DEFAULT_REGION
# - unset_aws: Clear all AWS_* environment variables
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
