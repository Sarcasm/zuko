# The following was initially regenerated by opam config setup -a
#
# If this environmnent is wanted in a shell session, one can use:
#       eval `opam config env`
#
# OPAM configuration
[[ -e ~/.opam/opam-init/init.zsh ]] && . ~/.opam/opam-init/init.zsh

# prepend customs paths so that they override system executables
path[1,0]=(
    ~/bin                       # custom binaries
    ~/pkg/bin                   # user's stow packages
    ~/src/arcanist/bin          # LLVM code review tool/Phabricator
    ~/.local/bin                # pip install --user binaries
)

# cleanup path, remove entries that do not exists and make sure it does not
# contain any duplicates
# inspired by http://stackoverflow.com/a/27872135/951426
typeset -U path
path=($^path(N))

if which chromium >& /dev/null; then
    export BROWSER=chromium
elif which chromium-browser >& /dev/null; then
    export BROWSER=chromium-browser
fi

export PAGER='less'
export EDITOR='emacs -nw -Q'
