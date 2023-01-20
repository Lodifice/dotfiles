# https://github.com/4z3/fzf-plugins

FZF_CTRL_R_EDIT_KEY=ctrl-e
FZF_CTRL_R_EXEC_KEY=enter

__fzf_history__() (
  local output opts script
  shopt -u nocaseglob nocasematch
  edit_key=${FZF_CTRL_R_EDIT_KEY:-enter}
  exec_key=${FZF_CTRL_R_EXEC_KEY:-ctrl-x}
  opts="--height ${FZF_TMUX_HEIGHT:-40%} --bind=ctrl-z:ignore ${FZF_DEFAULT_OPTS-} -n2..,.. --scheme=history --bind=ctrl-r:toggle-sort ${FZF_CTRL_R_OPTS-} --expect=$edit_key,$exec_key +m --read0"
  script='BEGIN { getc; $/ = "\n\t"; $HISTCOUNT = $ENV{last_hist} + 1 } s/^[ *]//; print $HISTCOUNT - $. . "\t$_" if !$seen{$_}++'
  if selected=$(
    builtin fc -lnr -2147483648 |
      last_hist=$(HISTTIMEFORMAT='' builtin history 1) perl -n -l0 -e "$script" |
      FZF_DEFAULT_OPTS="$opts" $(__fzfcmd) --query "$__fzf_old_readline_line")
  then
    key=${selected%%$'\n'*}
    line=${selected#*$'\n'}

    result=$(sed 's/^ *\([0-9]*\)\** *//' <<< "$line")

    case $key in
      $edit_key) result=$result$__fzf_edit_suffix__;;
      $exec_key) result=$result$__fzf_exec_suffix__;;
    esac

    echo "$result"
  else
    # Ensure that no new line gets produced by CTRL-X CTRL-P.
    echo "$__fzf_edit_suffix__"
  fi
)

__fzf_edit_suffix__=#FZFEDIT#
__fzf_exec_suffix__=#FZFEXEC#

__fzf_rebind_ctrl_x_ctrl_p__() {
  if test "${READLINE_LINE: -${#__fzf_edit_suffix__}}" = "$__fzf_edit_suffix__"; then
    READLINE_LINE=${READLINE_LINE:0:-${#__fzf_edit_suffix__}}
    bind '"\C-x\C-p": ""'
  elif test "${READLINE_LINE: -${#__fzf_exec_suffix__}}" = "$__fzf_exec_suffix__"; then
    READLINE_LINE=${READLINE_LINE:0:-${#__fzf_exec_suffix__}}
    bind '"\C-x\C-p": "\C-m"'
  fi
}

__fzf_history_save_readline_line() {
  __fzf_old_readline_line="$READLINE_LINE"
}

bind '"\C-x\C-p": ""'
bind -x '"\C-x\C-o": __fzf_rebind_ctrl_x_ctrl_p__'
bind -x '"\C-x\C-i": __fzf_history_save_readline_line'

if [[ ! -o vi ]]; then
  bind '"\C-r": "\C-x\C-i \C-e\C-u\C-y\ey\C-u`__fzf_history__`\e\C-e\er\e^\C-x\C-o\C-x\C-p"'
else
  bind '"\C-x\C-a": vi-movement-mode'
  bind '"\C-x\C-e": shell-expand-line'
  bind '"\C-x\C-r": redraw-current-line'
  bind '"\C-x^": history-expand-line'
  bind '"\C-r": "\C-x\C-i\C-x\C-addi`__fzf_history__`\C-x\C-e\C-x\C-r\C-x^\C-x\C-a$a\C-x\C-o\C-x\C-p"'
fi
