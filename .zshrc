# Configuring environment
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="$PATH:/home/maha/go/bin/"
export CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_HOME=$CONFIG_HOME

try_source() {
  if [ -r "$1" ]; then
    source "$1"
  fi
}

# aliases
try_source "$CONFIG_HOME/zsh/aliases.sh"

for file in "$CONFIG_HOME/zsh/config/"*.sh; do
  try_source "$file"
done

# Source custom configuration
try_source "$CONFIG_HOME/zsh/custom.zsh"

if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ]; then
  exec tmux
fi
