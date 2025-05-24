# dotfiles

This repository contains all dotfiles/config files laying in user home directory
(commonly known as `~`)

## Prerequirements

Make sure you have `git` and `ansible` installed on your system.

Clone this repository into your home directory:

```shell
git clone git@github.com:Marfien/dotfiles.git ~/.dotfiles/
```

## Setup

Depending on your operating system, you need to execute on of the following commands next:

### Linux/MacOS

This will prompt you for your password twice. One for sudo access and one for the become of ansible.
The `sudo true` creates a sudo session which allows ansible to install brew in non-interactive mode.
```shell
sudo true && ansible-playbook -i .ansible/hosts .ansible/<wsl|workstation>.yml --ask-become-pass --extra-vars 'dotfiles_home=~/.dotfiles'
```

## Fast forward

Example script for Debian/Ubuntu:

```shell
sudo apt install git ansible -y
ssh-keygen -t ed25519 -C 'My new workstation'
# Add ssh key to github
DOTFILES_HOME="$HOME/.dotfiles"
git clone git@github.com:Marfien/dotfiles.git "$DOTFILES_HOME"
sudo true && ansible-playbook -i .ansible/hosts .ansible/workstation.yml --ask-become-pass --extra-vars "dotfiles_home=$DOTFILES_HOME"
```

## TODOs

[ ] Install docker on WSL
[ ]
