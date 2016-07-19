"Last Change: 2016/07/19 18:00:08.

"dein
if &compatible
	set nocompatible
endif
set runtimepath^=~/.vim/bundle/dein.vim
call dein#begin(expand('~/.vim/bundle/'))
call dein#add('Shougo/dein.vim')

call dein#add('scrooloose/nerdtree')
call dein#add('tpope/vim-surround')
" call dein#add('bronson/vim-trailing-whitespace')
call dein#add('tomtom/tcomment_vim')
call dein#add('itchyny/lightline.vim')
call dein#add('itchyny/calendar.vim')
call dein#add('mattn/emmet-vim')
call dein#add('w0ng/vim-hybrid')
call dein#add('easymotion/vim-easymotion')
call dein#add('vim-scripts/autodate.vim')

call dein#end()
filetype plugin indent on
if dein#check_install()
	call dein#install()
endif


"appearence
set showcmd
set title
set number ruler
set cursorline
set background=dark
set list listchars=tab:\|-,eol:~
syntax on
set t_Co=256
colorscheme hybrid
set display=lastline
highlight normal ctermbg=none
highlight clear CursorLine
highlight SpecialKey ctermbg=NONE ctermfg=black
highlight MatchParen ctermfg=darkblue ctermbg=black

"lightline
set laststatus=2
set noshowmode
let g:lightline = {
			\ 'colorscheme': 'jellybeans',
			\ }


"encoding
set encoding=utf-8 fileencodings=utf-8,iso-2022-jp,euc-jp,sjis


"indentation
set smartindent autoindent
set tabstop=4 shiftwidth=4 noexpandtab smarttab


"searches
set incsearch hlsearch ignorecase smartcase
set wildignorecase
set wildmode=list:longest,full
nnoremap <Esc><Esc> :<C-u>set nohlsearch<CR>
nnoremap / :<C-u>set hlsearch<CR>/
nnoremap ? :<C-u>set hlsearch<CR>?
nnoremap * :<C-u>set hlsearch<CR>*
nnoremap # :<C-u>set hlsearch<CR>#
nnoremap <expr> n <SID>search_forward_p() ? ':<C-u>set hlsearch<CR>nzv' : ':<C-u>set hlsearch<CR>Nzv'
nnoremap <expr> N <SID>search_forward_p() ? ':<C-u>set hlsearch<CR>Nzv' : ':<C-u>set hlsearch<CR>nzv'
vnoremap <expr> n <SID>search_forward_p() ? ':<C-u>set hlsearch<CR>nzv' : ':<C-u>set hlsearch<CR>Nzv'
vnoremap <expr> N <SID>search_forward_p() ? ':<C-u>set hlsearch<CR>Nzv' : ':<C-u>set hlsearch<CR>nzv'
function! s:search_forward_p()
	return exists('v:searchforward') ? v:searchforward : 1
endfunction


"foldings
set foldmethod=syntax foldlevel=100
autocmd InsertEnter * if &l:foldmethod ==# 'syntax'
			\		| setlocal foldmethod=manual
			\		| endif
autocmd InsertLeave * if &l:foldmethod ==# 'manual'
			\		| setlocal foldmethod=syntax
			\		| endif
set foldtext=MyFoldText()
function MyFoldText()
	let line=getline(v:foldstart)
	let line=substitute(line,'/\*\|\*/\|{{{\d\=','','g')
	let cnt = printf(' [%3s,%2s]',(v:foldend-v:foldstart+1),v:foldlevel)
	let line_width=winwidth(0)-&foldcolumn
	if &number == 1
		let line_width -= max([&numberwidth, len(line('$'))])
	endif
	let alignment = line_width - len(cnt)
	let line=strpart(printf('%-'.alignment.'s',line),0,alignment)
	let line=substitute(line,'\%( \)\@<= \%( *$\)\@=','-','g')
	return line.cnt
endfunction


"others
set noswapfile
set autochdir
set hidden
set scrolloff=7
set history=100
set backspace=start,eol,indent
set pumheight=10
set showmatch
set matchpairs+=<:>
set clipboard=unnamedplus


"mapping&function
"movements
nnoremap k	 gk
nnoremap j	 gj
vnoremap k	 gk
vnoremap j	 gj
nnoremap gk  k
nnoremap gj  j
vnoremap gk  k
vnoremap gj  j
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
cnoremap <C-l> <right>
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <Space> <NOP>
vnoremap <Space> <NOP>
nnoremap <Space>h  ^
nnoremap <Space>l  $
vnoremap <Space>h  ^
vnoremap <Space>l  $
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
nnoremap <expr> gg line(".")==1 ? 'G':'gg'

"esc
noremap  <C-@> <Esc>
inoremap <silent> jj  <Esc>
vnoremap <Tab> <Esc>

":wq
nnoremap Q  <Nop>
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap <Space>w :<C-u>w<CR>
nnoremap <Space>W :<C-u>W<CR>
command! W call s:SU_W()
function! s:SU_W()
	:w !sudo tee %
endfunction
nnoremap <Space>q :<C-u>q<CR>
nnoremap <Space>Q :<C-u>q!<CR>

"plugins
nnoremap <Space>n :NERDTreeToggle<CR>
nnoremap <Space>c :Calendar<CR>
nnoremap <F10> 1ggOLast Change: .<CR><Esc>
let autodate_format = '%Y/%m/%d %H:%M:%S'

"functions
let mapleader=","
nnoremap Y y$
nnoremap <Space>i gg=<S-g><C-o><C-o>
nnoremap <Space>v 0v$h
nnoremap <Space>d 0v$hx
nnoremap <Space>y 0v$hy
vnoremap <Space>p "0p
nnoremap + <C-a>
nnoremap - <C-x>
nnoremap & :&&<CR>
xnoremap & :&&<CR>
nnoremap <CR> i<CR><Esc>
nnoremap <Space>o  :<C-u>for i in range(v:count1) \| call append(line('.'), '') \| endfor<CR>
nnoremap <Space>O  :<C-u>for i in range(v:count1) \| call append(line('.')-1, '') \| endfor<CR>
nnoremap gs :<C-u>%s///g<Left><Left><Left>
vnoremap gs :s///g<Left><Left><Left>
command! RUN call s:RUN()
nnoremap <F5> :RUN<CR>
inoremap <F5> <Esc>:RUN<CR>
vnoremap <F5> <Esc>:RUN<CR>
function! s:RUN()
	:w
	let e = expand("%:e")
	if e == "c"
		:GCC
		:!./.x_%:r
	endif
	if e == "java"
		:JAVAC
		:!java %:r
	endif
	if e == "rb"
		:!ruby %
	endif
	if e == "py"
		:!python %
	endif
	if e == "ml"
		:!ocaml -init %
	endif
endfunction
command! GCC call s:GCC()
function! s:GCC()
	:w
	:!gcc % -O3 -lm -lGL -lGLU -lglut -o .x_%:r -Wall
endfunction
command! JAVAC call s:JAVAC()
function! s:JAVAC()
	:w
	:!javac %
endfunction
