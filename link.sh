#!/bin/bash
###############################################################################
# .link.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
###############################################################################

########## Variables ##########################################################

dir=~/.dotfiles					# dotfiles directory
olddir=~/.dotfiles_old			# old dotfiles backup directory
files="vimrc bashrc bash_profile gitconfig minttyrc"	# list of files/folders to symlink in homedir

###############################################################################

# create dotfiles_old in homedir
if [ ! -d $olddir ]; then
	echo "Creating $olddir for backup of any existing dotfiles in ~"
	mkdir -p $olddir
else
	echo "$olddir already exists"
fi


# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
	if [ -h ~/.$file ]; then
		echo "Link already exists"
		continue
	else
		if [ -f ~/.$file ]; then
			echo "Moving .$file from ~/ to $olddir"
			mv ~/.$file $olddir/$file
		fi
	fi

	echo "Creating symlink to $file in home directory"
	ln -s $dir/$file ~/.$file
done
