#!/bin/sh

alias zshconfig='vim ~/.zshrc'
alias ccat='pygmentize -g -O style="material,lineos=1"'
alias dckr='docker run --rm -it --entrypoint /bin/sh'
alias dckrmnt'dckr -v .:/mnt -w /mnt'
alias vim='nvim'
alias g='git'
alias so='so --no-lucky'

alias rm='rm -i'
alias ls='ls --color=always'
alias lsa='ls -lAh'
alias l='ls -lAh'
alias ll='ls -lh'
alias la='ls -lAh'
alias mkdir='mkdir -p'

alias c='clipcopy'
alias p='clippaste'

wopen() {
  if (( # != 1)); then
    echo "usage: open <file>"
  fi

  (
    cd "$(dirname $1)" || return 1
    explorer.exe "$(basename $1)"
  )
}
