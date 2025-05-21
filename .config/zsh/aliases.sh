#!/bin/sh

alias zshconfig='vim ~/.zshrc'
alias ccat='pygmentize -g -O style="material,lineos=1"'
alias dckr='docker run --rm -it --entrypoint /bin/sh'
alias dckrmnt'dckr -v .:/mnt -w /mnt'
alias vim='nvim'
alias g='git'
alias so='so --no-lucky'

alias rm='rm -i'
alias ls='ls --colors=always'
alias lsa='ls -lah'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

alias c='clipcopy'
alias p='clippaste'
