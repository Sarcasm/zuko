ZUKODIR=$(dirname ${(%):-%N})

typeset -U fpath
# prepend all directories from Functions/ to the fpath
# prepending is used to be able to override existing definitions
fpath[1,0]=($ZUKODIR/Functions/*(/))

# man zshzle says that ZLE is set by default on interactive shells, it is not in
# scripts. source the zle configuration only if necessary, same for completion
if [[ -o zle ]]; then
    source $ZUKODIR/completion.zsh
    source $ZUKODIR/zle.zsh
fi

source $ZUKODIR/history.zsh
source $ZUKODIR/promptly.zsh
source $ZUKODIR/vcs.zsh

setopt INTERACTIVE_COMMENTS

# if available, use ls++ as a better 'ls -l'
# - https://github.com/trapd00r/ls--
if which ls++ >& /dev/null; then
    alias ll='ls++'
else
    alias ll='ls -l'
fi

# TODO: mansection function
# mansection zshcompsys "COMPLETION SYSTEM CONFIGURATION"
# LESS=+/"^ *file-patterns *$" man zshcompsys

# for suffix aliases, check man zshcontrib
# execute-never
#        This  style  is  useful  in combination with execute-as-is.  It is set to an array of patterns
#        corresponding to full paths to files that should never be treated as executable, even  if  the
#        file  passed  to the MIME handler matches execute-as-is.  This is useful for file systems that
#        don't handle execute permission or that contain executables  from  another  operating  system.
#        For example, if /mnt/windows is a Windows mount, then
#
#               zstyle ':mime:*' execute-never '/mnt/windows/*'
#
# this seems spot-on with windows files

setopt autocd                   # TODO: also check autopushd
