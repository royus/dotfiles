#!/bin/sh
# dotfilesLink.sh
# Last Change: 2017/03/27 (Mon) 10:36:20.

ln -sf ~/dotfiles/.vimrc         ~/.vimrc
ln -sf ~/dotfiles/.inputrc       ~/.inputrc
ln -sf ~/dotfiles/.bashrc        ~/.bashrc
ln -sf ~/dotfiles/.bash_profile  ~/.bash_profile
ln -sf ~/dotfiles/.xmonad        ~/.xmonad
ln -sf ~/dotfiles/.stalonetrayrc ~/.stalonetrayrc
ln -sf ~/dotfiles/sh/lighter.sh  ~/lighter.sh
ln -sf ~/dotfiles/sh/darker.sh   ~/darker.sh
ln -sf ~/dotfiles/.xinitrc       ~/.xinitrc
ln -sf ~/dotfiles/.Xresources    ~/.Xresources
ln -sf ~/dotfiles/.vifm          ~/.vifm
mkdir ~/.config
mkdir ~/.config/fish
ln -sf ~/dotfiles/config.fish    ~/.config/fish/config.fish
ln -sf ~/dotfiles/.skk-jisyo     ~/.skk-jisyo
