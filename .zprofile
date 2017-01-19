# The following was initially regenerated by opam config setup -a
#
# If this environmnent is wanted in a shell session, one can use:
#       eval `opam config env`
#
# OPAM configuration
[[ -e ~/.opam/opam-init/init.zsh ]] && . ~/.opam/opam-init/init.zsh

# prepend customs paths so that they override system executables
# order matters, c.f. 'xdg_data_dirs' variable below
path[1,0]=(
    ~/bin               # custom binaries
    ~/pkg/bin           # user's stow packages
    ~/.local/bin        # Python tools (install with `pip install --user <pkg>`)
)

# cleanup path, remove entries that do not exist
# and make sure it does not contain any duplicates
# inspired by http://stackoverflow.com/a/27872135/951426
typeset -U path
path=($^path(N))

# Complete XDG variable(s) with custom install paths.
#
# This is useful for the Stow packages for example,
# c.f. https://sarcasm.github.io/notes/tools/stow.html
#
# - XDG_DATA_DIRS
#   Useful for '.desktop' files launchers (https://specifications.freedesktop.org/desktop-entry-spec/desktop-entry-spec-latest.html#desktop-file-id)
#   and icons (https://standards.freedesktop.org/icon-theme-spec/icon-theme-spec-latest.html#directory_layout)
#   support.

# -T
#     Ties the 2 variables togethers.
#     The 1st one is a scalar variable, colon-separated list.
#     The 2nd one is array variable to link.
typeset -T XDG_DATA_DIRS xdg_data_dirs

# prepend custom paths so that they override system files
# follows the order of the 'path' variable above
xdg_data_dirs[1,0]=(
    ~/pkg/share
    ~/.local/share
    /popeye
)

# cleanup paths, remove entries that do not exist
# and make sure it does not contain any duplicates
# inspired by http://stackoverflow.com/a/27872135/951426
typeset -U xdg_data_dirs
xdg_data_dirs=($^xdg_data_dirs(N))
export XDG_DATA_DIRS

if which chromium >& /dev/null; then
    export BROWSER=chromium
elif which chromium-browser >& /dev/null; then
    export BROWSER=chromium-browser
fi

export PAGER='less'
export EDITOR='emacs -nw -Q'
