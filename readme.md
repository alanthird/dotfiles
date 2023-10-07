## urxvt daemon and client

Run:

```
sudo update-alternatives                                    \
       --install $(whence x-terminal-emulator)              \
                 x-terminal-emulator                        \
                 $(whence urxvtcd)                          \
                 50                                         \
       --slave /usr/share/man/man1/x-terminal-emulator.1.gz \
               x-terminal-emulator.1.gz                     \
               /usr/share/man/man1/urxvtcd.1.gz

sudo update-alternatives --set x-terminal-emulator $(whence urxvtcd)
```

## Mutt on the Mac

```
sudo port install mutt +db4
mkdir -p ~/.cache/mutt
```
