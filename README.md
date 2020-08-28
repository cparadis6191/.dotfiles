# .dotfiles

## Create Local Configuration Files

Run the following commands to create local configuration files for bash,
Neovim, Git, and Vim:

```
$ touch "$HOME/.bash_profile.local"
$ touch "$HOME/.bashrc.local"
$ touch "$HOME/.config/nvim/local.init.vim"
$ touch "$HOME/.gitconfig.local"
$ touch "$HOME/.vimrc.local"
```

These local configuration files will be sourced automatically by the respective
configuration files in this repository.

## Set Up Local bin

Run the following commands to create a local bin directory and add it to the
PATH:

```
$ mkdir --parents "$HOME/.local/bin"
$ echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bash_profile.local"
```

## Software to Install

* curl
* ctags
* git
  * diff-highlight
    ```
    $ cat <(echo '#!/usr/bin/env perl') /usr/share/doc/git/contrib/diff-highlight/{DiffHighlight.pm,diff-highlight.perl} > "$HOME/.local/bin/diff-highlight"
    $ chmod u+x "$HOME/.local/bin/diff-highlight"
    ```
  * git-jump
    ```
    $ cp /usr/share/doc/git/contrib/git-jump/git-jump "$HOME/.local/bin"
    $ chmod u+x "$HOME/.local/bin/git-jump"
    ```
* lsof
* neovim
* ripgrep
* stow
* vim

## Installation Instructions

Run the following commands from the root directory of this repository to create
symbolic links in the home directory to the various configuration files
contained in this repository:

```
$ stow --adopt alacritty bash git inputrc nvim tmux vim
$ git stash save "stow"
```

## Set Up Clipboard Commands

Install a clipboard manager and define yeet and yoink commands.

Run the following commands to define the yeet and yoink commands for Windows
Subsystem for Linux:

```
$ echo "alias yeet='win32yank.exe -i'" >> "$HOME/.bashrc.local"
$ echo "alias yoink='win32yank.exe -o'" >> "$HOME/.bashrc.local"
```
