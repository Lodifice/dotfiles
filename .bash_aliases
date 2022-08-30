# some more ls aliases
alias ls='ls --color=auto'
alias ll='ls -AlFhv'
alias lk='ls -gFhv'
alias la='ls -Av'
alias l='ls -CFv'

# shortcuts
alias j=jobs

# typo aliases
alias ö='l'
alias öö='ll'
alias fin='find'
alias cd..='cd ..'
alias bim='vim'
alias ipa='ip a'

# retry last command with sudo
alias please='sudo !!'

# force last command
alias yolo='!! -f'

# everyone likes to be a jedi
alias force='git'

# web sites
alias xkcd='w3m xkcd.com'
alias fefe='w3m blog.fefe.de'
alias mensa='w3m lucas-vogel.de/mensa'

# fix commands that change and become broken
alias pdfbook='pdfbook2 --paper=a4paper --no-crop'

# stolen from http://stackoverflow.com/questions/1527049/join-elements-of-an-array
join_by() {
    local IFS="$1"; shift; echo "$*";
}

google() {
    browser_cmd=(w3m)
    if [ "$#" -gt 0 ]; then
        browser_cmd+=("duckduckgo.com/?q=$(join_by + "$@")")
    else
        browser_cmd+=(duckduckgo.com)
    fi
    "${browser_cmd[@]}"
}

lyrics() {
    browser_cmd=(w3m)
    if [ "$#" -gt 0 ]; then
        browser_cmd+=("darklyrics.com/search?q=$(join_by + "$@")")
    else
        browser_cmd+=(darklyrics.com)
    fi
    "${browser_cmd[@]}"
}

translate() {
    browser_cmd=(w3m)
    if [ "$#" -gt 0 ]; then
        browser_cmd+=("dict.tu-chemnitz.de/dings.cgi?query=$(join_by + "$@")")
    else
        browser_cmd+=(dict.tu-chemnitz.de)
    fi
    "${browser_cmd[@]}"
}

tdoc() {
    pdf_viewer=zathura
    doc_url=texdoc.net/pkg
    curl -L "${doc_url}/$1" | zathura - &
    disown %1
}

lf () {
    exec {ldp}< <(:)
    tmp="/dev/fd/${ldp}"
    command lf --last-dir-path="$tmp" "$@"
    dir="$(cat "$tmp")"
    if [ -d "$dir" ]; then
        if [ "$dir" != "$(pwd)" ]; then
            cd "$dir"
        fi
    fi
    exec {ldp}<&-
}

rtfm () {
    cmd=`history | awk '
    {prevlast=last; last=$0}
    END{if (NR>1) {$0=prevlast; print $2}}
    '`
    # TODO handle subcommands
    # TODO handle aliases
    case $(type -t "$cmd") in
        builtin)
            help "$cmd";;
        *)
            man "$cmd";;
    esac
}

saveq () {
     curl "$(xclip -o -sel clip)" >/home/richard/offtopic/Q/"$(date +'%y-%m-%d')".gif
}
