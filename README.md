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

## Overview

The main components of this repository are the [zshrc](.zshrc) and the
[vimrc](.vimrc). These are the files that are the most likely to change and
the most important in the repository.
