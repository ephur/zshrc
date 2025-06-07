# Profile this...
# thanks to: https://www.dribin.org/dave/blog/archives/2024/01/01/zsh-performance/
#: "${PROFILE_STARTUP:=false}"
#: "${PROFILE_ALL:=false}"
# Run this to get a profile trace and exit: time zsh -i -c echo
# Or: time PROFILE_STARTUP=true /bin/zsh -i --login -c echo
#if [[ "$PROFILE_STARTUP" == true || "$PROFILE_ALL" == true ]]; then
#    # http://zsh.sourceforge.net/Doc/Release/Prompt-Expansion.html
#    PS4=$'%D{%H:%M:%S.%.} %N:%i> '
#    #zmodload zsh/datetime
#    #PS4='+$EPOCHREALTIME %N:%i> '
#    exec 3>&2 2>/tmp/zsh_profile.$$
#    setopt xtrace prompt_subst
#fi

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
[[ "${ZSH_INIT_FILE}" -nt "${ZSH_INIT_FILE}.zwc" ]] && zcompile "${INIT_FILE}"
source "${ZSH_INIT_FILE}"

# Perform early loading
for file in "${ZSH}"/includes/early_*.zsh(N); do
  [[ "$file" -nt "$file.zwc" ]] && zcompile "$file"
  source_compiled "$file"
done

# Completions in the middle
source_compiled "${ZSH_INCLUDES}/completions.zsh"

# Perform late loading
for file in "${ZSH}"/includes/late_*.zsh(N); do
  [[ "$file" -nt "$file.zwc" ]] && zcompile "$file"
  source_compiled "$file"
done

# Extras at the end
source_compiled "${ZSH}/secrets.zsh"
source_compiled "${ZSH}/work.zsh"

# Stop profiling if it was started
if [[ "$PROFILE_STARTUP" == true || "$PROFILE_ALL" == true ]]; then
    unsetopt xtrace
fi
