if [ -r '/opt/homebrew/bin/brew' ]; then
  brew='/opt/homebrew/bin/brew'
elif [ -r '/home/linuxbrew/.linuxbrew/bin/brew' ]; then
  brew='/home/linuxbrew/.linuxbrew/bin/brew'
else
  echo "Could not find Homebrew installation." 1>&2
  return 1
fi

eval "$($brew shellenv)"
