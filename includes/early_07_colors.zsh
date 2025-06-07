# Handle dircolors, must be done before applying zstyles that use them
case $OSTYPE in
  darwin*)
    if [[ -f /opt/homebrew/bin/gdircolors && -f ${ZSH}/dircolors ]]  ; then
      eval $(/opt/homebrew/bin/gdircolors -b ${ZSH}/dircolors)
    else
      export CLICOLOR=1
      export LSCOLORS=gxfxbEaEBxxEhEhBaDaCaD
      export TERM="xterm-256color"
    fi
  ;;
  linux*)
    if [[ -f ${ZSH}/dircolors ]]; then
      eval `dircolors ${ZSH}/dircolors`
    fi
  ;;
esac
