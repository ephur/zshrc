# improve over typical "antidote load" ; cache and compile everything
function update_zsh_plugins() {
  local aplugin_file
  case "${OSTYPE}" in
    linux*)
      aplugin_file="${ZSH}/antidote_plugins_linux.txt"
      ;;
    darwin*)
      aplugin_file="${ZSH}/antidote_plugins_darwin.txt"
      ;;
  esac

  antidote bundle < "${aplugin_file}" > "${ZSH_CACHE_DIR}/antidote_plugins.zsh"
  antidote update

  find "${ZSH_CACHE_DIR}/antidote" -name '*.zsh' -print0 | xargs -0 zcompile >/dev/null 2>&1
  source_compiled "${ZSH_CACHE_DIR}/antidote_plugins.zsh"
}

zstyle ':antidote:bundle' use-cache true
zstyle ':antidote:bundle' cache-dir "${ZSH_CACHE_DIR}/antidote"

if ! source_compiled "${ZSH}/.antidote/antidote.zsh"; then
  echo "Antidote plugin manager not available. Get it at: https://getantidote.github.io/ (run from source mode!)"
else
  if [ ! -f "${ZSH_CACHE_DIR}/antidote_plugins.zsh" ] || is_stale_file "${ZSH_CACHE_DIR}/antidote_plugins.zsh"; then
    update_zsh_plugins
  else
    source_compiled "${ZSH_CACHE_DIR}/antidote_plugins.zsh"
  fi
fi
