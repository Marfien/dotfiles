export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules,target --preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_DEFAULT_OPTS="--style full"
alias fzf="fzf --preview 'bat -n --color=always {}'"

fzf_path_addition="$(brew --prefix)/opt/fzf/bin"
if [[ ! "$PATH" == *$fzf_path_addition* ]]; then
  PATH="${PATH:+${PATH}:}$fzf_path_addition"
fi

source <(fzf --zsh)

# Rebind the cd widget to CMD-X
if [[ "${FZF_ALT_C_COMMAND-x}" != "" ]]; then
  bindkey -M emacs '^X' fzf-cd-widget
  bindkey -M vicmd '^X' fzf-cd-widget
  bindkey -M ciins '^X' fzf-cd-widget
fi
