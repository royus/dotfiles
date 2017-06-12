"Last Change: 2017/06/12 (Mon) 14:37:03.

set shell=/bin/sh
let patched_font=0
let colorscheme_no=1
let load_plugin=1
let use_ja_input=1

"dein
if version>=704 && load_plugin
	let s:dein_dir=expand('~/.vim')
	let s:dein_repo_dir=s:dein_dir.'/repos/github.com/Shougo/dein.vim'
	if &runtimepath !~# '/dein.vim'
		if !isdirectory(s:dein_repo_dir)
			execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
		endif
		execute 'set runtimepath^='.fnamemodify(s:dein_repo_dir, ':p')
	endif
	call dein#begin(s:dein_dir)
	call dein#add('Shougo/dein.vim')
	"functions
	call dein#add('itchyny/calendar.vim')
	call dein#add('tpope/vim-fugitive')
	call dein#add('thinca/vim-poslist')
	call dein#add('thinca/vim-scouter')
	call dein#add('tyru/skk.vim')
	call dein#add('LeafCage/yankround.vim')
	" call dein#add('scrooloose/syntastic')
	" call dein#add('Shougo/unite.vim')
	" call dein#add('Shougo/unite-outline')
	" call dein#add('ujihisa/unite-colorscheme')
	" call dein#add('Shougo/neomru.vim')
	" call dein#add('Shougo/vimproc')
	"appearence
	call dein#add('w0ng/vim-hybrid')
	call dein#add('vimtaku/hl_matchit.vim')
	call dein#add('itchyny/lightline.vim')
	call dein#add('itchyny/vim-autoft')
	"input
	call dein#add('tpope/vim-abolish')
	call dein#add('vim-scripts/autodate.vim')
	call dein#add('tomtom/tcomment_vim')
	call dein#add('junegunn/vim-easy-align')
	call dein#add('mattn/emmet-vim')
	call dein#add('Shougo/neocomplete.vim')
	call dein#add('Shougo/neosnippet.vim')
	call dein#add('Shougo/neosnippet-snippets')
	"files
	call dein#add('soramugi/auto-ctags.vim')
	call dein#add('majutsushi/tagbar')
	call dein#add('scrooloose/nerdtree')
	"filetype
	call dein#add('dag/vim-fish')
	call dein#add('lervag/vimtex')
	call dein#add('matze/vim-tex-fold')
	call dein#add('vim-scripts/verilog.vim')
	"txtobj
	call dein#add('kana/vim-textobj-user')
	call dein#add('osyo-manga/vim-textobj-blockwise')
	call dein#add('thinca/vim-textobj-comment')
	call dein#add('deris/vim-textobj-enclosedsyntax')
	call dein#add('kana/vim-textobj-fold')
	call dein#add('kana/vim-textobj-function')
	call dein#add('thinca/vim-textobj-function-javascript')
	call dein#add('thinca/vim-textobj-function-perl')
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
	endif
	let g:neosnippet#enable_snipmate_compatibility=1
	"autodate
	nnoremap <F10> OLast Change: .<CR><Esc>
	let autodate_format='%Y/%m/%d (%a) %H:%M:%S'
	let autodate_lines =3
	"auto_ft
	let g:autoft_config = [
				\ { 'filetype': 'html' , 'pattern': '<\%(!DOCTYPE\|html\|head\|script\)' },
				\ { 'filetype': 'c'    , 'pattern': '^\s*#\s*\%(include\|define\)\>' },
				\ { 'filetype': 'diff' , 'pattern': '^diff -' },
				\ { 'filetype': 'sh'   , 'pattern': '^#!.*\%(\<sh\>\|\<bash\>\)\s*$' },
				\ ]
	"calendar
	let g:calendar_frame = 'default'
	nnoremap ,c :Calendar -first_day=monday<CR>
	"easy-align
	nmap ga <Plug>(EasyAlign)
	xmap ga <Plug>(EasyAlign)
	"files&ctags
	nnoremap <F2> :TodoToggle<CR>:wincmd w<CR>:echo<CR>:NERDTreeToggle<CR>:TagbarToggle<CR>:echo<CR>
	nnoremap ,n :NERDTreeToggle<CR>
	let g:auto_ctags=1
	nnoremap ,t :TagbarToggle<CR>
	let g:tagbar_width=25
	"hl_matchit
	let g:hl_matchit_enable_on_vim_startup = 1
	let g:hl_matchit_hl_groupname = 'MatchParen'
	let g:hl_matchit_allow_ft = 'html\|vim\|ruby\|sh'
	runtime macros/matchit.vim
	let b:match_ignorecase=1
	augroup matchit
		autocmd!
		autocmd filetype vim let b:match_words='\<if\>:\<elseif\>:\<else\>:\<endif\>,\<for\>:\<endfor\>,\<function\>:\<endfunction\>'
		autocmd filetype ruby let b:match_words='\<\(module\|class\|def\|begin\|do\|if\|unless\|case\)\>:\<\(elsif\|when\|rescue\)\>:\<\(else\|ensure\)\>:\<end\>'
	augroup END
	"latex
	let g:tex_flavor='latex'
	" autocmd FileType tex setlocal spell spelllang=en_us
	"lightline
	set laststatus=2
	set noshowmode
	if patched_font
		let g:lightline={
					\ 'colorscheme': 'jellybeans',
					\ 'separator': { 'left': "\u2b80", 'right': "\u2b82" },
					\ 'subseparator': { 'left': "\u2b81", 'right': "\u2b83" },
					\ }
	else
		let g:lightline={
					\ 'colorscheme': 'jellybeans',
					\ }
	endif
	let g:lightline.component = {
				\ 'lineinfo': '%3l[%L]:%-2v',
				\ 'skkstatus': '%{strlen(SkkGetModeStr())-1 ? substitute(substitute(SkkGetModeStr(), "[SKK:", "", ""), "]", "", "") : ""}',
				\ }
	let g:lightline.active = {
				\ 'left':  [ [ 'mode', 'paste' ],
				\            [ 'readonly', 'filename', 'modified' ] ],
				\ 'right': [ [ 'lineinfo','winform'],
				\            [ 'percent' ],
				\            [ 'skkstatus', 'fileformat', 'fileencoding', 'filetype' ] ] ,
				\ }
	let g:lightline.inactive = {
				\ 'left': [ [ 'filename' ] ],
				\ 'right': [ [ 'lineinfo' ] ],
				\ }
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
	let g:poslist_hstsize=100
	"skk
	if use_ja_input
		map! <C-j> <Plug>(skk-toggle-im)
		let g:skk_abbrev_to_zenei_key=""
		let g:skk_keep_state=1
		let g:skk_large_jisyo = expand('~/.skk-jisyo')
		" let g:skk_auto_save_jisyo = -1
		let g:eskk#enable_completion = 1
		let g:skk_kutouten_type = "en"
	else
		let g:skk_control_j_key=""
	endif
	"syntastic
	" let g:syntastic_enable_signs=1
	" let g:syntastic_auto_loc_list=2
	" let g:syntastic_mode_map={'mode': 'passive'}
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
	let colorscheme_no=0
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
if version>=730
	set relativenumber
