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
* python3-virtualenv
* ripgrep
* stow
* unzip

## Installation Instructions

Run the following commands from the root directory of this repository to create
symbolic links in the home directory to the various configuration files
contained in this repository:

```
$ stow --adopt alacritty bash config git inputrc tmux vim
$ git stash save "stow"
```

## Set Up Clipboard Commands

Install a clipboard manager and define yeet-impl, yoink, and yedit commands.

### Set Up yedit

```
$ cat << 'HEREDOC' > "$HOME/.local/bin/yedit"
> #!/usr/bin/env bash
>
> yoink | vipe | yeet
> HEREDOC
$ chmod u+x "$HOME/.local/bin/yedit"
```

### Windows Subsystem for Linux

Run the following commands to define the yeet-impl and yoink commands for
Windows Subsystem for Linux:

```
$ cat << 'HEREDOC' > "$HOME/.local/bin/yeet-impl"
> #!/usr/bin/env bash
>
> cat - | win32yank.exe -i
> HEREDOC
$ chmod u+x "$HOME/.local/bin/yeet-impl"
```

```
$ cat << 'HEREDOC' > "$HOME/.local/bin/yoink"
> #!/usr/bin/env bash
>
> win32yank.exe -o --lf
> HEREDOC
$ chmod u+x "$HOME/.local/bin/yoink"
```

Run the following commands to set up a clipboard manager for Windows Subsystem
for Linux:

```
$ curl --location --output-dir "$HOME/.local/bin" --remote-name https://github.com/equalsraf/win32yank/releases/latest/download/win32yank-x64.zip
$ yes | unzip -d "$HOME/.local/bin" "$HOME/.local/bin/win32yank-x64.zip"
$ chmod u+x "$HOME/.local/bin/win32yank.exe"
```

### Xterm

Run the following commands to define the yeet-impl and yoink commands for
xterm:

```
$ cat << 'HEREDOC' > "$HOME/.local/bin/yeet-impl"
> #!/usr/bin/env bash
>
> cat - | nohup xclip -in > /dev/null 2>&1
> HEREDOC
$ chmod u+x "$HOME/.local/bin/yeet-impl"
```

```
$ cat << 'HEREDOC' > "$HOME/.local/bin/yoink"
> #!/usr/bin/env bash
>
> xclip -out 2> /dev/null
> HEREDOC
$ chmod u+x "$HOME/.local/bin/yoink"
```

## Set Up fzf

### bash

Run the following commands to set up bash completion and key-bindings for fzf:

```
$ echo "source '/usr/share/bash-completion/completions/fzf'" >> "$HOME/.local/etc/.bashrc"
$ echo "source '/usr/share/doc/fzf/examples/key-bindings.bash'" >> "$HOME/.local/etc/.bashrc"
```

### fish

Run the following command to set up fish completion and key-bindings for fzf:

```
$ echo 'fzf --fish | source' >> ~/.local/etc/.config/fish/config.fish
```

### Set Up fzf-git

Run the following commands to install key-bindings for
fzf-git:

```
$ git clone --depth 1 https://github.com/junegunn/fzf-git.sh.git "$HOME/.local/etc/fzf-git.sh"
$ echo 'source "$HOME/.local/etc/fzf-git.sh/fzf-git.sh"' >> "$HOME/.local/etc/.bashrc"
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
$ cat << 'HEREDOC' >> "$HOME/.local/etc/.bash_profile"
> # Attach to an existing tmux session if no client is attached, otherwise start
> # a new session.
> if [[ $TMUX == '' && $(command -v 'tmux') != '' ]]; then
> 	delim=$'\t'
> 	tmux_detached_session="$(tmux list-sessions -F "#{session_id}$delim#{session_attached}" 2> /dev/null |
> 		grep --basic-regexp --regexp='0$' |
> 		head --lines=1 |
> 		cut --fields=1)"
> 	if [[ $tmux_detached_session != '' ]]; then
> 		exec tmux attach-session -t "$tmux_detached_session" \; unbind-key d
> 	else
> 		exec tmux unbind-key d \; new-session fish
> 	fi
> fi
> HEREDOC
```

## Configure Alacritty on Windows

Run the following command to copy .alacritty.toml to where Alacritty expects it
to be on Windows:

```
$ cp 'alacritty/.alacritty.toml' "/mnt/c/Users/$(cmd.exe /c "echo %USERNAME%" 2> /dev/null |
> sed 's/\r$//')/AppData/Roaming/alacritty/alacritty.toml"
```

## Activate Python virtualenv During bash Login

Run the following commands to allow a new bash login shell to activate a Python
virtualenv:

```
$ virtualenv --download "$HOME/.virtualenv"
$ echo 'VIRTUAL_ENV_DISABLE_PROMPT=1' >> "$HOME/.local/etc/.bash_profile"
$ echo 'source "$HOME/.virtualenv/bin/activate"' >> "$HOME/.local/etc/.bash_profile"
```
