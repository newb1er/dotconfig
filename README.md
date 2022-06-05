# Manage Dotfiles

This is management system is introduced by [StreakyCobra](https://news.ycombinator.com/item?id=11071754).

To be honest, manage dotfiles on linux system is quite a pain in the ass. Managing dotfiles seperated in different directories is a hard work. Therefore, someone comes up with a brillian idea and totally make sence.

This technique is brought by [StreakyCobra](https://news.ycombinator.com/user?id=StreakyCobra) from [Hacker News Thread](https://news.ycombinator.com/news).
By leveraging git bare, which seperate the .git files into a *side* folder without interfering with the existed repos.

## For Starters
Let's create a new bare repo.

You can alias the command to accelerate the process.

```bash
git init --bare $HOME/.dotfile
echo "alias dotfile='/usr/bin/git --git-dir=$HOME/.dotfile --work-tree=$HOME'" >> $HOME/.bashrc
dotfile config -local status.showUntrackedFiles no
```

## Pack Dotfiles

Now, the repo has been created. Let's pack some dotfiles.

```bash
dotfile add .vimrc
dotfile commit -m "Add vimrc"
dotfile add .bashrc
dotfile commit -m "Add bashrc"
dotfile push
```

## Restore Into New System

Before started, we have to make sure we add the dotfile folder into `.gitignore` to avoid the recursion problem.

```bash
echo ".dotfile" >> .gitignore
```

Clone the repo and checkout the content into `$HOME`.

```bash
git clone --bare <repo-url> $HOME/.dotfile
alias dotfile='/usr/bin/git --git-dir=$HOME/.dotfile --work-tree=$HOME'
dotfile config -local status.showUntrackedFiles no
dotfile checkout
```

Sometimes, there might be some default configuration files that are conflict with current repo. To resolve this, you can either delete them if you don't need them or make a backup.

Here is the script for backup.

```bash
mkdir -p .dotfile-backup && \
	dotfile checkout 2>&1 | \
	egrep "\s+\." | awk {'print $1'} | \
	xargs -I{} mv {} .dotfile-backup/{}
dotfile checkout
```
###### refs
- https://www.atlassian.com/git/tutorials/dotfiles
- https://news.ycombinator.com/item?id=11071754
