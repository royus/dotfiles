# If not running interactively, don't do anything
case $- in
	*i*) ;;
	*) return;;
esac

# history
HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000
shopt -s histappend
shopt -s checkwinsize

# less for binaries
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# color & ls aliases
if [ -x /usr/bin/dircolors ]; then
	test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
	alias ls='ls --color=auto'
	alias grep='grep --color=auto'
	alias fgrep='fgrep --color=auto'
	alias egrep='egrep --color=auto'
fi
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# extension hook
if [ -f ~/.bash_aliases ]; then
	. ~/.bash_aliases
fi

# bash completion
if ! shopt -oq posix; then
	if [ -f /usr/share/bash-completion/bash_completion ]; then
		. /usr/share/bash-completion/bash_completion
	elif [ -f /etc/bash_completion ]; then
		. /etc/bash_completion
	fi
fi

# prompt
export PS1="[\[\033[32m\]\u@\h \[\033[00m\]\t \[\033[33m\]\w\[\033[00m\]]\n\$ "

# user
alias vimrc='vim ~/.vimrc'
alias vi='vim'
complete -cf sudo

export PATH=/sbin:/usr/sbin:/usr/local/sbin:$PATH
export LANG=C

if [ -e ~/.local_bashrc ]; then
	source .local_bashrc
fi
