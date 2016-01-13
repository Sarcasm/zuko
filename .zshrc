ZUKODIR=$(dirname ${(%):-%N})

typeset -U fpath
# prepend all directories from Functions/ to the fpath
# prepending is used to be able to override existing definitions
fpath[1,0]=($ZUKODIR/Functions/*(/))

for file in $ZUKODIR/*.zsh; do
    source $file
done

# TODO: mansection function
# mansection zshcompsys "COMPLETION SYSTEM CONFIGURATION"
# LESS=+/"^ *file-patterns *$" man zshcompsys
