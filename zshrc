# Enable startup trace profiling if env var is set
if [[ "$PROFILE_STARTUP" == true || "$PROFILE_ALL" == true ]]; then
  PS4=$'%D{%H:%M:%S.%.} + '
  exec 3>&2 2>/tmp/zsh_profile.$$
  setopt xtrace
fi

# Powerlevel10k instant prompt: paints a cached prompt immediately while the
# rest of init runs behind it. Keep near the top; anything that prints to the
# console during startup must run before this block (or be silenced).
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Bootstrap core paths
export ZSH="${HOME}/.zsh"
export ZSH_CACHE_DIR="${ZSH}/cache"
export ZSH_INCLUDES="${ZSH}/includes"
if [ ! -d "${ZSH_CACHE_DIR}" ]; then
  if [ -x /bin/mkdir ]; then
    /bin/mkdir -p "${ZSH_CACHE_DIR}"
  elif [ -x /usr/bin/mkdir ]; then
    /usr/bin/mkdir -p "${ZSH_CACHE_DIR}"
  else
    command mkdir -p "${ZSH_CACHE_DIR}"
  fi
fi

# Load core functions
ZSH_INIT_FILE="${ZSH_INCLUDES}/init.zsh"
ZSH_INIT_COMPILED="${ZSH_CACHE_DIR}/compiled/includes_init.zsh.zwc"
[[ -d "${ZSH_CACHE_DIR}/compiled" ]] || mkdir -p "${ZSH_CACHE_DIR}/compiled"
[[ ! -f "${ZSH_INIT_COMPILED}" || "${ZSH_INIT_FILE}" -nt "${ZSH_INIT_COMPILED}" ]] && zcompile "${ZSH_INIT_COMPILED}" "${ZSH_INIT_FILE}"
source "${ZSH_INIT_FILE}"

# Combine, and compile all includes
ALL_COMBINED="${ZSH_CACHE_DIR}/includes_combined.zsh"
if [[ ! -f "$ALL_COMBINED" ]]; then
  should_rebuild=true
else
  for file in "${ZSH_INCLUDES}"/*.zsh; do
    [[ "$file" -nt "$ALL_COMBINED" ]] && should_rebuild=true && break
  done
fi

if [[ "$should_rebuild" == true ]]; then
  cat "${ZSH_INCLUDES}"/early_*.zsh "${ZSH_INCLUDES}/completions.zsh" "${ZSH_INCLUDES}"/late_*.zsh > "$ALL_COMBINED"
fi
source_compiled "$ALL_COMBINED"

# Bring in non-repository source files
[[ -f "${ZSH}/secrets.zsh" ]] && source_compiled "${ZSH}/secrets.zsh"
[[ -f "${ZSH}/work.zsh" ]] && source_compiled "${ZSH}/work.zsh"

# Clear stale file check cache (used during startup to avoid repeated date calls)
unset _STALE_CHECK_NOW

# End tracing if enabled
if [[ "$PROFILE_STARTUP" == true || "$PROFILE_ALL" == true ]]; then
  unsetopt xtrace
  exec 2>&3 3>&-
  echo "Profile written to /tmp/zsh_profile.$$"
fi