endif
set showcmd
set list listchars=eol:~,tab:\|-
set background=dark
if version>=740
	set breakindent showbreak=+++
endif
set smartindent autoindent
set tabstop=4 shiftwidth=4 noexpandtab smarttab
autocmd filetype vim setl tabstop=2 shiftwidth=2
autocmd filetype tex setl tabstop=2 shiftwidth=2
set display=lastline
set scrolloff=7
set helpheight=1000
set splitbelow splitright
set showmatch
set matchpairs+=<:>
if colorscheme_no==1
	set cursorline cursorcolumn
	highlight clear CursorLine
	highlight clear CursorColumn
	highlight MatchParen ctermfg=cyan ctermbg=NONE
	highlight PmenuSel ctermbg=lightgray
else
	colorscheme darkblue
endif
highlight normal ctermbg=NONE


"encoding
set encoding=utf-8 fileencodings=utf-8,iso-2022-jp,euc-jp,sjis fileencoding=utf-8
set fileformat=unix fileformats=unix,dos,mac


"files
set noswapfile
set autochdir
set hidden
nnoremap Q     <NOP>
nnoremap ZZ    <NOP>
nnoremap ZQ    <NOP>
nnoremap <C-z> <NOP>
nnoremap <Space>w :<C-u>w<CR>
nnoremap <Space>W :<C-u>W<CR>
command! W call s:Su_Write()
function! s:Su_Write()
	:w !sudo tee %
endfunction
nnoremap <Space>q :<C-u>q<CR>
nnoremap q<Space> :<C-u>q<CR>
nnoremap <Space>Q :<C-u>qa!<CR>
nnoremap Q<Space> :<C-u>qa!<CR>


"foldings
nnoremap z za
" nnoremap za <NOP>
set foldmethod=syntax foldlevel=100
" set foldmethod=indent foldlevel=100
autocmd InsertEnter * if &l:foldmethod ==# 'syntax'
			\| setlocal foldmethod=manual
			\| endif
autocmd InsertLeave * if &l:foldmethod ==# 'manual'
			\| setlocal foldmethod=syntax
			\| endif
