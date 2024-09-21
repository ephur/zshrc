# declare function to update zsh plugins, antidote can be called to init each time
# on shell startup, but this is much faster
function update_zsh_plugins() {
  case ${OSTYPE} in
    linux*)
      APLUGIN_FILE=${ZSH}/antidote_plugins_linux.txt
      ACACHE_DIR=${HOME}/.cache
      ;;
    darwin*)
      APLUGIN_FILE=${ZSH}/antidote_plugins_darwin.txt
      ACACHE_DIR=${HOME}/Library/Caches
      ;;
  esac

  antidote bundle < ${APLUGIN_FILE} > ${ZSH_CACHE_DIR}/antidote_plugins.zsh
  antidote update

  for i in `find ${ACACHE_DIR}/antidote -name '*.zsh' -print`; do
    zcompile ${i} >/dev/null 2>&1
  done

  zcompile ${ZSH_CACHE_DIR}/antidote_plugins.zsh
  source ${ZSH_CACHE_DIR}/antidote_plugins.zsh;
}

function install_antidote() {
  cd ~
  git clone --depth=1 https://github.com/mattmc3/antidote.git .antidote
}

if which antidote >/dev/null 2>&1; then
  if [ -f "${ZSH_CACHE_DIR}/antidote_plugins.zsh" ]; then
    # echo "Sourcing Cache Plugins"
    . ${ZSH_CACHE_DIR}/antidote_plugins.zsh
  else
    # echo "Updating Plugins"
    update_zsh_plugins
  fi
else
  echo "antidote is not present in path, get it at: https://getantidote.github.io/"
fi
