if [ -r '/opt/homebrew/bin/brew' ]; then
  brew='/opt/homebrew/bin/brew'
elif [ -r '/home/linuxbrew/.linuxbrew/bin/brew' ]; then
  brew='/home/linuxbrew/.linuxbrew/bin/brew'
fi

eval "$($brew shellenv)"

# ---- Load plugins installed via brew ----
zsh_plugins=(
  zsh-syntax-highlighting
  zsh-autosuggestions
)

for plugin in "${zsh_plugins[@]}"; do
  plugin_path="`brew --prefix`/share/${plugin}/${plugin}.zsh"
  if [ -r "$plugin_path" ]; then
    source "$plugin_path"
  else
    echo "Warning: $plugin_path could not be read." 1>&2
  fi
done
