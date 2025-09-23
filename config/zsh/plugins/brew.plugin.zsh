ZSH_HIGHLIGHT_DIRS_BLACKLIST+=(/mnt/c/)
zsh_plugins=(
  zsh-syntax-highlighting
  zsh-history-substring-search
  zsh-autosuggestions
)

for plugin in "${zsh_plugins[@]}"; do
  plugin_path="$(brew --prefix)/share/${plugin}/${plugin}.zsh"
  if [ -r "$plugin_path" ]; then
    source "$plugin_path"
  else
    echo "Warning: $plugin_path could not be read." 1>&2
  fi
done
