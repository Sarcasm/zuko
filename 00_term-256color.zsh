# This files tries to fine tune TERM for some terminals known to not offer a
# customization option to do it properly. Some terminals export themselves to
# 'xterm' when they support actually support a more specialized terminfo entry
# and sometimes more colors , for example that's what gnome-terminal, konsole
# and terminator do.
#
# It is usually agreed that TERM should not be changed by the shell config, so
# one should probably restrain himself to add more stuff to this file.
#
# This file need to be sourced early because:
# - $terminfo is automatically updated when we change TERM (see man zshparam
#   about TERM) and $terminfo is used to configure zle later on
# - ZLE_RPROMPT_INDENT is reset when changing TERM, if this configuration
#   happens to configure this variable
# - the number of colors available depends on this variable
#
# What I know about a few terminals I use:
# - konsole
#       TERM is customizable in the preferences. Default is 'xterm' but
#       'konsole-256color' and 'xterm-256color' seems supported too.
# - xterm and (u)rxvt
#       TERM is customizable in X Resource and command line option. Just set
#       URxvt/XTerm*termName or -tn TERM to xterm-256color or
#       rxvt-unicode-256color
# - gnome-terminal, terminator, xfce4-terminal
#   I believe they are implemented by the same underlying library (VTE). They
#   call themselves xterm but could be set to gnome-256color or xterm-256color.
#   Howewer they don't seem to provide an option for this.
#   They export the COLORTERM environement variable to gnome-terminal (for
#   gnome-terminal and terminator) or xfce4-terminal.
#   This is the annoying case I'm working around here.
#   notes:
#   - gnome-terminal exports VTE_VERSION
#   - terminator exports TERMINATOR_UUID
#
# ZUKO_OLD_TERM is set if the terminal was changed.
#
# Interesting stuff:
# - http://blog.sanctum.geek.nz/term-strings/

function {
    local alternative

    function zuko_find_term_alternatives {
        if which tput >& /dev/null; then
            for alternative in "$@"; do
                if >& /dev/null tput -T$alternative longname; then
                    echo $alternative
                    break
                fi
            done
        fi
    }

    # terminator and gnome-terminal seems to export TERM as 'xterm' and
    # COLORTERM as 'gnome-terminal' on Ubuntu 14.04
    if [[ $TERM = "xterm" ]] && [[ $COLORTERM = "gnome-terminal" ]]; then
        alternative=$(zuko_find_term_alternatives {gnome,vte,xterm}-256color)
    fi

    if [[ -n $alternative ]]; then
        export ZUKO_OLD_TERM=$TERM
        export TERM=$alternative
    fi
}

function ssh-copy-terminfo {
    # could ssh-copy-termcap be needed? can use infotocap
    infocmp | ssh $1 'TMP=$(mktemp) && cat > $TMP; tic -o ~/.terminfo/ "$TMP" && rm "$TMP"'
}
