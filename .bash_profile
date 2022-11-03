#
# ~/.bash_profile
#

[[ -f ~/.bashrc ]] && . ~/.bashrc

# For some reason, tmux opens a login shell.
# Do not mess with variables inside tmux again.
[ -n "$TMUX" ] && return

# Danke, Merkel!
# Since pam_env stopped reading user variables, we have to add them
# everywhere they are needed.
# The best way to store them centrally seems to be relying on systemd.
set -a
eval $(/usr/lib/systemd/user-environment-generators/30-systemd-environment-d-generator)
set +a

USER_BINARIES=$(systemd-path user-binaries)
[[ -d "$USER_BINARIES" ]] && PATH="$USER_BINARIES:$PATH"

if [[ ! "${DISPLAY}" && "${XDG_VTNR}" == 1 ]]
then
    startx
fi
