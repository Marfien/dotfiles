# dotfiles

This repository contains all dotfiles/config files laying in user home directory
(commonly known as `~`)

## Setup

1. Clone the repository into your home directory:

```shell
git clone git@github.com:Marfien/dotfiles.git ~
```

Or, if it says the directory is not empty:

```shell
cd ~
git init
git remote add origin git@github.com:Marfien/dotfiles.git
git pull -u origin main
```

You might need to delete some files that are conflicting

2. Depending on your operating system, you need to execute on of the following commands next:

On Unix, run the following commands:

```shell
# Install brew
eval "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [ -n "$HOMEBREW_ON_LINUX" ]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
elif [ -n "$HOMEBREW_ON_MACOS"]; then

fi
```
