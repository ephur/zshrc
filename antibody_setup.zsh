# declare function to update zsh plugins, antibody can be called to init each time
# on shell startup, but this is much faster
function update_zsh_plugins() {
  antibody bundle < ~/.zsh/antibody_plugins.txt > ~/.zsh/antibody_plugins.zsh
  for i in `find ~/.cache/antibody -name '*.zsh' -print`; do
    zcompile ${i} >/dev/null 2>&1
  done
  source ~/.zsh/antibody_plugins.zsh;
}

if which antibody >/dev/null 2>&1; then
  if [ -f "${ZSH}/antibody_plugins.zsh" ]; then
    . ${ZSH}/antibody_plugins.zsh
  else
    update_zsh_plugins
  fi
else
  echo "Antibody is not present in path, get it at: https://getantibody.github.io/"
fi
