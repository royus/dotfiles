#!/bin/sh
# init.sh
# Last Change: 2018/12/24 (Mon) 11:01:51.

git init
cat ~/dotfiles/.gitignore >> .gitignore
# rm -r build/
git add .gitignore
git add *
git commit -a -m "Initial Commit"