let javaScript_fold=1
let perl_fold=1
let php_folding=1
let r_syntax_folding=1
let ruby_fold=1
let sh_fold_enabled=1
let vimsyn_folding='af'
let xml_syntax_folding=1
set foldtext=MyFoldText()
function! MyFoldText()
	let line=getline(v:foldstart)
	let space=strpart('|---------------',0,&tabstop)
	" let space=substitute(space,'\%( \)\@<= \%( *$\)\@=',' ','g')
	let line=substitute(line,"\t",space,'g')
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
set incsearch wrapscan ignorecase smartcase
if version>=704
	set wildignorecase
endif
set wildmode=list:longest,full
set wildignore=*.o,*.obj,*.pyc,*.class,*.out
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
set virtualedit=block
autocmd BufReadPost *
			\ if line("'\"") > 0 && line ("'\"") <= line("$") |
			\   exe "normal! g'\"" |
			\ endif


"mapping&function
"unused:
"<F3><F4><F6><F7><F8><F9>^
"<Space> + abcefgmnruxz
"   ,    + abdefghijklmopqrsuvwxyz
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
nnoremap <Tab> <C-w><C-w>
vnoremap <Tab> <C-w><C-w>
" nnoremap <C-j> <C-w>j
" nnoremap <C-k> <C-w>k
" nnoremap <C-h> <C-w>h
" nnoremap <C-l> <C-w>l
nnoremap <Space> <NOP>
vnoremap <Space> <NOP>
nnoremap <Space>h g^
nnoremap <Space>l g$
nnoremap <Space>k <C-u>
nnoremap <Space>j <C-d>
vnoremap <Space>h g^
vnoremap <Space>l g$
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
nnoremap ; :
nnoremap : ;
nnoremap <Space>o  :<C-u>for i in range(v:count1) \| call append(line('.'), '') \| endfor<CR>
nnoremap <Space>O  :<C-u>for i in range(v:count1) \| call append(line('.')-1, '') \| endfor<CR>
nnoremap Y y$
nnoremap <Space>i gg=G<C-o><C-o>
nnoremap <Space>v ^v$h
nnoremap <Space>d ^v$hx
nnoremap <Space>y ^v$hy
vnoremap <Space>p "0p
nnoremap <C-g> g<C-g>
nnoremap + <C-a>
nnoremap - <C-x>
vnoremap + <C-a>
vnoremap - <C-x>
function! s:remove_dust()
	let cursor=getpos(".")
	%s/\s\+$//ge
	call setpos(".", cursor)
	unlet cursor
endfunction
autocmd BufWritePre * call <SID>remove_dust()
nnoremap U <C-r>
nnoremap <C-j> J

