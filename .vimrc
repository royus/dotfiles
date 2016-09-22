"Last Change: 2016/09/22 (Thu) 16:02:46.

set shell=/bin/sh
let patched_font=1
let colorscheme_no=1

"dein
let s:dein_dir=expand('~/vim')
let s:dein_repo_dir=s:dein_dir.'/repos/github.com/Shougo/dein.vim'
if &runtimepath !~# '/dein.vim'
	if !isdirectory(s:dein_repo_dir)
		execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
	endif
	execute 'set runtimepath^='.fnamemodify(s:dein_repo_dir, ':p')
endif
if isdirectory(s:dein_repo_dir)
	call dein#begin(s:dein_dir)
	call dein#add('Shougo/dein.vim')
	"functions
	call dein#add('itchyny/calendar.vim')
	call dein#add('tpope/vim-fugitive')
	call dein#add('thinca/vim-poslist')
	call dein#add('thinca/vim-scouter')
	call dein#add('scrooloose/syntastic')
	call dein#add('yuratomo/w3m.vim')
	call dein#add('LeafCage/yankround.vim')
	" call dein#add('Shougo/unite.vim')
	" call dein#add('Shougo/unite-outline')
	" call dein#add('ujihisa/unite-colorscheme')
	" call dein#add('Shougo/neomru.vim')
	" call dein#add('Shougo/vimproc')
	"appearence
	call dein#add('w0ng/vim-hybrid')
	call dein#add('vimtaku/hl_matchit.vim')
	call dein#add('itchyny/lightline.vim')
	"input
	call dein#add('tpope/vim-abolish')
	call dein#add('vim-scripts/autodate.vim')
	call dein#add('tomtom/tcomment_vim')
	call dein#add('junegunn/vim-easy-align')
	call dein#add('mattn/emmet-vim')
	call dein#add('kana/vim-smartchr')
	call dein#add('Shougo/neocomplete.vim')
	call dein#add('Shougo/neosnippet.vim')
	call dein#add('Shougo/neosnippet-snippets')
	"files
	call dein#add('soramugi/auto-ctags.vim')
	call dein#add('majutsushi/tagbar')
	call dein#add('scrooloose/nerdtree')
	"txtobj
	call dein#add('kana/vim-textobj-user')
	call dein#add('osyo-manga/vim-textobj-blockwise')
	call dein#add('thinca/vim-textobj-comment')
	call dein#add('deris/vim-textobj-enclosedsyntax')
	call dein#add('kana/vim-textobj-fold')
	call dein#add('kana/vim-textobj-function')
	call dein#add('thinca/vim-textobj-function-javascript')
	call dein#add('thinca/vim-textobj-function-perl')
	call dein#add('mjbrownie/html-textobjects')
	call dein#add('kana/vim-textobj-indent')
	call dein#add('rhysd/vim-textobj-ruby')
	call dein#add('kana/vim-textobj-underscore')
	call dein#add('mattn/vim-textobj-url')
	"end
	call dein#end()
	filetype plugin indent on
	if dein#check_install()
		call dein#install()
	endif

	"plugins
	if colorscheme_no==1
		colorscheme hybrid
		highlight SpecialKey ctermbg=NONE ctermfg=black
		highlight MatchParen ctermfg=darkblue ctermbg=NONE
		highlight Title ctermfg=cyan ctermbg=NONE
	endif
	let g:neosnippet#enable_snipmate_compatibility=1
	"autodate
	nnoremap <F10> 1ggOLast Change: .<CR><Esc>
	let autodate_format='%Y/%m/%d (%a) %H:%M:%S'
	let autodate_lines =3
	"calendar
	let g:calendar_frame = 'default'
	nnoremap ,c :Calendar -first_day=monday<CR>
	"easy-align
	nmap ga <Plug>(EasyAlign)
	xmap ga <Plug>(EasyAlign)
	"files&ctags
	nnoremap <F2> :NERDTreeToggle<CR>:TagbarToggle<CR>:echo<CR>
	nnoremap ,n :NERDTreeToggle<CR>
	let g:auto_ctags=1
	nnoremap ,t :TagbarToggle<CR>
	let g:tagbar_width=25
	"hl_matchit
	let g:hl_matchit_enable_on_vim_startup = 1
	let g:hl_matchit_hl_groupname = 'Title'
	let g:hl_matchit_allow_ft = 'html\|vim\|ruby\|sh'
	runtime macros/matchit.vim
	let b:match_ignorecase=1
	augroup matchit
		autocmd!
		autocmd filetype vim let b:match_words='\<if\>:\<elseif\>:\<else\>:\<endif\>,\<for\>:\<endfor\>,\<function\>:\<endfunction\>'
		autocmd filetype ruby let b:match_words='\<\(module\|class\|def\|begin\|do\|if\|unless\|case\)\>:\<\(elsif\|when\|rescue\)\>:\<\(else\|ensure\)\>:\<end\>'
	augroup END
	"lightline
	set laststatus=2
	set noshowmode
	if patched_font
		let g:lightline={
					\ 'colorscheme': 'jellybeans',
					\ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
					\ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" }
					\ }
	else
		let g:lightline={
					\ 'colorscheme': 'jellybeans'
					\ }
	endif
	"neocomplete
	let g:neocomplete#enable_at_startup=1
	let g:neocomplete#enable_smart_case=1
	let g:neocomplete#sources#syntax#min_keyword_length=3
	let g:neocomplete#lock_buffer_name_pattern='\*ku\*'
	let g:neocomplete#sources#dictionary#dictionaries={
				\ 'default' : '',
				\ 'vimshell' : $HOME.'/.vimshell_hist',
				\ 'scheme' : $HOME.'/.gosh_completions'
				\ }
	inoremap <expr><Tab>  pumvisible() ? "\<C-n>" : "\<Tab>"
	set completeopt=menuone
	"poslist
	nmap <C-o> <Plug>(poslist-prev-pos)
	nmap <C-i> <Plug>(poslist-next-pos)
	let g:poslist_hstsize=10000
	"smartchr
	autocmd filetype c,java inoremap <expr> = smartchr#loop(' = ', ' == ', "=")
	autocmd filetype c,java inoremap <expr> + smartchr#loop(' + ', '++ ', '+')
	autocmd filetype c,java inoremap <expr> - smartchr#loop(' - ', '-- ', '-')
	autocmd filetype c,java inoremap <expr> / smartchr#loop(' / ', '// ', '/')
	autocmd filetype c,java inoremap <expr> * smartchr#loop(' * ', ' ** ', '*')
	autocmd filetype c,java inoremap <expr> , smartchr#loop(', ', ',')
	autocmd filetype txt inoremap <expr> . smartchr#loop('. ', '.', '...')
	"syntastic
	let g:syntastic_enable_signs=1
	let g:syntastic_auto_loc_list=2
	let g:syntastic_mode_map={'mode': 'passive'}
	" augroup AutoSyntastic
	"   autocmd!
	"   autocmd InsertLeave,TextChanged * call s:syntastic()
	" augroup END
	" function! s:syntastic()
	"   w
	"   SyntasticCheck
	" endfunction
	"unite
	" let g:unite_enable_start_insert=0
	" let g:unite_source_history_yank_enable =1
	" let g:unite_source_file_mru_limit=200
	" nnoremap <silent> <Space>u  :<C-u>Unite
	" nnoremap <silent> <Space>uy :<C-u>Unite history/yank<CR>
	" nnoremap <silent> <Space>ub :<C-u>Unite buffer<CR>
	" nnoremap <silent> <Space>uf :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
	" nnoremap <silent> <Space>ur :<C-u>Unite -buffer-name=register register<CR>
	" nnoremap <silent> <Space>uu :<C-u>Unite file_mru buffer<CR>
	"w3m
	nnoremap ,w :W3mTab<Space>google
	nnoremap ,h :W3mHistory<CR>
	let g:w3m#history#save_file=s:dein_dir.'/repos/github.com/yuratomo/w3m.vim/.vim_w3m_hist'
	"yankround
	nmap p <Plug>(yankround-p)
	xmap p <Plug>(yankround-p)
	nmap P <Plug>(yankround-P)
	nmap <C-p> <Plug>(yankround-prev)
	nmap <C-n> <Plug>(yankround-next)
	let g:yankround_max_history=20
	"abolish
	nnoremap <Space>s :<C-u>%Subvert/
	vnoremap <Space>s :Subvert/
