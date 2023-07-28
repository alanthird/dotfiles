#!/bin/zsh

read \?"Search query: "

notmuch mutt search -r -o ~/.cache/Maildir/search $REPLY
