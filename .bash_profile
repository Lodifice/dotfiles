#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

[ -n "$TMUX" ] && return

[[ -d ~/bin || -h ~/bin ]] && PATH="$HOME/bin:$PATH"

