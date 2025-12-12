########################################
# Shell Management Functions
#
# Functions for managing the shell environment:
# - resrc: Rebuild zsh cache and restart shell
# - t: Tmux session manager (attach to or create "default" session)
# - zhelp: Display configuration cheatsheet
########################################

# Rebuild zsh cache and restart shell
# Usage: resrc [plugins]
# Example: resrc          # Rebuilds includes cache only
# Example: resrc plugins  # Rebuilds all caches including plugins
function resrc() {
  if [[ "$1" == "plugins" ]]; then
    echo "Clearing all caches including plugins..."
    find "$ZSH_CACHE_DIR" -mindepth 1 -delete
  else
    echo "Clearing includes cache..."
    find "$ZSH_CACHE_DIR" -mindepth 1 ! -type d -maxdepth 1 -delete
  fi
  exec zsh
}

# Tmux session manager - attach to or create "default" session with predefined windows
# Usage: t
function t() {
  if tmux has-session -t default 2>/dev/null; then
    tmux attach-session -t default
  else
    tmux new-session -d -s default -n TerraformDeploy
    tmux new-window -t default -n LegacyDeploy
    tmux new-window -t default -n TFModules
    tmux new-window -t default -n General
    tmux select-window -t default:0
    tmux attach-session -t default
  fi
}

# Display zsh configuration cheatsheet
# Usage: zhelp [category]
# Example: zhelp       # Show full cheatsheet
# Example: zhelp git   # Show git section only
function zhelp() {
  local cheatsheet="${ZSH}/CHEATSHEET.md"

  if [[ ! -f "$cheatsheet" ]]; then
    echo "Error: Cheatsheet not found at $cheatsheet"
    return 1
  fi

  # If a category is specified, show just that section
  if [[ -n "$1" ]]; then
    local category="$1"
    # Convert to title case for matching
    local category_title="${(C)category}"

    if command -v bat &>/dev/null; then
      # Use bat with line range if available
      # Find the section and display it
      awk -v cat="$category_title" '
        BEGIN { in_section=0; print_count=0 }
        /^## / {
          if (tolower($0) ~ tolower(cat)) {
            in_section=1
            print
            next
          } else if (in_section) {
            exit
          }
        }
        in_section { print }
      ' "$cheatsheet" | bat --language=markdown --style=plain
    else
      # Fallback to less
      awk -v cat="$category_title" '
        BEGIN { in_section=0 }
        /^## / {
          if (tolower($0) ~ tolower(cat)) {
            in_section=1
            print
            next
          } else if (in_section) {
            exit
          }
        }
        in_section { print }
      ' "$cheatsheet" | less -R
    fi
  else
    # Show full cheatsheet
    if command -v bat &>/dev/null; then
      bat --language=markdown --style=plain "$cheatsheet"
    else
      less -R "$cheatsheet"
    fi
  fi
}
