#!/bin/bash
# unlink.sh - This script restores old dotfiles from the dotfiles_old folder back to the home directory and removes the dotfile_old folder
# Author: Chad Paradis


# -- Variables --

dir=~/.dotfiles                 # dotfiles directory
olddir=~/.dotfiles.bak          # old dotfiles backup directory
                                # list of files/folders to symlink in homedir
files="bash_profile bashrc gitconfig gitignore_global minttyrc tmux.conf vimrc vim"


# remove any symbolic links to dotfiles and then move any dotfiles in dotfiles_old back to the home directory, then remove the dotfile_old folder
if [ -d $olddir ]; then
	echo "Old dotfiles detected. Starting restore procedure"

	for file in $files; do
		if [ -h ~/.$file ]; then
			echo "Removing symlink for ~/.$file"
			rm -f ~/.$file
		else
			echo "~/.$file is not a symlink"
		fi

		if [ -f $olddir/$file ] || [ -d $olddir/$file ]; then
			echo "Restoring $olddir/$file to ~/.$file"
			mv $olddir/$file ~/.$file
		fi
	done

	echo "Removing $olddir"
	rm -rf $olddir

	echo "Original dotfiles restored"
else
	echo "Old dotfiles not detected. Aborting restore procedure"
fi
