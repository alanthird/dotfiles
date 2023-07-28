#!/bin/zsh

case `uname` in
    "Darwin")
        # macOS
        mbsync -a
        ;;
    "Linux")
        systemctl --user --wait start mbsync.service
        ;;
    *)
        echo "Unknown OS"
esac
