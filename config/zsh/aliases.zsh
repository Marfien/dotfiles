#!/bin/sh

alias zshconfig='vim ~/.zshrc'
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

alias mvn17="$(jbh 17) mvn"
alias mvn21="$(jbh 21) mvn"

if [[ $(uname -p) != "arm" ]]; then
  alias mvn8="$(jbh 8) mvn"
fi

wopen() {
  if (( # != 1)); then
    echo "usage: open <file>"
  fi

  (
    cd "$(dirname $1)" || return 1
    explorer.exe "$(basename $1)"
  )
}

dckr() {
  local image="${@:$#}"
  local args=${@:1:(( $# - 1 ))}
  docker run --rm -it -v "$(pwd):/mnt" -w /mnt --entrypoint '/bin/sh' ${args[@]} "$image" -c '(command -v zsh && zsh) || (command -v bash && bash) || (command -v ash && ash) || sh'
}
