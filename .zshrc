# Lines configured by zsh-newuser-install
HISTFILE=~/.zsh_history
HISTSIZE=1000
SAVEHIST=1000
setopt appendhistory autocd
bindkey -v
# End of lines configured by zsh-newuser-install
# The following lines were added by compinstall
zstyle :compinstall filename '/home/richard/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

# Highlight selection for completion
zstyle ':completion:*' menu select

# Enable prompts
autoload -Uz promptinit
promptinit

# Custom prompt
NL=$'\n'
PROMPT="╭ %B%F{green}%n@%m%f%b [%*]: %B%F{blue}%4~%f%b${NL}╰ %(!.#.$) "
RPROMPT="%0(?..%F{red}%?%f)"

# Lines copied from .bashrc

# Enable color support of ls
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias dir='dir --color=auto'
    alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# Add handy aliases
if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

if [ -e /usr/share/terminfo/x/xterm-256color ]; then
	export TERM='xterm-256color'
else
	export TERM='xterm-color'
fi

export VISUAL='vim'

# virtualenvwrapper
export WORKON_HOME=$HOME/.virtualenvs
source /usr/bin/virtualenvwrapper.sh

# TMUX
if which tmux >/dev/null 2>&1; then
    # if no session is started, start a new session
    test -z ${TMUX} && tmux

    # when quitting tmux, try to attach
    while test -z ${TMUX}; do
        tmux attach || break
    done
fi
