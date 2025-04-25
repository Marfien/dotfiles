export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"
try_source "$(brew --prefix)/opt/nvm/nvm.sh"
try_source "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"