else
	"abolish
	set gdefault
	nnoremap <Space>s :<C-u>%s/
	vnoremap <Space>s :s/
endif


"appearence
set t_Co=256
syntax enable
set title
set number ruler
set showcmd
set background=dark
set list listchars=tab:\|-,eol:~
set smartindent autoindent
set tabstop=4 shiftwidth=4 noexpandtab smarttab
autocmd filetype vim set tabstop=2 shiftwidth=2
set display=lastline
set scrolloff=7
set helpheight=1000
set splitbelow splitright
set showmatch
set matchpairs+=<:>
set cursorline
highlight clear CursorLine
highlight normal ctermbg=NONE


"encoding
set encoding=utf-8 fileencodings=utf-8,iso-2022-jp,euc-jp,sjis fileencoding=utf-8
set fileformats=unix,dos,mac fileformat=unix


"files
set noswapfile
set autochdir
set hidden
nnoremap Q  <NOP>
nnoremap ZZ <NOP>
nnoremap ZQ <NOP>
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
	let cnt=printf(' [%3s,%2s]',(v:foldend-v:foldstart+1),v:foldlevel)
	let line_width=winwidth(0)-&foldcolumn
	if &number==1
		let line_width -= max([&numberwidth, len(line('$'))])
	endif
	let alignment=line_width - len(cnt)
	let line=strpart(printf('%-'.alignment.'s',line),0,alignment)
	let line=substitute(line,'\%( \)\@<= \%( *$\)\@=','-','g')
	return line.cnt
