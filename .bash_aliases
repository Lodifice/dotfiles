lf () {
    exec 4>&1
    d=$($(which lf) -last-dir-path /dev/fd/5 5>&1 >&4-)
    exec 4>&-
    [[ $d == no* ]] && return
    [ "$(pwd)" = "$d" ] || cd "$d"
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
