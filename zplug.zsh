source ~/.zplug/init.zsh

# zplug
zplug 'zplug/zplug', hook-build:'zplug --self-manage'

# Plugins from zsh-users
zplug "zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search"
zplug "zsh-users/zsh-syntax-highlighting",      defer:2
zplug "zsh-users/zsh-completions",              defer:0
zplug "zsh-users/zsh-autosuggestions",          defer:2, on:"zsh-users/zsh-completions"
zplug "zsh-users/zsh-syntax-highlighting",      defer:3, on:"zsh-users/zsh-autosuggestions"
zplug "zsh-users/zsh-history-substring-search", defer:3, on:"zsh-users/zsh-syntax-highlighting"

# oh-my-zsh
zplug "robbyrussell/oh-my-zsh",        use:"lib/spectrum.zsh"
zplug "robbyrussell/oh-my-zsh",        use:"lib/git.zsh"
zplug "robbyrussell/oh-my-zsh",        use:"lib/termsupport.zsh"

# Plugins from oh-my-zsh
zplug "plugins/command-not-found",     from:oh-my-zsh
zplug "plugins/colorize",              from:oh-my-zsh
zplug "plugins/colored-man-pages",     from:oh-my-zsh
zplug "plugins/git",                   from:oh-my-zsh, if:"which git"
zplug "plugins/go",                    from:oh-my-zsh, if:"which go"
zplug "plugins/nmap",                  from:oh-my-zsh, if:"which nmap"
zplug "plugins/sudo",                  from:oh-my-zsh, if:"which sudo"
zplug "plugins/urltools",              from:oh-my-zsh
zplug "plugins/web-search",            from:oh-my-zsh
zplug "plugins/z",                     from:oh-my-zsh

case ${OSTYPE} in
  darwin*)
    zplug "plugins/osx",               from:oh-my-zsh
    zplug "plugins/brew",              from:oh-my-zsh, if:"which brew"
    # zplug "plugins/macports",          from:oh-my-zsh, if:"which port"
    # zplug "plugins/tmux",                  from:oh-my-zsh, if:"which tmux"
  ;;
  linux*)
    zplug "plugins/tmux",                  from:oh-my-zsh, if:"which tmux"
  ;;
esac

# Other plugins
zplug "arzzen/calc.plugin.zsh"
zplug "jimeh/zsh-peco-history"
zplug "supercrabtree/k"
zplug "MichaelAquilina/zsh-you-should-use"
zplug "johanhaleby/kubetail"

# The whole prompt system
zplug "bhilburn/powerlevel9k",          use:powerlevel9k.zsh-theme

# Finalize loading plugins
function zplugins() {
if ! zplug check --verbose; then
        printf "Install plugins? [y/N]: "
        if read -q; then
            echo; zplug install
        fi
    fi
}

zplugins
zplug load