endfunction


"history
set history=100
nnoremap q: <NOP>
nnoremap <Space>: q:
nnoremap q/ <NOP>
nnoremap <Space>/ q/
vnoremap q: <NOP>
vnoremap <Space>: q:
vnoremap q/ <NOP>
vnoremap <Space>/ q/


"searches
set incsearch ignorecase smartcase
set wildignorecase
set wildmode=list:longest,full
nnoremap <Esc><Esc> :<C-u>set nohlsearch<CR>
nnoremap <Space><Space> :<C-u>set nohlsearch<CR>
nnoremap / :<C-u>set hlsearch<CR>/
nnoremap ? :<C-u>set hlsearch<CR>?
nnoremap * :<C-u>set hlsearch<CR>*N:echo<CR>
nnoremap # :<C-u>set hlsearch<CR>#N:echo<CR>
nnoremap <expr> n <SID>search_forward_p() ? ':<C-u>set hlsearch<CR>nzv' : ':<C-u>set hlsearch<CR>Nzv'
nnoremap <expr> N <SID>search_forward_p() ? ':<C-u>set hlsearch<CR>Nzv' : ':<C-u>set hlsearch<CR>nzv'
vnoremap <expr> n <SID>search_forward_p() ? ':<C-u>set hlsearch<CR>nzv' : ':<C-u>set hlsearch<CR>Nzv'
vnoremap <expr> N <SID>search_forward_p() ? ':<C-u>set hlsearch<CR>Nzv' : ':<C-u>set hlsearch<CR>nzv'
function! s:search_forward_p()
	return exists('v:searchforward') ? v:searchforward : 1
endfunction


"others
set backspace=start,eol,indent
set pumheight=10
set clipboard=unnamed,unnamedplus
set ambiwidth=double
autocmd BufReadPost *
			\ if line("'\"") > 0 && line ("'\"") <= line("$") |
			\   exe "normal! g'\"" |
			\ endif


"mapping&function
"unused:
"<F3><F4><F6><F7><F8><F9>^
"<Space> + abcefgmnruxz
"   ,    + abdefgijklmopqrsuvxyz
set timeout timeoutlen=3000 ttimeoutlen=100
"movements
nnoremap <Up>    <NOP>
nnoremap <Down>  <NOP>
nnoremap <Right> <NOP>
nnoremap <Left>  <NOP>
inoremap <Up>    <NOP>
inoremap <Down>  <NOP>
inoremap <Right> <NOP>
inoremap <Left>  <NOP>
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
nnoremap <Space>k <C-u>
nnoremap <Space>j <C-d>
vnoremap <Space>h ^
vnoremap <Space>l $
nnoremap <Space>k <C-u>
nnoremap <Space>j <C-d>
nnoremap <silent> <Space>t :$tabnew<Space>
nnoremap K gt
nnoremap J gT
nnoremap H <C-o>
nnoremap L <C-i>
nnoremap <expr> gg line(".")==1 ? 'G':'gg'
vnoremap <expr> gg line(".")==1 ? 'G':'gg'
nnoremap 0 ^
vnoremap 0 ^

