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
* lsof
* neovim
* ripgrep
* stow
* vim

### Windows Subsystem for Linux

* win32yank.exe
  ```
  $ curl --location --output-dir "$HOME/.local/bin" --remote-name https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip
  $ yes | unzip -d "$HOME/.local/bin" "$HOME/.local/bin/win32yank-x64.zip"
  $ chmod u+x "$HOME/.local/bin/win32yank.exe"
  ```

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

## tmux Attach During bash Login

Run the following command to allow a new bash login shell to attach to an
existing tmux session if no client is attached, otherwise start a new session:

```
$ # Quoting or escaping the "limit string" at the head of a here document
$ # disables parameter substitution within its body.
$ cat <<'HEREDOC' >> "$HOME/.bash_profile.local"
> # Attach to an existing tmux session if no client is attached, otherwise start
> # a new session.
> if [[ $(command -v 'tmux') != '' && $TMUX == '' ]]; then
> 	tmux_detached_session="$(tmux list-sessions -F '#{session_id}' -f '#{?session_attached,0,1}' 2> /dev/null | head --lines=1)"
> 	if [[ $tmux_detached_session != '' ]]; then
> 		exec tmux attach-session -t "$tmux_detached_session" \; unbind-key d
> 	else
> 		exec tmux new-session \; unbind-key d
> 	fi
> fi
> HEREDOC
```
