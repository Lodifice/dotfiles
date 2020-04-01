#!/usr/bin/env bash
[ "$(whoami)" = gpg ] || exit 1
tmpdir=$(mktemp -d /tmp/pass-user-pwsXXX)

# Enter your pass entries here.
# Note: they will be basename'd, so the basenames shall not overlap
for pw in $PASS_ENTRIES
do
    sudo -u $USER pass "$pw" > "$tmpdir/$(basename $pw)"
done
