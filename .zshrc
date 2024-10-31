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

ssh-node() {
 if [ -z "$1" ]; then
   echo "Usage: ssh-node <node-name>"
   return 1
 fi
 
 ssh -i ~/.ssh/id_conf_mgmt conf-mgmt@$1
}
