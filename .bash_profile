#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

[ -n "$TMUX" ] && return

[[ -d ~/bin || -h ~/bin ]] && PATH="$HOME/bin:$PATH"

if [[ ! ${DISPLAY} && ${XDG_VTNR} == 1 ]]
then
    startx
fi
