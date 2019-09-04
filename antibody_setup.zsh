# declare function to update zsh plugins, antibody can be called to init each time
# on shell startup, but this is much faster
function update_zsh_plugins() {
  case ${OSTYPE} in
    linux*)
      APLUGIN_FILE=${ZSH}/antibody_plugins_linux.txt
      ;;
    darwin*)
      APLUGIN_FILE=${ZSH}/antibody_plugins_darwin.txt
      ;;
  esac

  antibody bundle < ${APLUGIN_FILE} > ${ZSH_CACHE_DIR}/antibody_plugins.zsh

  for i in `find ~/.cache/antibody -name '*.zsh' -print`; do
    zcompile ${i} >/dev/null 2>&1
  done

  zcompile ${ZSH_CACHE_DIR}/antibody_plugins.zsh
  source ${ZSH_CACHE_DIR}/antibody_plugins.zsh;
}

if which antibody >/dev/null 2>&1; then
  if [ -f "${ZSH_CACHE_DIR}/antibody_plugins.zsh" ]; then
    . ${ZSH_CACHE_DIR}/antibody_plugins.zsh
  else
    update_zsh_plugins
  fi
else
  echo "Antibody is not present in path, get it at: https://getantibody.github.io/"
fi
