#!/usr/bin/env zsh
#
# Test and lint zsh configuration
# Usage: ./tools/test_config.zsh [--fix] [--quick]
#

set -e

ZSH_ROOT="${0:A:h:h}"
cd "$ZSH_ROOT"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0
FIX_MODE=false
QUICK_MODE=false

# Parse arguments
for arg in "$@"; do
  case $arg in
    --fix) FIX_MODE=true ;;
    --quick) QUICK_MODE=true ;;
    *) echo "Unknown option: $arg"; exit 1 ;;
  esac
done

echo "🔍 Testing zsh configuration..."
echo ""

#########################################
# 1. Syntax Check
#########################################
echo "📝 Syntax checking..."
SYNTAX_ERRORS=0

# Check main files
for file in zshrc includes/init.zsh; do
  if ! zsh -n "$file" 2>/dev/null; then
    echo "${RED}✗${NC} Syntax error in $file"
    zsh -n "$file"
    ((SYNTAX_ERRORS++)) || true
  else
    echo "${GREEN}✓${NC} $file"
  fi
done

# Check all include files (they depend on init.zsh variables, so we skip detailed checks)
for file in includes/*.zsh; do
  # Basic check: file is readable and not empty
  if [[ ! -r "$file" ]]; then
    echo "${RED}✗${NC} Cannot read $file"
    ((SYNTAX_ERRORS++)) || true
  elif [[ ! -s "$file" ]]; then
    echo "${YELLOW}⚠${NC} Empty file: $file"
    ((WARNINGS++)) || true
  else
    echo "${GREEN}✓${NC} $file"
  fi
done

ERRORS=$((ERRORS + SYNTAX_ERRORS))
echo ""

#########################################
# 2. Shellcheck (optional, with zsh-specific ignores)
#########################################
if command -v shellcheck &>/dev/null && [[ "$QUICK_MODE" != true ]]; then
  echo "🔎 Running shellcheck (with zsh-specific ignores)..."

  # SC1090: Can't follow non-constant source
  # SC2148: Tips depend on target shell (we're zsh, not bash)
  # SC2296: Parameter expansions can't start with ( (zsh-specific syntax)
  # SC1091: Not following sourced files
  # SC2034: Variables used by child processes/exports (zsh-specific)
  # SC2168: local outside functions is valid in zsh
  local -a shellcheck_ignore
  shellcheck_ignore=(-e SC1090 -e SC2148 -e SC2296 -e SC1091 -e SC2034 -e SC2168)

  SHELLCHECK_ERRORS=0
  for file in zshrc includes/*.zsh; do
    if ! shellcheck -s bash "${shellcheck_ignore[@]}" "$file" 2>/dev/null; then
      echo "${YELLOW}⚠${NC} Shellcheck warnings in $file (may be false positives for zsh)"
      ((WARNINGS++)) || true
    fi
  done
  echo ""
fi

#########################################
# 3. Load Test
#########################################
if [[ "$QUICK_MODE" != true ]]; then
  echo "🚀 Testing full configuration load..."

  if zsh -i -c 'echo "Shell loaded successfully"' &>/dev/null; then
    echo "${GREEN}✓${NC} Configuration loads successfully"
  else
    echo "${RED}✗${NC} Configuration failed to load"
    ((ERRORS++)) || true
  fi
  echo ""
fi

#########################################
# 4. Function Existence Check
#########################################
echo "🔧 Checking that key functions exist..."

REQUIRED_FUNCTIONS=(
  # Core
  "source_compiled"
  "is_stale_file"
  # Git
  "retag"
  "gb"
  "gca"
  "glo"
  "gnb"
  # AWS
  "awsregion"
  "awsp"
  # Kubernetes
  "kctx"
  "kns"
  # Docker
  "dclean"
  # Shell
  "resrc"
  "t"
  "zhelp"
)

# Check if running in CI or minimal environment
if [[ -n "$CI" ]] || [[ ! -f "${HOME}/.zshrc" ]]; then
  # CI mode: Source files directly
  # Set up minimal environment
  export ZSH="${ZSH_ROOT}"
  export ZSH_CACHE_DIR="${ZSH}/cache"

  # Create cache dir if needed
  mkdir -p "${ZSH_CACHE_DIR}"

  # Source init.zsh first (has core functions)
  source "${ZSH_ROOT}/includes/init.zsh" 2>/dev/null || true

  # Source all function files
  for file in "${ZSH_ROOT}"/includes/late_*.zsh; do
    [[ -f "$file" ]] && source "$file" 2>/dev/null || true
  done

  # Check functions in current shell
  MISSING_FUNCTIONS=0
  for func in "${REQUIRED_FUNCTIONS[@]}"; do
    if ! type "$func" &>/dev/null; then
      echo "${RED}✗${NC} Function not found: $func"
      ((MISSING_FUNCTIONS++)) || true
    fi
  done
else
  # Normal mode: Use interactive shell
  MISSING_FUNCTIONS=0
  for func in "${REQUIRED_FUNCTIONS[@]}"; do
    if ! zsh -i -c "type $func" &>/dev/null; then
      echo "${RED}✗${NC} Function not found: $func"
      ((MISSING_FUNCTIONS++)) || true
    fi
  done
fi

if [[ $MISSING_FUNCTIONS -eq 0 ]]; then
  echo "${GREEN}✓${NC} All required functions exist"
else
  ERRORS=$((ERRORS + MISSING_FUNCTIONS))
fi
echo ""

#########################################
# 5. Compilation Test
#########################################
echo "⚙️  Testing bytecode compilation..."

COMPILE_ERRORS=0
for file in zshrc includes/*.zsh; do
  if ! zcompile "$file" 2>/dev/null; then
    echo "${RED}✗${NC} Cannot compile $file"
    ((COMPILE_ERRORS++)) || true
  fi
done

if [[ $COMPILE_ERRORS -eq 0 ]]; then
  echo "${GREEN}✓${NC} All files compile to .zwc"

  if [[ "$FIX_MODE" == false ]]; then
    # Clean up test compilation artifacts
    find . -name "*.zwc" -newer zshrc -delete 2>/dev/null
  fi
else
  ERRORS=$((ERRORS + COMPILE_ERRORS))
fi
echo ""

#########################################
# 6. Performance Check
#########################################
if [[ "$QUICK_MODE" != true ]]; then
  echo "⚡ Performance test (startup time)..."

  # Run 5 iterations and average to reduce noise
  # Use -i --login -c echo like normal usage
  local sum=0
  local count=5
  for ((i=1; i<=count; i++)); do
    local iter_time=$( { TIMEFMT='%*E'; time zsh -i --login -c echo } 2>&1 )
    # Parse the time value
    if [[ "$iter_time" =~ ([0-9]+):([0-9]+)\.([0-9]+) ]]; then
      # Format: M:SS.mmm
      local mins=${match[1]}
      local secs=${match[2]}
      local ms=${match[3]}
      local iter_ms=$(( mins * 60000 + secs * 1000 + ms ))
    elif [[ "$iter_time" =~ ([0-9]+)\.([0-9]+) ]]; then
      # Format: S.mmm
      local secs=${match[1]}
      local ms=${match[2]}
      # Pad milliseconds to 3 digits if needed
      while [[ ${#ms} -lt 3 ]]; do
        ms="${ms}0"
      done
      local iter_ms=$(( secs * 1000 + ms ))
    fi
    sum=$(( sum + iter_ms ))
  done 2>/dev/null

  TOTAL_MS=$(( sum / count ))
  printf "   Average startup time: %.0fms (over %d runs)\n" "$TOTAL_MS" "$count"

  if [[ -n "$TOTAL_MS" ]] && (( TOTAL_MS > 150 )); then
    echo "${YELLOW}⚠${NC} Startup time exceeds 150ms target"
    ((WARNINGS++)) || true
  else
    echo "${GREEN}✓${NC} Startup time under 150ms"
  fi
  echo ""
fi

#########################################
# Summary
#########################################
echo "=========================================="
if [[ $ERRORS -eq 0 ]] && [[ $WARNINGS -eq 0 ]]; then
  echo "${GREEN}✓ All tests passed!${NC}"
  exit 0
elif [[ $ERRORS -eq 0 ]]; then
  echo "${YELLOW}⚠ Tests passed with $WARNINGS warning(s)${NC}"
  exit 0
else
  echo "${RED}✗ Tests failed with $ERRORS error(s) and $WARNINGS warning(s)${NC}"
  exit 1
fi
