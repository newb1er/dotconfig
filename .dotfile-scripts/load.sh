#!/bin/bash

REPO='https://github.com/newb1er/dotconfig'

git clone --bare $REPO $HOME/.dotfile

function dotfile {
	/usr/bin/git --git-dir=$HOME/.dotfile/ --work-tree=$HOME $@
}

config checkout
if [ $? = 0 ]; then
	echo "Dotfiles loaded."
else
	mkdir -p home-bak
	dotfile checkout 2>&1 | egrep "\s+\." | \
		awk {'print $1'} | xargs -I{} mv {} home-bak/{}
	dotfile checkout
fi

dotfile config -local status.showUntrackedFiles no
