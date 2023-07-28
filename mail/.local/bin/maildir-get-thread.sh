#!/bin/zsh

ID=`rg "^Message-I[dD]: " - | head -n 1 | cut -d'<' -f2- | cut -d'>' -f1`

echo "Searching for emails related to Message-ID: $ID"

mu find --clearlinks --format=links --linksdir=~/.cache/Maildir/thread --skip-dups --include-related "msgid:${ID}"
