#!/bin/sh
# dotfilesLink.sh
# Last Change: 2017/04/12 (Wed) 11:36:37.

mkdir ~/.xmonad      2>/dev/null
mkdir ~/.vifm        2>/dev/null
mkdir ~/.config/fish 2>/dev/null -p

ln -sf ~/dotfiles/.vimrc            ~/.vimrc
ln -sf ~/dotfiles/.inputrc          ~/.inputrc
ln -sf ~/dotfiles/.bashrc           ~/.bashrc
ln -sf ~/dotfiles/.bash_profile     ~/.bash_profile
ln -sf ~/dotfiles/.xmonad/xmonad.hs ~/.xmonad/xmonad.hs
ln -sf ~/dotfiles/.xmonad/xmobar.hs ~/.xmonad/xmobar.hs
ln -sf ~/dotfiles/.stalonetrayrc    ~/.stalonetrayrc
ln -sf ~/dotfiles/sh/lighter.sh     ~/lighter.sh
ln -sf ~/dotfiles/sh/darker.sh      ~/darker.sh
ln -sf ~/dotfiles/sh/git_push.sh    ~/push.sh
ln -sf ~/dotfiles/sh/git_pull.sh    ~/pull.sh
ln -sf ~/dotfiles/.xinitrc          ~/.xinitrc
ln -sf ~/dotfiles/.Xresources       ~/.Xresources
ln -sf ~/dotfiles/.vifm/vifmrc      ~/.vifm/vifmrc
ln -sf ~/dotfiles/config.fish       ~/.config/fish/config.fish
ln -sf ~/dotfiles/.skk-jisyo        ~/.skk-jisyo
ln -sf ~/dotfiles/.latexmkrc        ~/.latexmkrc
