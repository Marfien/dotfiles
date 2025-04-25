if [ -r '/opt/homebrew/bin/brew' ]; then
  brew='/opt/homebrew/bin/brew'
elif [ -r '/home/linuxbrew/.linuxbrew/bin/brew' ]; then
  brew='/home/linuxbrew/.linuxbrew/bin/brew'
fi

eval "$($brew shellenv)"
