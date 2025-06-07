autoload -Uz compinit;
# use zcompdump if available and less than 1 day old
zcompdump="${ZSH_CACHE_DIR}/.zcompdump"
#is_stale_file "${zcompdump}" 86400 && zcompile "$zcompdump"
compinit -C

zstyle ':completion:*' cache-path "${ZSH}/cache/.zcompcache"          # set cache path for completions
zstyle ':completion:*' completer _extensions _complete _approximate   # choose completers to use
zstyle ':completion:*' group-name ''                                  # group completion items together
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}                 # define colors for completion list
zstyle ':completion:*' menu select                                    # enable fancy selection of completions
# zstyle ':completion:*' rehash true
zstyle ':completion:*' use-cache true                                 # enable cache, helpful for large completion lists but can be problematic for things like kubectl
zstyle ':completion:*' verbose true
zstyle ":completion:*:default" list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*:descriptions' format '%F{green}%B%d%b%f'
zstyle ':completion:*:messages' format '%F{purple}%d%f'
zstyle ':completion:*:warnings' format '%F{red}No matches for: %d%f'

# case-insensitive (all), partial-word and then substring completion
zstyle ":completion:*" matcher-list \
  "m:{a-zA-Z}={A-Za-z}" \
  "r:|[._-]=* r:|=*" \
  "l:|=* r:|=*"
