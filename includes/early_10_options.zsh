# Set history behavior
setopt append_history           # Dont overwrite history
setopt extended_history         # Also record time and duration of commands.
setopt share_history            # Share history between multiple shells
setopt hist_expire_dups_first   # Clear duplicates when trimming internal hist.
setopt hist_find_no_dups        # Dont display duplicates during searches.
setopt hist_ignore_dups         # Ignore consecutive duplicates.
setopt hist_ignore_space        # Ignore items that start with a space
setopt hist_reduce_blanks       # Remove superfluous blanks.
setopt hist_save_no_dups        # Omit older commands in favor of newer ones.

# Set directory stack behavior
setopt autopushd                # Automatically push directories onto the stack when changing directories
setopt pushdminus               # Use the minus sign to pop the last directory from the stack
setopt pushdsilent              # Suppress output when changing directories with pushd
setopt pushdtohome              # Allow pushing the home directory onto the stack with pushd

# Misc Options
setopt extended_glob            # Enable extended globbing for more powerful pattern matching

# Enable VI editing for current command line
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey -M vicmd '!' edit-command-line
bindkey -v
