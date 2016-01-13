# In order to avoid hardcoding key sequences, there are 2 solutions proposed on
# the ZSH wiki, one based on zkbd and the other on terminfo. The keybinding here
# uses the good advices from the wiki.
# - http://zshwiki.org/home/zle/bindkeys

zmodload zsh/terminfo
zmodload zsh/zle

# use emacs as main keymap, even if EDITOR/VISUAL is vi
bindkey -e

# Uncomment this zkbd stuff if terminfo appears to be unsufficient
#
# From zkbd first run:
#
# > You are using zsh in MULTIBYTE mode to support modern character sets (for
# > languages other than English). To use the Meta or Alt keys, you probably
# > need to revert to single-byte mode with a command such as
#
# Uncomment if limited by Alt/Meta:
# unsetopt MULTIBYTE
# bindkey -m 2>/dev/null

# xkbd_config_file=${ZDOTDIR:-$HOME}/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}
# if [[ -f $xkbd_config_file ]]; then
#     source $xkbd_config_file
# else
#     1>&2 cat <<EOF
# WARNING: new system/terminal detected, please type:
#     autoload zkbd && zkbd

# Note: if you don't want to be annoyed by this message ever again, you can type:
#     mkdir -p $(dirname $xkbd_config_file) && touch $xkbd_config_file
# EOF
# fi

# create a zkbd compatible hash;
# to add other keys to this hash, see: man 5 terminfo
typeset -A key

# Make sure the terminal is in "application mode" when zle is active.
#
# "Application mode" could be compared to the "num lock", when the mode is
# entered the keys have different meaning.
# In this case, the keys produce different output on some terminals.
# Example:
# - in xterm right arrow is 'ESC [ C' when in "cursor mode"
# - 'ESC O C' when in application mode
# - $terminfo[kcuf1] = 'ESC O C'
#
# note: what about $terminfo[cuf1] = 'ESC [ C'?
#
# > Apparently, for obscure historic reasons, xterm, like the VT100, has two
# > "modes" - "cursor mode" and "application mode". Cursor keys in the former
# > generate escape sequences with "[", and in the latter mode they generate
# > escape sequences with "O". Editors are *expected* to switch to "application"
# > mode using the "smkx" terminfo capability when they start, and to go back to
# > the normal "cursor" mode ("rmkx") when they exit. Since editors are supposed
# > to do that, they can expect cursor keys to generate the "O" escape
# > sequences, and this is why the "khome" capability is ^[OH, not ^[[H.
# -- http://www.zsh.org/mla/users/2010/msg00052.html
#
# > As with most things terminal(-emulator)-related, it seems to mostly come
# > down to hysterical raisins, but the purpose of the two modes seems
# > similar to what the NumLock key tends to do nowadays.  (That is: lets
# > you switch between two useful sets of keybindings for the same
# > ~18-key numerical keypad.)  AFAICT, the VT-100 didn't have a NumLock key[3].
# >
# > And, from terminfo, it seems clear that that was the intent (to separate
# > two different modes for the keypad itself, not to create a semantic
# > distinction between 'application' and 'normal' modes)[4].
# -- http://www.zsh.org/mla/users/2010/msg00066.html
#
# Something using termcap also exists:
# - http://www.zsh.org/mla/users/2010/msg00065.html
#
# more info:
# - man terminfo
# - http://homes.mpimf-heidelberg.mpg.de/~rohm/computing/mpimf/notes/terminal.html
if (( ${+terminfo[smkx]} )) && (( ${+terminfo[rmkx]} )) ;then
    function zle-line-init   () {
        echoti smkx
    }
    function zle-line-finish () {
        echoti rmkx
    }

    zle -N zle-line-init
    zle -N zle-line-finish
fi

key[Home]=${terminfo[khome]}
key[End]=${terminfo[kend]}
key[Insert]=${terminfo[kich1]}
key[Delete]=${terminfo[kdch1]}
key[PageUp]=${terminfo[kpp]}
key[PageDown]=${terminfo[knp]}
key[Up]=${terminfo[kcuu1]}
key[Down]=${terminfo[kcud1]}
key[Left]=${terminfo[kcub1]}
key[Right]=${terminfo[kcuf1]}

# Some keys like Control-<arrow> aren't supported by default by terminfo but
# they exists as extended/user-defined capabilities.
# Use infocmp -x to dump the available extended/user-defined capabilities.
key[C-Home]=${terminfo[kHOM5]}
key[C-End]=${terminfo[kEND5]}
key[C-Up]=${terminfo[kUP5]}
key[C-Down]=${terminfo[kDN5]}
key[C-Left]=${terminfo[kLFT5]}
key[C-Right]=${terminfo[kRIT5]}

