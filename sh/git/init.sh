#!/bin/sh
# init.sh
# Last Change: 2018/09/27 (Thu) 19:28:06.

git init
cp ~/dotfiles/.gitignore .
# rm -r build/
git add .gitignore
git add *
git commit -a -m "Initial Commit"