"actions
nnoremap <Space>o  :<C-u>for i in range(v:count1) \| call append(line('.'), '') \| endfor<CR>
nnoremap <Space>O  :<C-u>for i in range(v:count1) \| call append(line('.')-1, '') \| endfor<CR>
nnoremap Y y$
nnoremap <Space>i gg=G<C-o><C-o>
nnoremap <Space>v 0v$h
nnoremap <Space>d 0v$hx
nnoremap <Space>y 0v$hy
vnoremap <Space>p "0p
nnoremap + <C-a>
nnoremap - <C-x>
function! s:remove_dust()
	let cursor=getpos(".")
	%s/\s\+$//ge
	call setpos(".", cursor)
	unlet cursor
endfunction
autocmd BufWritePre * call <SID>remove_dust()
nnoremap U <C-r>

"esc
noremap  <C-@> <Esc>
inoremap <silent> jj  <Esc>
vnoremap <Tab> <Esc>

"input
inoremap { <Space>{
inoremap [ <Space>[
inoremap ( <Space>(
inoremap {<CR> <Space>{}<Left><CR><ESC>O
inoremap [<CR> <Space>[]<Left><CR><ESC>O
inoremap (<CR> <Space>()<Left><CR><ESC>O
vnoremap { "zdi<C-v>{<C-R>z}<ESC>
vnoremap } "zdi<C-v>{<C-R>z}<ESC>
vnoremap [ "zdi<C-v>[<C-R>z]<ESC>
vnoremap ] "zdi<C-v>[<C-R>z]<ESC>
vnoremap ( "zdi<C-v>(<C-R>z)<ESC>
vnoremap ) "zdi<C-v>(<C-R>z)<ESC>
vnoremap " "zdi<C-v>"<C-R>z<C-v>"<ESC>
vnoremap ' "zdi'<C-R>z'<ESC>

"todo
nnoremap T :TodoToggle<CR>
command! TodoToggle edit .todo
inoremap tl - [ ]<Space>
nnoremap <Enter> :call ToggleCheckbox()<CR>
vnoremap <Enter> :call ToggleCheckbox()<CR>
function! ToggleCheckbox()
	let l:line = getline('.')
	if l:line =~ '\-\s\[\s\]'
		let l:result = substitute(l:line, '-\s\[\s\]', '- [x]', '') . ' [' . strftime("%Y/%m/%d (%a) %H:%M:%S") . ']'
		call setline('.', l:result)
	elseif l:line =~ '\-\s\[x\]'
		let l:result = substitute(substitute(l:line, '-\s\[x\]', '- [ ]', ''), '\s\[\d\{4}.\+]$', '', '')
		call setline('.', l:result)
	endif
endfunction
autocmd bufnew,bufenter * syntax match CheckboxMark /.*\-\s\[x\]\s.\+/ display containedin=ALL
highlight CheckboxMark ctermfg=darkgreen
autocmd bufnew,bufenter * syntax match CheckboxUnmark /.*\-\s\[\s\]\s.\+/ display containedin=ALL
highlight CheckboxUnmark ctermfg=darkred

"RUN
command! RUN call s:RUN()
nnoremap <F5> :RUN<CR>
inoremap <F5> <Esc>:RUN<CR>
vnoremap <F5> <Esc>:RUN<CR>
function! s:RUN()
	w
	let e=expand("%:e")
	if e=="c"
		if filereadable("Makefile")
			make
		else
			GCC
		endif
		if filereadable("main")
			!./main
		else
			!./.x_%:r
		endif
	elseif e=="java"
		if filereadable("Makefile")
			make
			!java Main
		else
			JAVAC
			!java %:r
		endif
	elseif e=="rb"
		!ruby % -w
	elseif e=="py"
		!python %
	elseif e=="ml"
		!ocaml -init %
	endif
endfunction
command! GCC call s:GCC()
function! s:GCC()
	w
	!gcc % -O3 -lm -lGL -lGLU -lglut -o .x_%:r -Wall
endfunction
command! JAVAC call s:JAVAC()
function! s:JAVAC()
	w
	!javac %
endfunction
autocmd filetype vim nnoremap <F5> :w<CR>:source %<CR>
autocmd filetype vim inoremap <F5> <Esc>:w<CR>:source %<CR>
autocmd filetype vim vnoremap <F5> <Esc>:w<CR>:source %<CR>
