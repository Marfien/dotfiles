PROMPT="%{$fg[cyan]%}%c%{$reset_color%}"
PROMPT+=' $(git_prompt_info)'
PROMPT+="%{$fg_bold[white]%}"$'\U276F'" %{$reset_color%}"
RPROMPT+="%(?.. %{$fg[red]%}%?%{$reset_color%})"

ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[white]%}git:%{$fg[green]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "

