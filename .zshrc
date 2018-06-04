# General options
bindkey -v
setopt autocd
setopt correct

# The following lines were added by compinstall
zstyle :compinstall filename '/home/richard/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall
# Required for 'menuselect' keymap
zmodload zsh/complist
  
# Enable prompts
autoload -Uz promptinit
fpath+=$HOME/.zfunctions
promptinit

# Custom prompt
#prompt lean

# History options
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
# Append to history file immediately after a command has been entered
setopt inc_append_history
# Load history file every time when "history" is called
setopt share_history
# Don't add commands with leading spaces to history
setopt hist_ignore_space
# When trimming the history, remove the oldest duplicates first
setopt hist_expire_dups_first
# Don't record duplicate entries
setopt hist_ignore_dups
# Lines copied from .bashrc

# Enable HOME and END keys
bindkey '^[[H' beginning-of-line
bindkey '^[[F' end-of-line

# Visually select the currently selected item
zstyle ':completion:*' menu select

# Colors for list items
LS_COLORS='rs=0:di=01;34:ln=01;36:mh=00:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:cd=40;33;01:or=40;31;01:su=37;41:sg=30;43:ca=30;41:tw=30;42:ow=34;42:st=37;44:ex=01;32'
export LS_COLORS
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}

# Directories will be listed first
zstyle ':completion:*' list-dirs-first true
# Group matches into groups
zstyle ':completion:*' group-name ''
# Enable case-insensitive matching
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# Shift+Tab will go backwards in the list
bindkey -M menuselect '^[[Z' reverse-menu-complete
# Allow completion from within words
setopt complete_in_word

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

# Use custom dircolors database (with fbpad-256)
eval `dircolors ~/.dircolors`

# Expand ... to ../.. while typing
# (https://stackoverflow.com/questions/23456873/multi-dot-paths-in-zsh-like-cd)
if [[ ! $UID -eq 0 ]]; then
  ## http://www.zsh.org/mla/users/2010/msg00769.html
  function rationalise-dot() {
    local MATCH # keep the regex match from leaking to the environment
    if [[ $LBUFFER =~ '(^|/| |      |'$'\n''|\||;|&)\.\.$' && ! $LBUFFER = p4* ]]; then
        #if [[ ! $LBUFFER = p4* && $LBUFFER = *.. ]]; then
        LBUFFER+=/..
    else
        zle self-insert
    fi
}
zle -N rationalise-dot
bindkey . rationalise-dot
bindkey -M isearch . self-insert
fi

export VISUAL='vim'

export _JAVA_OPTIONS='-Dawt.useSystemAAFontSettings=on'
