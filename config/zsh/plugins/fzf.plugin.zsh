export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules,target --preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_DEFAULT_OPTS="--style full"
alias fzf="fzf --preview 'bat -n --color=always {}'"

fzf_path_addition="$(brew --prefix)/opt/fzf/bin"
if [[ ! "$PATH" == *$fzf_path_addition* ]]; then
  PATH="${PATH:+${PATH}:}$fzf_path_addition"
fi

source <(fzf --zsh)
