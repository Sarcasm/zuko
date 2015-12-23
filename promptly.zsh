# zshzle use reset-prompt periodically or on inotify event or such
# example:
#     _prompt_and_resched() { sched +1 _prompt_and_resched; zle && zle reset-prompt }
#     _prompt_and_resched
#     PS1="%D{%H:%M:%S} $PS1"
# http://chneukirchen.org/blog/archive/2013/03/10-fresh-zsh-tricks-you-may-not-know.html
#
# man zshparam, C-f prompt
# see EXPANSION OF PROMPT SEQUENCES in zshmisc(1).
# see psvar/PSVAR in zshparam

# rprompt for things like python virtual env?

# SHLEVEL indent something in prompt so that one knows it is in a sub-shell
# same for ssh?

# crazy prompt idea to copy/paste command lines, see item 4:
# http://chneukirchen.org/blog/archive/2013/03/10-fresh-zsh-tricks-you-may-not-know.html

# nice git ideas
# http://chneukirchen.org/blog/archive/2013/01/a-grab-bag-of-git-tricks.html
# check also vcs_info
# example in prompt here: https://github.com/sykora/etc/blob/master/zsh/prompt.zsh

# zshmisc
# zshoptions

# see VCS info function from
# man zshcontrib GATHERING INFORMATION FROM VERSION CONTROL SYSTEMS

autoload -Uz colors && colors
autoload -Uz promptinit && promptinit
prompt zuko

# for git revision, use:
#       git name-rev --name-only HEAD
# benefits:
# - know relative distance
#   foo@master~42
# - informative when bisecting
#   foo@bisect/bad
#   foo@bisect/bad~21
#   foo@bisect/bad~5
#   foo@bisect/good
#
# not nice
# - does not work nice with detached HEAD/repo, shows the remote ref:
#   foo@remotes/m/master
# - does not work with empty repository, print to stderr and return 0
#   "Could not get sha1 for HEAD. Skipping."
#   something ok for empty repository: git symbolic-ref --short HEAD


zuko_autoreport_preexec() {
    zuko_start=$(date '+%s')
}

zuko_autoreport_precmd() {
    local exitstatus=$?
    setopt localoptions noxtrace noksharrays
    # FIXME: ^Z should not set the exit status to 20
    if [[ $exitstatus -gt 128 ]] && (( $+signals[$exitstatus-127] )); then
        exitstatus=SIG$signals[$exitstatus-127]
    fi

    # good color is grey if terminal has enough colors
    zstyle -s ':zuko:autoreport:' text-color textcolor || textcolor=white # 238 seems a fine grey

    # report bad exit status
    if [[ ! $exitstatus == 0 ]]; then
        print -P -- "%F{$textcolor}# command exited with status %F{red}$exitstatus%f"
    fi

    # if elapsed time > 3
    # process exited [with status STATUS] [after N seconds]
    # TODO: after 3h 20min and 20 seconds
    if [[ -n $zuko_start ]]; then
        local zuko_end=$(date '+%s')

        local zuko_elapsed=$(( $zuko_end - $zuko_start ))

        if [[ $zuko_elapsed -ge 2 ]]; then
            print -P -- "%F{$textcolor}# command exited after %F{green}$zuko_elapsed%f seconds"
        fi
        unset zuko_start
    fi
}

#
# Print some statistics about the last command if something unusual happens,
# either a long execution time or an unusual exit
#
zuko_autoreport_setup() {
    add-zsh-hook preexec zuko_autoreport_preexec
    add-zsh-hook precmd zuko_autoreport_precmd
}

zuko_autoreport_setup