key[M-Home]=${terminfo[kHOM3]}
key[M-End]=${terminfo[kEND3]}
key[M-Up]=${terminfo[kUP3]}
key[M-Down]=${terminfo[kDN3]}
key[M-Left]=${terminfo[kLFT3]}
key[M-Right]=${terminfo[kRIT3]}

# autoload the functions from Functions/Zle and declare them as widgets,
# so one only need to bind them
for widget in $ZUKODIR/Functions/Zle/*; do
    autoload -Uz ${widget:t}
    zle -N ${widget:t}
done

autoload -Uz zuko_terminfo_key

# Rebind arrow up/down so that they search the history from what's currently
# typed on the command line
autoload -Uz history-search-end
zle -N history-beginning-search-backward-end history-search-end
zle -N history-beginning-search-forward-end history-search-end
[[ -n $key[Up] ]] && bindkey $key[Up] history-beginning-search-backward-end
[[ -n $key[Down] ]] && bindkey $key[Down] history-beginning-search-forward-end

# Special keys bindings
while read special_key binding; do
    [[ -n ${key[$special_key]} ]] && bindkey "${key[$special_key]}" $binding
done <<EOF
  Home  beginning-of-line
   End  end-of-line
Insert  overwrite-mode
Delete  delete-char
M-Left  emacs-backward-word
C-Left  emacs-backward-word
M-Right emacs-forward-word
C-Right emacs-forward-word
EOF

# Note: somehow \e-X and \M-X are not the same in ZSH, so I have to use the
# unfamiliar \e notation instead of the Emacs notation M-, will have to get used
# to it I guess
bindkey '\eg' zuko-retype-with-sudo

# tab to complete only, not interested of the default binding to
# 'expand-or-complete' which does expansion too, because I rarely want expansion
# to happen and when that's the case I can call the default keybinding '^X*'
# explicitly
# the completion is also embellished with waiting dots so that one can
# understand what happens
bindkey '^I' complete-word
complete-word-with-dots() {
    # a builtin completion style can also be used to show when completion is
    # working but the string displayed is not customizable, sadly
    #     zstyle ":completion:*" show-completer true
    zle -R "Making completion list..." # same message as Emacs :)
    zle complete-word
    # redisplay is important otherwise the terminal gets garbage after a ^C on
    # menu-completion
    zle redisplay
}
zle -N complete-word-with-dots
bindkey "^I" complete-word-with-dots

# edit command line in external $VISUAL/$EDITOR,
# this seems more convenient to me than fc
autoload -Uz edit-command-line
zle -N edit-command-line
bindkey "^X^e" edit-command-line # bash's default

# TODO:
# - bind describe-key-briefly. maybe ^H can be unbound?
#
# keys that could be rebound to something different:
# - backward-char (^B ESC-[D)
# - backward-word (ESC-B ESC-b) now that C-<left> is bound
# - overwrite-mode (^X^O)
# - M-<UPPERCASE_LETTER> seems available
# - remap M-/, current functionality is not useful
# - remember this handy binding: ^Xm bound to _most_recent_file
#

# zle has a default shortcut to display the help for the command being typed in
# the default binding for run-help is M-h
# another version of run-help exist in zshcontrib, this one allow to use custom
# help functions, for example for git it will call "man git-subcommand" instead
# of "man git"
#
# A nice thing with run-help is that it works with aliases, `run-help ll` will
# call `man ls` or `man ls++` for example.
#
# On some distributions (e.g: Ubuntu Trusty / 14.04) the system config already
# enable run-help, so in order to avoid errors when we unalias run-help we check
# for this.
#
# FIXME: run-help foo are appended to the history

# aliases array is defined by zsh/parameter
zmodload -i zsh/parameter && (( ${+aliases[run-help]} )) && unalias run-help
autoload -Uz run-help

# standard run-help-*
autoload -Uz run-help-git
autoload -Uz run-help-ip
autoload -Uz run-help-sudo

run-help-repo() {
    emulate -LR zsh

    # run 'repo help' on the first non-option parameter, if no subcommand is
    # present (the resulting array is empty) this simply call "repo help"
    # see "Parameter Expansion"
    repo help ${@:#-*}
}

# bracketed space is not such a bad idea for security purposes when pasting
# stuff from untrusted sources but I got used to copy-paste multiple commands
# from wiki or things like that
# moreover this display bad characters in emacs' 'M-x shell RET', it prints
# 'ESC[?2004h' after the prompt, but that could be fixed specifically if it was
# only that
# http://invisible-island.net/xterm/ctlseqs/ctlseqs.html#h2-Bracketed-Paste-Mode
unset zle_bracketed_paste
