########################################
# Format & Data Conversion Functions
#
# Functions for data formatting and conversion:
# - jpretty: Pretty print JSON from clipboard or file
# - y2j: Convert YAML to JSON
# - j2y: Convert JSON to YAML
# - jqp: Interactive JQ playground
########################################

# Pretty print JSON from clipboard or file
# Usage: jpretty [file]
# Example: jpretty data.json
# Example: jpretty    # Uses clipboard
function jpretty() {
  if ! command -v jq &>/dev/null; then
    echo "Error: jq not installed"
    return 1
  fi

  if [[ -z "$1" ]]; then
    if command -v pbpaste &>/dev/null; then
      pbpaste | jq '.'
    else
      echo "Usage: jpretty <file.json>"
      return 1
    fi
  else
    jq '.' "$1"
  fi
}

# Convert YAML to JSON
# Usage: y2j <file.yaml>
# Example: y2j config.yaml
function y2j() {
  if ! command -v yq &>/dev/null; then
    echo "Error: yq not installed"
    return 1
  fi
  if [[ -z "$1" ]]; then
    echo "Usage: y2j <file.yaml>"
    echo "Example: y2j config.yaml"
    return 1
  fi
  yq eval -o=json "$1"
}

# Convert JSON to YAML
# Usage: j2y <file.json>
# Example: j2y data.json
function j2y() {
  if ! command -v yq &>/dev/null; then
    echo "Error: yq not installed"
    return 1
  fi
  if [[ -z "$1" ]]; then
    echo "Usage: j2y <file.json>"
    echo "Example: j2y data.json"
    return 1
  fi
  yq eval -P "$1"
}

# Interactive JQ playground - test queries interactively
# Usage: jqp <file.json>
# Example: jqp data.json
function jqp() {
  if ! command -v jq &>/dev/null; then
    echo "Error: jq not installed"
    return 1
  fi
  if ! command -v fzf &>/dev/null; then
    echo "Error: fzf not installed"
    return 1
  fi
  if [[ -z "$1" ]]; then
    echo "Usage: jqp <file.json>"
    echo "Example: jqp data.json"
    return 1
  fi
  echo '' | fzf --print-query --preview "jq {q} $1 2>/dev/null || echo 'Invalid JQ query'"
}
