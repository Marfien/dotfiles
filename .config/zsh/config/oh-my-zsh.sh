export ZSH="$HOME/.oh-my-zsh"
export ZSH_CUSTOM="$CONFIG_HOME/zsh/oh-my-zsh/custom"
export ZSH_THEME="robbyrussell_edited"

zstyle ':omz:plugins:nvm' lazy yes
zstyle ':omz:plugins:sudo' lazy yes
zstyle ':omz:plugins:zsh-syntax-highlighting' lazy yes
zstyle ':oh-my-zsh:plugins:zsh-autosuggestions' lazy yes
plugins=(git sudo docker dirhistory zsh-navigation-tools nvm zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh
