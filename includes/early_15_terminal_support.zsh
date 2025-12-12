########################################
# Terminal-Specific Support
#
# Handles terminal-specific configurations:
# - VTE integration for Tilix and compatible terminals
# - Window blur effects for KDE Plasma terminals (yakuake, konsole, alacritty)
########################################

### Some terminals need VTE sourced in
if [ "$TILIX_ID" ] || [ "$VTE_VERSION" ]; then
  source /etc/profile.d/vte.sh
fi

### Check if suspected terminal is in a list we want to blur background of
if [[ -n "${SUSPECTED_TERM_PID}" ]]; then
  if ps --no-header -p "${SUSPECTED_TERM_PID}" -o comm | grep -Eq '(yakuake|konsole|alacritty)'; then
    for wid in $(xdotool search --pid $PPID); do
      xprop -f _KDE_NET_WM_BLUR_BEHIND_REGION 32c -set _KDE_NET_WM_BLUR_BEHIND_REGION 0 -id "$wid"  >/dev/null 2>&1
    done
  fi
fi
