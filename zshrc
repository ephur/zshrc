# Enable startup trace profiling if env var is set
if [[ "$PROFILE_STARTUP" == true || "$PROFILE_ALL" == true ]]; then
  PS4=$'%D{%H:%M:%S.%.} + '
  exec 3>&2 2>/tmp/zsh_profile.$$
  setopt xtrace
fi


# Bootstrap core paths
export ZSH="${HOME}/.zsh"
export ZSH_CACHE_DIR="${ZSH}/cache"
export ZSH_INCLUDES="${ZSH}/includes"
[ -d "${ZSH_CACHE_DIR}" ] || {
  [ -x /bin/mkdir ] && /bin/mkdir -p "${ZSH_CACHE_DIR}" || \
  [ -x /usr/bin/mkdir ] && /usr/bin/mkdir -p "${ZSH_CACHE_DIR}" || \
  command mkdir -p "${ZSH_CACHE_DIR}"
}

# First Init
ZSH_INIT_FILE="${ZSH_INCLUDES}/init.zsh"
[[ ! -f "${ZSH_INIT_FILE}.zwc" || "${ZSH_INIT_FILE}" -nt "${ZSH_INIT_FILE}.zwc" ]] && zcompile "${ZSH_INIT_FILE}"
source "${ZSH_INIT_FILE}"

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


[[ -f "${ZSH}/secrets.zsh" ]] && source_compiled "${ZSH}/secrets.zsh"
[[ -f "${ZSH}/work.zsh" ]] && source_compiled "${ZSH}/work.zsh"


# Stop trace profiling if it was started
if [[ "$PROFILE_STARTUP" == true || "$PROFILE_ALL" == true ]]; then
  unsetopt xtrace
  exec 2>&3 3>&-
  echo "Profile written to /tmp/zsh_profile.$$"
fi
