# Handle dircolors, must be done before applying zstyles that use them
case $OSTYPE in
  darwin*)
    if [[ -f /opt/homebrew/bin/gdircolors && -f ${ZSH}/dircolors ]]  ; then
      # Cache dircolors output for performance (~10ms saved)
      local dircolors_cache="${ZSH_CACHE_DIR}/dircolors_cache.zsh"
      if [[ ! -f "$dircolors_cache" || "${ZSH}/dircolors" -nt "$dircolors_cache" ]]; then
        /opt/homebrew/bin/gdircolors -b ${ZSH}/dircolors > "$dircolors_cache"
      fi
      source_compiled "$dircolors_cache"
    else
      export CLICOLOR=1
      export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
      export TERM="xterm-256color"
    fi
  ;;
  linux*)
    if [[ -f ${ZSH}/dircolors ]]; then
      # Cache dircolors output for performance
      local dircolors_cache="${ZSH_CACHE_DIR}/dircolors_cache.zsh"
      if [[ ! -f "$dircolors_cache" || "${ZSH}/dircolors" -nt "$dircolors_cache" ]]; then
        dircolors ${ZSH}/dircolors > "$dircolors_cache"
      fi
      source_compiled "$dircolors_cache"
    fi
  ;;
esac
