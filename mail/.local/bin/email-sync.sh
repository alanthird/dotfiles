#!/bin/zsh

case `uname` in
    "Darwin")
        # macOS
        mbsync -a
        ;;
    "Linux")
        systemd --user --wait start mbsync.service
        ;;
    *)
        echo "Unknown OS"
esac
