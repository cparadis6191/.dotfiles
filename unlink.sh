#!/bin/bash
############################
# .make.sh
# This script restores old dotfiles from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir=~/dotfiles					# dotfiles directory
olddir=~/dotfiles_old			 # old dotfiles backup directory
files="vimrc bashrc bash_profile tcshrc gitk gitconfig minttyrc"	# list of files/folders to symlink in homedir

##########

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
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
