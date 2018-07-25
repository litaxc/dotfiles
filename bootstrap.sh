#!/bin/bash
# --------------------------------------
# Boostrap all your config files
# --------------------------------------

# Define source and backup directory
dir=$HOME/.dotfiles
origdir=$HOME/.dotfiles.orig

# --------------------------------------
# Put config/dir to sync in this variable
# --------------------------------------

files=(
       .gitconfig
       .gitignore_global
       .jshintrc
       .Rprofile
       .tmux.conf
       .zshrc
       .pip
       .config
       .flake8
)


# --------------------------------------
# Start symlink files
# --------------------------------------

echo -n "Creating $origdir for backup ..."
mkdir -p $origdir
echo "done"

echo -n "cd to $dir ..."
cd $dir
echo "done"

# Symlink files
for file in ${files[@]}; do
    echo "$file"
    echo -e "\tMoving $file to $origdir"
    if [[ -z "$file" ]]; then
        echo -e "No file $file found"
        return
    fi
    mkdir -p $HOME/$(dirname $file)
    mv $HOME/$file $origdir
    echo -e "\tSymlinking to $file in $dir"
    ln -is $dir/$file $HOME/$file
done

# sublime's setting cannot be symbolic link
ln -i Preferences.sublime-settings ~/Library/Application\ Support/Sublime\ Text\ 3/Packages/User