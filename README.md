# dotfiles

This repository contains all dotfiles/config files laying in user home directory
(commonly known as `~`)

## Prerequirements

Make sure you have `git` and `ansible` installed on your system.

Clone this repository into your home directory:

```shell
git clone git@github.com:Marfien/dotfiles.git ~
```

Or, if it says the directory is not empty:

```shell
cd ~
git init
git remote add origin git@github.com:Marfien/dotfiles.git
git pull --set-upstream origin main
git submodule update --init --recursive
```

You might need to deleted conflicting files.

## Setup

Depending on your operating system, you need to execute on of the following commands next:

### Linux/MacOS

```shell
ansible-playbook -i .ansible/hosts .ansible/<linux|mac|linux>.yml
```

## Fast forward

Example script for Debian/Ubuntu:

```shell
sudo apt install git ansible -y
ssh-keygen -t ed25519 -C 'My new workstation'
# Add ssh key to github
cd ~
git init
git branch -m main
git remote add origin git@github.com:Marfien/dotfiles.git
git pull --set-upstream origin main
git submodule update --init --recursive
ansible-playbook -i .ansible/hosts .ansible/linux.yml
```

## TODOs

[ ] Install docker on WSL
[ ]
