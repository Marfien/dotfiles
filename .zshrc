# Configuring environment
export PATH="$HOME/bin:/usr/local/bin:$PATH"
export PATH="$PATH:/home/maha/go/bin/"
export CONFIG_HOME="$HOME/.config"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

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
  echo "found"
  source "$CONFIG_HOME/zsh/custom.zshrc"
else 
  echo "not found"
fi

