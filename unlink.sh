#!/bin/bash
# unlink.sh - This script restores old dotfiles from the $olddir folder back to the home directory and removes the $olddir folder
# Author: Chad Paradis


dir=~/.dotfiles                 # dotfiles directory
olddir=~/.dotfiles.bak          # old dotfiles backup directory

files="bash_profile bashrc gitconfig gitignore_global minttyrc tmux.conf vimrc vim"    # list of files/folders to symlink in homedir
oldfiles=`ls $olddir`


# remove any symbolic links to dotfiles and then move any dotfiles in $olddir back to the home directory, then remove the $olddir folder
if [ -d $olddir ]; then
	echo "Old dotfiles detected. Starting restore procedure"

	for file in $files; do
		if [ -h ~/.$file ]; then
			echo "Removing symlink for ~/.$file"
			rm -f ~/.$file
		else
			echo "~/.$file is not a symlink"
		fi
	done


# restore all files and folders from olddir
	for oldfile in $oldfiles; do
		if [ -f $olddir/$oldfile ] || [ -d $olddir/$oldfile ]; then
			echo "Restoring $olddir/$oldfile to ~/.$oldfile"
			mv $olddir/$oldfile ~/.$oldfile
		fi
	done

	echo "Removing $olddir"
	rm -rf $olddir

	echo "Original dotfiles restored"
else
	echo "Old dotfiles not detected. Aborting restore procedure"
fi
