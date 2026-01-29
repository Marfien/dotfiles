zsh_plugins=(
  zsh-vi-mode
  zsh-syntax-highlighting
)

export ZVM_SYSTEM_CLIPBOARD_ENABLED=true

for plugin in "${zsh_plugins[@]}"; do
  plugin_path="$(brew --prefix)/share/${plugin}/${plugin}.zsh"
  if [ -r "$plugin_path" ]; then
    source "$plugin_path"
  else
    echo "Warning: $plugin_path could not be read." 1>&2
  fi
done
