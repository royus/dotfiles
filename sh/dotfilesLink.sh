#!/bin/sh
# dotfilesLink.sh
# Last Change: 2018/09/27 (Thu) 19:28:33.

mkdir ~/.xmonad         2>/dev/null
mkdir ~/.vifm           2>/dev/null
mkdir ~/.config/fish    2>/dev/null -p
mkdir ~/.config/termite 2>/dev/null -p

ln -sf ~/dotfiles/.vimrc                  ~/.vimrc
ln -sf ~/dotfiles/.inputrc                ~/.inputrc
ln -sf ~/dotfiles/.bashrc                 ~/.bashrc
ln -sf ~/dotfiles/.bash_profile           ~/.bash_profile
ln -sf ~/dotfiles/.xmonad/xmonad.hs       ~/.xmonad/xmonad.hs
ln -sf ~/dotfiles/.xmonad/xmobar.hs       ~/.xmonad/xmobar.hs
ln -sf ~/dotfiles/.stalonetrayrc          ~/.stalonetrayrc
ln -sf ~/dotfiles/sh/backlight/lighter.sh ~/lighter.sh
ln -sf ~/dotfiles/sh/backlight/darker.sh  ~/darker.sh
ln -sf ~/dotfiles/sh/git/push.sh          ~/push.sh
ln -sf ~/dotfiles/sh/git/pull.sh          ~/pull.sh
ln -sf ~/dotfiles/.xinitrc                ~/.xinitrc
ln -sf ~/dotfiles/.Xresources             ~/.Xresources
ln -sf ~/dotfiles/.vifm/vifmrc            ~/.vifm/vifmrc
ln -sf ~/dotfiles/.config.fish            ~/.config/fish/config.fish
ln -sf ~/dotfiles/.termite.config         ~/.config/termite/config
ln -sf ~/dotfiles/.skk-jisyo              ~/.skk-jisyo
ln -sf ~/dotfiles/.latexmkrc              ~/.latexmkrc
