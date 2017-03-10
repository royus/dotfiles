# ln -sf ~/dotfiles/.fishrc ~/.config/fish/config.fish
# fish_vi_mode

#alias
alias fishrc='vim ~/dotfiles/config.fish'
alias vimrc='vim ~/.vimrc'
alias vi='vim'
alias ..    'cd ..'
alias ...   'cd ../..'
alias ....  'cd ../../..'
alias ..... 'cd ../../../..'
alias cp 'cp -i'
alias rm 'rm -i'
alias mv 'mv -i'
function cd
	builtin cd $argv
	ls -A
end

#appearance
set fish_color_autosuggestion BD93F9
set fish_color_command F8F8F2
set fish_color_comment 6272A4
set fish_color_end 50FA7B
set fish_color_error FFB86C
set fish_color_param FF79C6
set fish_color_quote F1FA8C
set fish_color_redirection 8BE9FD
set __fish_git_prompt_showdirstate "yes"
set __fish_git_prompt_showstashstate "yes"
set __fish_git_prompt_showupstream "yes"
set __fish_git_prompt_color_branch bryellow
function fish_prompt
	set_color normal
	set -l uid (id -u $USER)
	if test $uid -eq 0
		set_color red
	end
	printf '['
	set_color green
	printf '%s' (whoami)
	printf '@'
	printf '%s' (hostname)
	printf ' '
	set_color normal
	printf '%s' (date +%H:%M:%S)
	printf ' '
	set_color yellow
	printf '%s' (prompt_pwd)
	set_color normal
	if test $uid -eq 0
		set_color red
	end
	printf ']'
	printf '%s' (__fish_git_prompt)
	printf '\n'
	# printf '%s' (fish_default_mode_prompt)
	set_color normal
	switch $fish_bind_mode
		case default
			set_color 334C66
			printf '>'
			set_color 5985B2
			printf '>'
			set_color 7FBFFF
			printf '>'
		case insert
			set_color 336633
			printf '>'
			set_color 59B259
			printf '>'
			set_color 7FFF7F
			printf '>'
		case visual
			set_color 663333
			printf '>'
			set_color B25959
			printf '>'
			set_color FF7F7F
			printf '>'
	end
	set_color normal
	printf ' '
end

#path
set PATH /usr/local/bin /usr/sbin /sbin $PATH

#vi_mode
fish_vi_key_bindings
function fish_user_key_bindings
	for mode in insert default visual
		fish_default_key_bindings -M $mode
	end
	fish_vi_key_bindings --no-erase
end
function fish_mode_prompt
	# NOOP - Disable vim mode indicator
end
