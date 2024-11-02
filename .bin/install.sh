#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
  echo "You need to run this script as root/sudo user"
fi

echo_remote() {
  remote_url=$1

  if command -v curl; then
    curl -fsSl "$remote_url";
  else if command -v wget; then
    wget -O- "$remote_url"
  else if command -v fetch; then
    fetch -o - "$remote_url"
  else
    echo "Neither curl, wget nor fetch found. Abording..." 1>&2
    exit 1
  fi
}

# Just checking if it works
echo_remote google.com >> /dev/null || exit 1

# Install brew
/bin/bash "$(echo_remote https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


