# Honorable zsh config

To install, type:

```
git clone https://github.com/Sarcasm/zuko.git ~/.config/zuko
cat <<'EOF' > ~/.zshenv
ZDOTDIR=$HOME/.config/zuko
test -e $ZDOTDIR/.zshenv && source $ZDOTDIR/.zshenv
EOF
chsh -s $(which zsh)
zsh
```

# Troubleshooting

## Ubuntu, lightdm does not load .zprofile

I want [my GNU Stow](https://sarcasm.github.io/notes/tools/stow.html) packages to be found,
and launchable from the Ubuntu Unity desktop.

Issue:
The `.zprofile` is not loaded by the login manager lightdm.

Multiple reports:
- https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=250765
- https://answers.launchpad.net/ubuntu/+question/213018

`lightdm-session` is just a Bash script, that sources some profile files
but does not actually start a login shell.

It loads the following files: `/etc/profile`, `$HOME/.profile`, `/etc/xprofile`,
`$HOME/.xprofile`.

Since my ZSH configuration has a `.zprofile` which adds some applications to my
`PATH`, I would like the graphical session to read it.
Without this, running a new shell or the graphical 'Run command',
does not show binaries in custom paths.

The solution I found on Ubuntu 14.04 is to hijack
`/etc/X11/Xsession.d/99x11-common_start` by adding a similar script
lexicographically before this one, that loads the session in a login shell:

```
root# cat /etc/X11/Xsession.d/99x11-common_start
# $Id: 99x11-common_start 305 2005-07-03 18:51:43Z dnusinow $

# This file is sourced by Xsession(5), not executed.

exec $STARTUP

# vim:set ai et sts=2 sw=2 tw=80:
root# cat <<'EOF' | 1>/dev/null tee /etc/X11/Xsession.d/99x11-00-common_start-sarcasm-login-shell
# -*-sh-*-
# This file is sourced by Xsession(5), not executed.
# https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=250765#35

[ -n $SHELL ] && exec -l $SHELL -c "$STARTUP"
EOF
```
