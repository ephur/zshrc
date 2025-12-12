########################################
# Network Utility Functions
#
# Functions for network operations:
# - dq: Query DNS across multiple resolvers (Google, Cloudflare, OpenDNS)
########################################

# Query DNS across multiple resolvers
# Usage: dq <domain> [record-type]
# Example: dq google.com A
# Example: dq example.com MX
function dq() {
  if [[ -z "$1" ]]; then
    echo "Usage: dq <domain> [record_type]"
    echo "Example: dq google.com A"
    echo "Example: dq example.com MX"
    return 1
  fi
  local domain="$1"
  local type="${2:-ANY}"
  local g=$(dig +noall +answer +short @8.8.8.8 "$domain" "$type")
  local c=$(dig +noall +answer +short @1.1.1.1 "$domain" "$type")
  local o=$(dig +noall +answer +short @208.67.222.222 "$domain" "$type")

  echo "Various Results for $domain ($type)"
  echo ""
  echo "$g via google/8.8.8.8"
  echo "$c via cloudflare/1.1.1.1"
  echo "$o via opendns/208.67.222.222"
}
