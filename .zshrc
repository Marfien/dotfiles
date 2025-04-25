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

# aliases
try_source "$CONFIG_HOME/zsh/aliases.sh"

for file in "$CONFIG_HOME/zsh/config/"*.sh; do
  try_source "$file"
done

# Source custom configuration
try_source "$CONFIG_HOME/zsh/custom.zsh"