"input
" inoremap { {}<Left>
" inoremap { <Space>{
" inoremap } }<Space>
" inoremap [ []<Left>
" inoremap [ <Space>[
" inoremap ] ]<Space>
" inoremap ( ()<Left>
" inoremap ( <Space>(
" inoremap ) )<Space>
" inoremap {<CR> <Space>{}<Left><CR><Esc>O
" inoremap [<CR> <Space>[]<Left><CR><Esc>O
" inoremap (<CR> <Space>()<Left><CR><Esc>O
inoremap {<CR> {}<Left><CR><Esc>O
inoremap [<CR> []<Left><CR><Esc>O
inoremap (<CR> ()<Left><CR><Esc>O
vnoremap { "zdi<C-v>{<C-R>z}<Esc>
vnoremap } "zdi<C-v>{<C-R>z}<Esc>
vnoremap [ "zdi<C-v>[<C-R>z]<Esc>
vnoremap ] "zdi<C-v>[<C-R>z]<Esc>
vnoremap ( "zdi<C-v>(<C-R>z)<Esc>
vnoremap ) "zdi<C-v>(<C-R>z)<Esc>
vnoremap " "zdi<C-v>"<C-R>z<C-v>"<Esc>
vnoremap ' "zdi'<C-R>z'<Esc>
inoremap zl ->
inoremap zh <-
inoremap <C-j> <CR>

"text
autocmd filetype text inoremap .   .<Space>
autocmd filetype text inoremap .a  .<Space>A
autocmd filetype text inoremap .b  .<Space>B
autocmd filetype text inoremap .c  .<Space>C
autocmd filetype text inoremap .d  .<Space>D
autocmd filetype text inoremap .e  .<Space>E
autocmd filetype text inoremap .f  .<Space>F
autocmd filetype text inoremap .g  .<Space>G
autocmd filetype text inoremap .h  .<Space>H
autocmd filetype text inoremap .i  .<Space>I
autocmd filetype text inoremap .j  .<Space>J
autocmd filetype text inoremap .k  .<Space>K
autocmd filetype text inoremap .l  .<Space>L
autocmd filetype text inoremap .m  .<Space>M
autocmd filetype text inoremap .n  .<Space>N
autocmd filetype text inoremap .o  .<Space>O
autocmd filetype text inoremap .p  .<Space>P
autocmd filetype text inoremap .q  .<Space>Q
autocmd filetype text inoremap .r  .<Space>R
autocmd filetype text inoremap .s  .<Space>S
autocmd filetype text inoremap .t  .<Space>T
autocmd filetype text inoremap .u  .<Space>U
autocmd filetype text inoremap .v  .<Space>V
autocmd filetype text inoremap .w  .<Space>W
autocmd filetype text inoremap .x  .<Space>X
autocmd filetype text inoremap .y  .<Space>Y
autocmd filetype text inoremap .z  .<Space>Z
autocmd filetype tex inoremap figure \begin{figure}[t]<CR>\centering<CR>%<Space>\includegraphics[width=8cm,clip]{./pdf/xxx.pdf}<CR>\caption{．\label{xxx}}<CR>\end{figure}
autocmd filetype tex inoremap table \begin{table}[t]<CR>\centering<CR>\caption{．\label{xxx}}<CR>\begin{tabular}{\|c\|\|c\|c\|}<Space>\hline<CR>a<Space>&<Space>b<Space>&<Space>c<Space>\\<Space>\hline<Space>\hline<CR>\end{tabular}<CR>\end{table}

"todo
nnoremap T :VTodoToggle<CR>
command! TodoToggle call s:TodoToggle()
function! s:TodoToggle()
	let todowinnr = bufwinnr(".todo")
	if todowinnr != -1
		exe todowinnr."wincmd w"
		" exe "normal \<C-w>".todowinnr."w"
		write
		bdelete
		return
	endif
	if filereadable(".todo")
		10 split .todo
	else
		10 split ~/.todo
	endif
endfunction
command! VTodoToggle call s:VTodoToggle()
function! s:VTodoToggle()
	let todowinnr = bufwinnr(".todo")
	if todowinnr != -1
		exe todowinnr."wincmd w"
		" exe "normal \<C-w>".todowinnr."w"
		write
		bdelete
		return
	endif
	if filereadable(".todo")
		44 vsplit .todo
	else
		44 vsplit ~/.todo
	endif
endfunction
inoremap tl - [ ]<Space>
inoremap tL tl
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
autocmd bufnew,bufenter .todo syntax match CheckboxMark /.*\-\s\[x\]\s.\+/ display containedin=ALL
highlight CheckboxMark ctermfg=darkgreen
autocmd bufnew,bufenter * syntax match CheckboxUnmark /.*\-\s\[\s\]\s.\+/ display containedin=ALL
highlight CheckboxUnmark ctermfg=red

"RUN
command! RUN call s:RUN()
nnoremap <F5> :RUN<CR>
inoremap <F5> <Esc><Esc>:RUN<CR>
vnoremap <F5> <Esc>:RUN<CR>
function! s:RUN()
	wall
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
			" !rm .x_%:r
		endif
	elseif e=="java"
		if filereadable("Makefile")
			make; !java Main
		else
			JAVAC
			!java %:r
		endif
	elseif e=="rb"
		!ruby % -w
	elseif e=="py"
		if bufwinnr("main.py")!=-1
			!python3 -B main.py
		else
			!python3 -B %
		endif
	elseif e=="ml"
		!ocaml -init %
	elseif e=="tex"
		!latexmk % ; latexmk % -c; rm platex*.fls
		" !latexmk % -pv; latexmk % -c; rm platex*.fls
	elseif e=="pml"
		!spin %
	endif
endfunction
command! GCC call s:GCC()
function! s:GCC()
	write
	!gcc % -O3 -lm -o .x_%:r -Wall;
endfunction
command! JAVAC call s:JAVAC()
function! s:JAVAC()
	write
	!javac %
endfunction
autocmd filetype vim nnoremap <F5> :w<CR>:source %<CR>
autocmd filetype vim inoremap <F5> <Esc>:w<CR>:source %<CR>
autocmd filetype vim vnoremap <F5> <Esc>:w<CR>:source %<CR>

"template
autocmd BufNewFile,BufRead *.c    if getfsize(@%)<=0 | 0read ~/dotfiles/template/template.c    | %substitute/filename/\=expand('%:r')/g | endif
autocmd BufNewFile,BufRead *.java if getfsize(@%)<=0 | 0read ~/dotfiles/template/template.java | %substitute/filename/\=expand('%:r')/g | endif
autocmd BufNewFile,BufRead *.sh   if getfsize(@%)<=0 | 0read ~/dotfiles/template/template.sh   | %substitute/filename/\=expand('%:r')/g | endif
autocmd BufNewFile,BufRead *.tex  if getfsize(@%)<=0 | 0read ~/dotfiles/template/template.tex  | %substitute/filename/\=expand('%:r')/g | endif
