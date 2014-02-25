#!/bin/bash
# link.sh - This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
# Author: Chad Paradis


# -- Variables --

dir=~/.dotfiles                 # dotfiles directory
olddir=~/.dotfiles.bak          # old dotfiles backup directory
                                # list of files/folders to symlink in homedir
files="bash_profile bashrc gitconfig gitignore_global minttyrc vimrc vim"


# create .dotfiles.bak in homedir
if [ ! -d $olddir ]; then
	echo "Creating $olddir for backup of any existing dotfiles in ~"
	mkdir -p $olddir
else
	echo "$olddir already exists"
fi


# move any existing dotfiles in ~ to ~/.dotfiles.bak, then create symlinks from ~ to any files in the ~/.dotfiles directory specified in $files
for file in $files; do
	if [ -h ~/.$file ]; then
		echo "Symlink for .$file already exists"
		continue
	else
		if [ -f ~/.$file ]; then
			echo "Moving ~/.$file to $olddir/.$file"
			mv ~/.$file $olddir/$file
		fi
	fi

	echo "Making symlink from ~/.$file to $dir/$file"
	ln -s $dir/$file ~/.$file
done
