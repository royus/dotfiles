#!/bin/sh
# init.sh
# Last Change: 2019/12/02 (Mon) 11:30:36.

git init
cat ~/dotfiles/.gitignore >> .gitignore
touch .todo
# rm -r build/
git add .gitignore
git add *
git commit -a -m "Initial Commit"
