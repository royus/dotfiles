#!/bin/sh
# dotfilesLink.sh
# Last Change: 2019/02/06 (Wed) 14:25:12.

mkdir ~/.xmonad           2>/dev/null
mkdir ~/.vifm             2>/dev/null
mkdir ~/.config/fish      2>/dev/null -p
mkdir ~/.config/termite   2>/dev/null
mkdir ~/.config/karabiner 2>/dev/null

ln -sf ~/dotfiles/.vimrc                  ~/.vimrc
ln -sf ~/dotfiles/linux/.inputrc          ~/.inputrc
ln -sf ~/dotfiles/linux/.bashrc           ~/.bashrc
ln -sf ~/dotfiles/linux/.bash_profile     ~/.bash_profile
ln -sf ~/dotfiles/linux/.xmonad/xmonad.hs ~/.xmonad/xmonad.hs
ln -sf ~/dotfiles/linux/.xmonad/xmobar.hs ~/.xmonad/xmobar.hs
ln -sf ~/dotfiles/linux/.stalonetrayrc    ~/.stalonetrayrc
ln -sf ~/dotfiles/linux/.xinitrc          ~/.xinitrc
ln -sf ~/dotfiles/linux/.Xresources       ~/.Xresources
ln -sf ~/dotfiles/linux/.vifm/vifmrc      ~/.vifm/vifmrc
ln -sf ~/dotfiles/linux/.config.fish      ~/.config/fish/config.fish
ln -sf ~/dotfiles/linux/.termite.config   ~/.config/termite/config
ln -sf ~/dotfiles/linux/.skk-jisyo        ~/.skk-jisyo
ln -sf ~/dotfiles/linux/.latexmkrc        ~/.latexmkrc

ln -sf ~/dotfiles/sh/backlight/lighter.sh ~/lighter.sh
ln -sf ~/dotfiles/sh/backlight/darker.sh  ~/darker.sh
ln -sf ~/dotfiles/sh/git/push.sh          ~/push.sh
ln -sf ~/dotfiles/sh/git/pull.sh          ~/pull.sh
