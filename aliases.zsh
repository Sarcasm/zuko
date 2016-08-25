# if available, use ls++ as a better 'ls -l'
# - https://github.com/trapd00r/ls--
if which ls++ >& /dev/null; then
    # TODO: don't do this if we do not have 256 colors, e,g: inside emacs
    # or check how to fix ls++ to play nice?
    alias ll='ls++'
else
    alias ll='ls -l'
fi

alias ag="ag --pager='less -r -F -X'"

# for suffix aliases, check man zshcontrib
# execute-never
#        This style is useful in combination with execute-as-is. It is set to an
#        array of patterns corresponding to full paths to files that should
#        never be treated as executable, even if the file passed to the MIME
#        handler matches execute-as-is. This is useful for file systems that
#        don't handle execute permission or that contain executables from
#        another operating system. For example, if /mnt/windows is a Windows
#        mount, then
#
#               zstyle ':mime:*' execute-never '/mnt/windows/*'
#
# this seems spot-on with windows files
