#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

[ -n "$TMUX" ] && return

USER_BINARIES=$(systemd-path user-binaries)
[[ -d $USER_BINARIES ]] && PATH="$USER_BINARIES:$PATH"

if [[ ! ${DISPLAY} && ${XDG_VTNR} == 1 ]]
then
    startx
fi
