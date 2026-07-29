# dotfiles

Alex Selesse's dotfiles.

This repository is assumed to be kept in `$HOME/git/dotfiles`. The dotfiles
are symlinked into the user's home directory. There are 2 main disadvantages
to this approach:

1. Every time a new dotfile is added or removed, the linking script needs to
   be run.
2. The linking script is safe by default. If an existing dotfile (i.e.
   `bashrc`) already exists, it will not be overwritten. This means that the
   user must delete existing and conflicting files before running the linking
   script.

## Updating an existing machine

After pulling changes that add, remove, or move dotfiles, rerun the linker:

```sh
./create-symlinks
```

The full `./setup` is only needed for first-time setup. The linker migrates the
legacy dotfiles-managed `~/.gitconfig` symlink while preserving settings in a
regular machine-local Git config.

## Overview

The main components of this repository are the [zshrc](.zshrc) and the
[vimrc](.vimrc). These are the files that are the most likely to change and
the most important in the repository.
