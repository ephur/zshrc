########################################
# Network Utility Functions
#
# Functions for network operations:
# - dq: Query DNS across multiple resolvers (Google, Cloudflare, OpenDNS)
# - port: Check what's using a port
# - myip: Get public IP address
# - httptest: Quick HTTP test with timing
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

# Check what process is using a port
# Usage: port <port-number>
# Example: port 8080
function port() {
  if [[ -z "$1" ]]; then
    echo "Usage: port <port-number>"
    echo "Example: port 8080"
    return 1
  fi
  lsof -i ":$1"
}

# Get public IP address
# Usage: myip [4|6]
# Example: myip     # Default (both IPv4 and IPv6)
# Example: myip 4   # IPv4 only
# Example: myip 6   # IPv6 only
function myip() {
  local url="https://icanhazip.com"

  if [[ "$1" == "4" ]]; then
    url="https://ipv4.icanhazip.com"
  elif [[ "$1" == "6" ]]; then
    url="https://ipv6.icanhazip.com"
  fi

  curl -s "$url" | tr -d '\n'
  echo
}

# Quick HTTP test with timing information
# Usage: httptest <url>
# Example: httptest https://google.com
function httptest() {
  if [[ -z "$1" ]]; then
    echo "Usage: httptest <url>"
    echo "Example: httptest https://google.com"
    return 1
  fi
  curl -w "\nHTTP: %{http_code}\nTime: %{time_total}s\nSize: %{size_download} bytes\n" -o /dev/null -s "$1"
}
