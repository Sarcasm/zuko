setopt interactive_comments
setopt autocd # TODO: also check autopushd

# I really like push-line (^Q) and it is not usable by default due to flow
# control, so disable flow control via the ZSH option.
#
# Note: flow control could also be disabled with `stty -ixon` or ^S and ^Q can
# remapped using `stty start` and `stty stop`.
#
# Option found in the ZSH Guide > 4.4.2: Searching through the history > Ordinary searching
# http://zsh.sourceforge.net/Guide/zshguide04.html
unsetopt flowcontrol
