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


alias k="kubectl"


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
  local -a args
  if (( $# > 1 )); then
    args=("${@:1:(( $# - 1 ))}")
  else
    args=();
  fi

  docker run --rm -it -v "$(pwd):/mnt" -w /mnt --entrypoint '/bin/sh' "${args[@]}" "$image" -c '(command -v zsh && exec zsh) || (command -v bash && exec bash) || (command -v ash && exec ash) || sh'
}
