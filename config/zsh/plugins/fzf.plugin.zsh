export FZF_CTRL_T_OPTS="--walker-skip .git,node_modules,target --preview 'bat -n --color=always {}' --bind 'ctrl-/:change-preview-window(down|hidden|)'"
export FZF_DEFAULT_OPTS="--style full --preview 'bat -n --color-always {}' --bind 'enter:become(vim {})'"

$(brew --prefix)/opt/fzf/install
