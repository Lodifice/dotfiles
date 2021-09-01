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
