# In our zshenv file we have on macOS disabled loading ZSH startup
# files from /etc to avoid /etc/zprofile messing up our carefully
# constructed PATH. By now we've already skipped /etc/zprofile, so
# re-enable them.
if [[ "$OSTYPE" == "darwin"* ]]; then
  setopt GLOBAL_RCS
fi
