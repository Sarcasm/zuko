autoload -Uz vcs_info
autoload -Uz colors && colors

# I only use git seriously for now
zstyle ':vcs_info:*' enable git

zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr '%F{28}%%%f'  # FIXME: hardcoded color number
zstyle ':vcs_info:*' unstagedstr '%F{11}*%f' # FIXME: hardcoded color number
zstyle ':vcs_info:*' formats "%F{red}(%{$fg_bold[yellow]%}%b%%b%F{red})%f%c%u"
