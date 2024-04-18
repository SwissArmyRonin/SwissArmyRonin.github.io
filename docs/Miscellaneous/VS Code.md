# VS Code

## Making the shell behave

Disable the setting `Terminal > Integrated: Allow Chords`.

Put this in `.bashrc` to make ctrl-S work for forward command history search (don't interpret ctrl-s and ctrl-q as control flow keys).
```shell
stty -ixon
```

