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
