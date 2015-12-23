#-*-shell-script-*-
autoload predict-on
autoload predict-off

# you may also wish to bind it to some keys...
zle -N predict-on
zle -N predict-off
bindkey '^X1' predict-on
bindkey '^X2' predict-off
