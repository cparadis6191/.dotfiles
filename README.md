# .dotfiles

## Set Up Local etc

Run the following commands to create a local etc directory:

```
$ mkdir --parents "$HOME/.local/etc"
```

## Create Local Configuration Files

Run the following commands to create local configuration files for bash,
Neovim, Git, inputrc, and Vim:

```
$ touch "$HOME/.local/etc/.bash_profile"
$ touch "$HOME/.local/etc/.bashrc"
$ mkdir --parents "$HOME/.local/etc/.config/nvim"
$ touch "$HOME/.local/etc/.config/nvim/init.vim"
$ touch "$HOME/.local/etc/.gitconfig"
$ touch "$HOME/.local/etc/.inputrc"
$ touch "$HOME/.local/etc/.vimrc"
```

These local configuration files will be sourced automatically by the respective
configuration files in this repository.

## Migrate Local Configuration Files

Run the following commands to migrate local configuration files for bash,
Neovim, Git, inputrc, and Vim to the local etc directory:

```
$ mv "$HOME/.bash_profile.local" "$HOME/.local/etc/.bash_profile"
$ mv "$HOME/.bashrc.local" "$HOME/.local/etc/.bashrc"
$ mv "$HOME/.config/nvim/local.init.vim" "$HOME/.local/etc/.config/nvim/init.vim"
$ mv "$HOME/.gitconfig.local" "$HOME/.local/etc/.gitconfig"
$ mv "$HOME/.inputrc.local" "$HOME/.local/etc/.inputrc"
$ mv "$HOME/.vimrc.local" "$HOME/.local/etc/.vimrc"
```

## Set Up Local bin

Run the following commands to create a local bin directory and add it to the
PATH:

```
$ mkdir --parents "$HOME/.local/bin"
$ echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.local/etc/.bash_profile"
```

## Software to Install

* curl
* ctags
* fdfind
* fzf
* git
* lsof
* neovim
* ripgrep
* stow
* unzip

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
$ echo "alias yeet='win32yank.exe -i'" >> "$HOME/.local/etc/.bashrc"
$ echo "alias yoink='win32yank.exe -o'" >> "$HOME/.local/etc/.bashrc"
```

### Windows Subsystem for Linux

Run the following commands to set up a clipboard manager for Windows Subsystem
for Linux:

```
$ curl --location --output-dir "$HOME/.local/bin" --remote-name https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip
$ yes | unzip -d "$HOME/.local/bin" "$HOME/.local/bin/win32yank-x64.zip"
$ chmod u+x "$HOME/.local/bin/win32yank.exe"
```

## Set Up fzf

Run the following commands to set up bash completion and key-bindings for fzf:

```
$ echo 'source "/usr/share/doc/fzf/examples/completion.bash"' >> "$HOME/.local/etc/.bashrc"
$ echo 'source "/usr/share/doc/fzf/examples/key-bindings.bash"' >> "$HOME/.local/etc/.bashrc"
```

### Set Up fzf-git

Run the following commands to install key-bindings for
fzf-git:

```
$ git clone --depth 1 https://gist.github.com/9685cc9eeacdcc8254bff2a5ad6b35d4.git "$HOME/.local/etc/fzf-git"
$ echo 'source "$HOME/.local/etc/fzf-git/fzf-git.bash"' >> "$HOME/.local/etc/.bashrc"
$ echo '$include ~/.local/etc/fzf-git/fzf-git.inputrc' >> "$HOME/.local/etc/.inputrc"
```

### Set Up fzf-tmux

Run the following commands to install key-bindings for fzf-tmux:

```
$ git clone --depth 1 https://gist.github.com/6b246a154e6392c1637fd763c1ada8ab.git "$HOME/.local/etc/fzf-tmux"
$ echo 'source "$HOME/.local/etc/fzf-tmux/fzf-tmux.bash"' >> "$HOME/.local/etc/.bashrc"
$ echo '$include ~/.local/etc/fzf-tmux/fzf-tmux.inputrc' >> "$HOME/.local/etc/.inputrc"
```

## Set Up diff-so-fancy

Run the following commands to install diff-so-fancy:

```
$ git clone --depth 1 https://github.com/so-fancy/diff-so-fancy.git "$HOME/.local/bin/diff-so-fancy.git"
$ ln --symbolic "$HOME/.local/bin/diff-so-fancy.git/diff-so-fancy" "$HOME/.local/bin/"
```

## tmux Attach During bash Login

Run the following command to allow a new bash login shell to attach to an
existing tmux session if no client is attached, otherwise start a new session:

```
$ # Quoting or escaping the "limit string" at the head of a here document
$ # disables parameter substitution within its body.
$ cat << 'EOF' >> "$HOME/.local/etc/.bash_profile"
> # Attach to an existing tmux session if no client is attached, otherwise start
> # a new session.
> if [[ $(command -v 'tmux') != '' && $TMUX == '' ]]; then
> 	delim=$'\t'
> 	tmux_detached_session="$(tmux list-sessions -F "#{session_id}$delim#{session_attached}" 2> /dev/null |
> 		grep --basic-regexp --regexp='0$' |
> 		head --lines=1 |
> 		cut --fields=1)"
> 	if [[ $tmux_detached_session != '' ]]; then
> 		exec tmux attach-session -t "$tmux_detached_session" \; unbind-key d
> 	else
> 		exec tmux new-session \; unbind-key d
> 	fi
> fi
> EOF
```
