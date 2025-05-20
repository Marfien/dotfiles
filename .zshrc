zmodload zsh/zprof
# Configuring environment
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="$PATH:/home/maha/go/bin/"
export CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_HOME=$CONFIG_HOME

# aliases
source "$CONFIG_HOME/zsh/aliases.sh"

for file in "$CONFIG_HOME/zsh/config/"*.sh; do
  source "$file"
done

# Source custom configuration
if [ -r "$CONFIG_HOME/zsh/custom.zsh" ]; then
  source "$CONFIG_HOME/zsh/custom.zsh"
fi

if [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [ -z "$TERMINAL_EMULATOR" ] && command -v tmux &> /dev/null; then
  exec tmux
fi
