#!/bin/bash
############################
# .unlink.sh
# This script restores old dotfiles from the dotfiles_old folder back to the home directory and removes the dotfile_old folder
############################

########## Variables

dir=~/dotfiles					# dotfiles directory
olddir=~/dotfiles_old			 # old dotfiles backup directory
files="vimrc bashrc bash_profile tcshrc gitk gitconfig minttyrc"	# list of files/folders to symlink in homedir

##########

# remove any symbolic links to dotfiles and then move any dotfiles in dotfiles_old back to the home directory, then remove the dotfile_old folder

if [ -d $olddir ]; then
	echo "Old dotfiles detected. Starting restore procedure"

	for file in $files; do
		if [ -h ~/.$file ]; then
			echo "Removing link for $file in ~"
			rm -f ~/.$file
		else
			echo ".$file is not a link"
		fi

		if [ -e $olddir/.$file ]; then
			echo "Restoring $file from $olddir to ~"
			mv $olddir/$file ~/.$file
		fi
	done

	echo "Removing $olddir"
	rm -rf $olddir

	echo "Original dotfiles restored"

	exit
fi

echo "Old dotfiles not detected. Aborting restore procedure"
