# Configuring environment
export PATH="$HOEM/go/bin/:$HOME/bin:/usr/local/bin:$PATH"
export CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_HOME=$CONFIG_HOME

# configure zsh
export ZSH="$CONFIG_HOME/zsh"
export ZSH_SPACESHIP_THEME="minimal"
export HISTFILE="$ZSH/.zsh_history"
export HISTSIZE=10000
export SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

# aliases
source "$ZSH/aliases.sh"

# plugins
autoload colors && colors
for plugin in "$ZSH/plugins"/*.plugin.zsh; do
  source "$plugin"
done

# copletions
zstyle ':completion:*:default' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu select

autoload -Uz compinit && compinit
for completion in "$ZSH/completions/"*.completions.zsh; do
  source "$completion"
done

# custom configuration
if [ -r "$ZSH/custom.zsh" ]; then
  source "$ZSH/custom.zsh"
fi

# vim mode
# bindkey -v

if [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [ -z "$TERMINAL_EMULATOR" ] && command -v tmux &> /dev/null; then
  tmux
fi

