# Configuring environment
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="$PATH:/home/maha/go/bin/"
export CONFIG_HOME="$HOME/.config"
export XDG_CONFIG_HOME=$CONFIG_HOME

# Takes care of linuxbrew (linux) and homebrew (macos)
if [ -r '/opt/homebrew/bin/brew' ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Configure Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_CUSTOM="$CONFIG_HOME/zsh/oh-my-zsh/custom"
ZSH_THEME="robbyrussell_edited"

plugins=(git sudo dirhistory zsh-navigation-tools)

source $ZSH/oh-my-zsh.sh

if [ -r "$CONFIG_HOME/zsh/aliases.sh" ]; then
  source "$CONFIG_HOME/zsh/aliases.sh"
fi

# Source custom configuration
if [ -r "$CONFIG_HOME/zsh/custom.zshrc" ]; then
  source "$CONFIG_HOME/zsh/custom.zshrc"
fi

