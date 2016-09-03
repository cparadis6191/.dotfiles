#!/usr/bin/env bash
# Create symlinks in $HOME to the specified dotfiles in .dotfiles


olddir="$HOME/.dotfiles.bak"    # Old dotfiles backup directory

files="bash_profile bashrc gitconfig gitignore_global minttyrc vimrc"    # List of files/folders to symlink in homedir
folders="vim config"
files+=" $folders"

# Create .dotfiles.bak in homedir
if [ ! -d "$olddir" ]; then
	echo "Creating $olddir for backup of any existing dotfiles in $HOME"
	mkdir -p "$olddir"
else
	echo "$olddir already exists"
fi

# Create all necessary local folders
for folder in $folders; do
	if [ ! -d "$folder" ]; then
		echo "Creating $folder to link to from $HOME"
		mkdir -p "$folder"
	fi
done

# Move any existing dotfiles in $HOME to $HOME/.dotfiles.bak, then create symlinks from $HOME to any files in the .dotfiles directory specified in $files
for file in $files; do
	if [ -h "$HOME/.$file" ]; then
		echo "Symlink for .$file already exists"
		continue
	else
		if [ -f "$HOME/.$file" ] || [ -d "$HOME/.$file" ]; then
			echo "Moving $HOME/.$file to $olddir/.$file"
			mv "$HOME/.$file" "$olddir/.$file"
		fi
	fi

	echo "Making symlink from $HOME/.$file to $file"
	ln -s "`pwd`/$file" "$HOME/.$file"
done
