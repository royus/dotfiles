"Last Change: 2016/08/08 01:32:36.

set shell=/bin/sh
let patched_font = 1

"dein
let s:dein_dir = expand('~/.vim/bundle')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'
if &runtimepath !~# '/dein.vim'
	if !isdirectory(s:dein_repo_dir)
		execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
	endif
	execute 'set runtimepath^=' . fnamemodify(s:dein_repo_dir, ':p')
endif
if isdirectory(s:dein_repo_dir)
	call dein#begin(s:dein_dir)
	call dein#add('Shougo/dein.vim')
	"functions
	call dein#add('itchyny/calendar.vim')
	call dein#add('modsound/gips-vim')
	call dein#add('thinca/vim-scouter')
	call dein#add('scrooloose/syntastic')
	" call dein#add('Shougo/unite.vim')
	" call dein#add('Shougo/unite-outline')
	" call dein#add('ujihisa/unite-colorscheme')
	" call dein#add('Shougo/neomru.vim')
	" call dein#add('Shougo/vimproc')
	"appearence
	call dein#add('w0ng/vim-hybrid')
	call dein#add('itchyny/lightline.vim')
	"input
	call dein#add('vim-scripts/autodate.vim')
	call dein#add('tomtom/tcomment_vim')
	call dein#add('tpope/vim-surround')
	call dein#add('mattn/emmet-vim')
	call dein#add('Shougo/neocomplete.vim')
	call dein#add('Shougo/neosnippet.vim')
	call dein#add('Shougo/neosnippet-snippets')
	call dein#add('junegunn/vim-easy-align')
	"files
	call dein#add('soramugi/auto-ctags.vim')
	call dein#add('majutsushi/tagbar')
	call dein#add('scrooloose/nerdtree')
	"end
	call dein#end()
	filetype plugin indent on
	if dein#check_install()
		call dein#install()
	endif

	"plugins
	colorscheme hybrid
	nnoremap <F2> :NERDTreeToggle<CR>:TagbarToggle<CR>:echo<CR>
	nnoremap <Space>n :NERDTreeToggle<CR>
	nnoremap <Space>c :TagbarToggle<CR>
	nnoremap <Space>C :Calendar -first_day=monday<CR>
	let g:neosnippet#enable_snipmate_compatibility = 1
	let g:auto_ctags=1
	"autodate
	nnoremap <F10> 1ggOLast Change: .<CR><Esc>
	let autodate_format = '%Y/%m/%d %H:%M:%S'
	let autodate_lines  = 3
	"easy-align
	nmap ga <Plug>(EasyAlign)
	xmap ga <Plug>(EasyAlign)
	"lightline
	set laststatus=2
	set noshowmode
	if patched_font
		let g:lightline = {
					\ 'colorscheme': 'jellybeans',
					\ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
					\ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" }
					\ }
	else
		let g:lightline = {
					\ 'colorscheme': 'jellybeans'
					\ }
	endif
	"neocomplete
	let g:neocomplete#enable_at_startup = 1
	let g:neocomplete#enable_smart_case = 1
	let g:neocomplete#sources#syntax#min_keyword_length = 3
	let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'
	let g:neocomplete#sources#dictionary#dictionaries = {
				\ 'default' : '',
				\ 'vimshell' : $HOME.'/.vimshell_hist',
				\ 'scheme' : $HOME.'/.gosh_completions'
				\ }
	inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
	set completeopt=menuone
	"syntastic
	let g:syntastic_enable_signs=1
	let g:syntastic_auto_loc_list=2
	let g:syntastic_mode_map = {'mode': 'passive'} 
	" augroup AutoSyntastic
	" 	autocmd!
	" 	autocmd InsertLeave,TextChanged * call s:syntastic() 
	" augroup END
	" function! s:syntastic()
	" 	w
	" 	SyntasticCheck
	" endfunction
	"unite
	" let g:unite_enable_start_insert=0
	" let g:unite_source_history_yank_enable =1
	" let g:unite_source_file_mru_limit = 200
	" nnoremap <silent> <Space>u  :<C-u>Unite
	" nnoremap <silent> <Space>uy :<C-u>Unite history/yank<CR>
	" nnoremap <silent> <Space>ub :<C-u>Unite buffer<CR>
	" nnoremap <silent> <Space>uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
	" nnoremap <silent> <Space>ur :<C-u>Unite -buffer-name=register register<CR>
	" nnoremap <silent> <Space>uu :<C-u>Unite file_mru buffer<CR>
endif


