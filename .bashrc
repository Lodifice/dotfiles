#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

[ -f ~/.bash_aliases ] && . ~/.bash_aliases

alias ls='ls --color=auto'
alias systemstrg=systemctl

HISTSIZE=
HISTFILESIZE=

PS1='[\u@\h \W]\$ '
# FROM https://jichu4n.com/posts/debug-trap-and-prompt_command-in-bash/
# This will run before any command is executed.
function PreCommand() {
    if [ -z "$AT_PROMPT" ]; then
        return
    fi
    if [[ "$BASH_COMMAND" = "__fzf_"* ]]; then
        return
    fi
    unset AT_PROMPT

    # Do stuff.
    printf "\033]0;%s\007" "${BASH_COMMAND//[^[:print:]]/}"
}
trap "PreCommand" DEBUG

# This will run after the execution of the previous full command line.
function PostCommand() {
    AT_PROMPT=1

    # Do stuff.
    shell_name="$(basename -- $0)"
    [ -n "$TMUX" ] && shell_name="${shell_name:1}"
    printf "\033]0;%s\007" "${shell_name}: `dirs +0`"
}
PROMPT_COMMAND="PostCommand"

FZF_DEFAULT_OPTS="--layout=reverse"
. /usr/share/fzf/key-bindings.bash
for f in "$(systemd-path user-configuration)"/bash/?*.bash
do
    [ -f "$f" ] && . "$f"
done
unset f
# wtf?
bind -m vi-insert -x '"\C-t": fzf-file-widget'
