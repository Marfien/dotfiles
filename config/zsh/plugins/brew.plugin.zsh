ZSH_HIGHLIGHT_DIRS_BLACKLIST+=(/mnt/c/)

ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE="20"
ZSH_AUTOSUGGEST_USE_ASYNC=1

zsh_plugins=(
  zsh-history-substring-search
  zsh-autosuggestions
  zsh-syntax-highlighting
)

for plugin in "${zsh_plugins[@]}"; do
  plugin_path="$(brew --prefix)/share/${plugin}/${plugin}.zsh"
  if [ -r "$plugin_path" ]; then
    source "$plugin_path"
  else
    echo "Warning: $plugin_path could not be read." 1>&2
  fi
done