"appearence
syntax on
set t_Co=256
set title
set number ruler
set showcmd
set background=dark
set list listchars=tab:\|-,eol:~
set smartindent autoindent
set tabstop=4 shiftwidth=4 noexpandtab smarttab
set display=lastline
set scrolloff=7
set helpheight=1000
set splitbelow splitright
set showmatch
set matchpairs+=<:>
set cursorline
highlight clear CursorLine
highlight normal ctermbg=none
highlight SpecialKey ctermbg=NONE ctermfg=black
highlight MatchParen ctermfg=darkblue ctermbg=black


"encoding
set encoding=utf-8 fileencodings=utf-8,iso-2022-jp,euc-jp,sjis fileencoding=utf-8
set fileformats=unix,dos,mac fileformat=unix


"files
set noswapfile
set autochdir
set hidden
nnoremap Q  <Nop>
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap <Space>w :<C-u>w<CR>
nnoremap w<Space> :<C-u>w<CR>
nnoremap <Space>W :<C-u>W<CR>
nnoremap W<Space> :<C-u>W<CR>
command! W call s:SU_W()
function! s:SU_W()
	:w !sudo tee %
endfunction
nnoremap <Space>q :<C-u>q<CR>
nnoremap q<Space> :<C-u>q<CR>
nnoremap <Space>Q :<C-u>q!<CR>
nnoremap Q<Space> :<C-u>q!<CR>


"foldings
set foldmethod=syntax foldlevel=100
autocmd InsertEnter * if &l:foldmethod ==# 'syntax'
			\| setlocal foldmethod=manual
			\| endif
autocmd InsertLeave * if &l:foldmethod ==# 'manual'
			\| setlocal foldmethod=syntax
			\| endif
set foldtext=MyFoldText()
function! MyFoldText()
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


"searches
set incsearch hlsearch ignorecase smartcase
set wildignorecase
set wildmode=list:longest,full
nnoremap <Esc><Esc> :<C-u>set nohlsearch<CR>
nnoremap <Space><Space> :<C-u>set nohlsearch<CR>
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


"others
set history=100
set backspace=start,eol,indent
set pumheight=10
set clipboard=unnamed,unnamedplus


"mapping&function
"movements
nnoremap k   gk
nnoremap j   gj
vnoremap k   gk
vnoremap j   gj
nnoremap gk  k
nnoremap gj  j
vnoremap gk  k
vnoremap gj  j
inoremap <C-f> <Right>
inoremap <C-b> <Left>
cnoremap <C-f> <Right>
cnoremap <C-b> <Left>
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l
nnoremap <Space> <NOP>
vnoremap <Space> <NOP>
nnoremap <Space>h ^
nnoremap <Space>l $
vnoremap <Space>h ^
vnoremap <Space>l $
nnoremap <Space>t gt
nnoremap <Space>T gT
nnoremap <Space>b :bprevious<CR>
nnoremap <Space>B :bnext<CR>
nnoremap <expr> gg line(".")==1 ? 'G':'gg'
vnoremap <expr> gg line(".")==1 ? 'G':'gg'

"esc
noremap  <C-@> <Esc>
imap <silent> jj  <Esc>
vnoremap <Tab> <Esc>

"input
inoremap {<CR> {}<Left><CR><ESC>O
inoremap [<CR> []<Left><CR><ESC>O
inoremap (<CR> ()<Left><CR><ESC>O
nnoremap <Space>o  :<C-u>for i in range(v:count1) \| call append(line('.'), '') \| endfor<CR>
nnoremap <Space>O  :<C-u>for i in range(v:count1) \| call append(line('.')-1, '') \| endfor<CR>

"making_changes
nnoremap Y y$
nnoremap <Space>i gg=G<C-o><C-o>
nnoremap <Space>v 0v$h
nnoremap <Space>d 0v$hx
nnoremap <Space>y 0v$hy
vnoremap <Space>p "0p
nnoremap + <C-a>
nnoremap - <C-x>
set gdefault
nnoremap gs :<C-u>%s/
vnoremap gs :s/
nnoremap & :&&<CR>
xnoremap & :&&<CR>

"RUN
command! RUN call s:RUN()
nnoremap <F4> :w<CR>:source %<CR>
inoremap <F4> <Esc>:w<CR>:source %<CR>
vnoremap <F4> <Esc>:w<CR>:source %<CR>
nnoremap <F5> :RUN<CR>
inoremap <F5> <Esc>:RUN<CR>
vnoremap <F5> <Esc>:RUN<CR>
function! s:RUN()
	:w
	let e = expand("%:e")
	if e == "c"
		if filereadable("Makefile")
			:make
		else
			:GCC
		endif
		if filereadable("main")
			:!./main
		else
			:!./.x_%:r
		endif
	elseif e == "java"
		if filereadable("Makefile")
			:make
			:!java Main
		else
			:JAVAC
			:!java %:r
		endif
	elseif e == "rb"
		:!ruby %
	elseif e == "py"
		:!python %
	elseif e == "ml"
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
