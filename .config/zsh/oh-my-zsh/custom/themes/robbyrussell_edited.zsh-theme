PROMPT="%{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+='$(git_prompt_info)'
PROMPT+=' %(?:%{$fg_bold[gray]%}%1{❯%} :%{$fg_bold[red]%}%1{❯%} )'
PROMPT+='%{$reset_color%}'

ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[gray]%}git:%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[yellow]%}%1{✗%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""
