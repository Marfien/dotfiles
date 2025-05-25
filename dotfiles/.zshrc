if [ "${ZSH_PROFILING_ENABLED:-0}" = "1" ]; then
  zmodload zsh/zprof
fi

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
export LS_COLORS="di=1;36:ln=35:so=32:pi=33:ex=31:bd=34;46:cd=34;43:su=30;41:sg=30;46:tw=30;42:ow=30;43"

setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS

# aliases
source "$ZSH/aliases.zsh"

# libraries
autoload colors && colors
for lib in "$ZSH/lib/"*.zsh; do
  source "$lib"
done


# plugins
for plugin in "$ZSH/plugins"/*.plugin.zsh; do
  zsh-defer source "$plugin"
done

# completions
autoload -Uz compinit
if [ $(date +'%j') != $(stat -f '%Sm' -t '%j' ~/.zcompdump) ]; then
  compinit
else
  compinit -C
fi
for completion in "$ZSH/completions/"*; do
  source "$completion"
done

# custom configuration
if [ -r "$ZSH/custom.zsh" ]; then
  source "$ZSH/custom.zsh"
fi

if [ "${ZSH_PROFILING_ENABLED:-0}" = "1" ]; then
  zprof
fi
