HISTFILE=~/.zsh_history

# don't use HIST_IGNORE_ALL_DUPS because otherwise it's difficult to study
# recuring patterns in my history file
setopt HIST_EXPIRE_DUPS_FIRST
SAVEHIST=10000
HISTSIZE=$(($SAVEHIST + 2000))

# fignore a ignorer pour mv et rm, comme ca on peut mettre tilde et .o mais on
# peut facilement les supprimer / mover

# CORRECT_IGNORE
# CORRECT_IGNORE_FILE
# DIRSTACKSIZE

# TODO: read man zshoptions HIST_EXPIRE_DUPS_FIRST, ...

# Need to read more about these
setopt inc_append_history
# setopt share_history
