" Last Change: 2022/07/27 (Wed) 15:23:09.
" Requires version 8.2 for best results

"variables{{{
set shell=/bin/sh
let s:dotfiles_dir = expand('<sfile>:p:h')
let g:patched_font=1
let g:colorscheme_no=1
let g:load_plugin=1
"}}}

"dein{{{
if version>=800 && g:load_plugin
	let s:dein_dir=expand('~/.vim')
	let s:dein_repo_dir=s:dein_dir.'/repos/github.com/Shougo/dein.vim'
	if &runtimepath !~# '/dein.vim'
		if !isdirectory(s:dein_repo_dir)
			execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
		endif
		execute 'set runtimepath^='.fnamemodify(s:dein_repo_dir, ':p')
	endif
	call dein#begin(s:dein_dir)
	call dein#add('Shougo/dein.vim') "plugin manager
	"functions
	call dein#add('itchyny/calendar.vim') " calendar
	call dein#add('tpope/vim-fugitive') " git
	call dein#add('thinca/vim-poslist') " H/L = go back/forth precisely
	call dein#add('thinca/vim-scouter') " :Scouter = power of vimrc
	call dein#add('LeafCage/yankround.vim') " paste older yanks
	"appearence
	call dein#add('w0ng/vim-hybrid') " colorscheme
	call dein#add('vimtaku/hl_matchit.vim') " show matching parenthesis
	call dein#add('itchyny/lightline.vim') " status line @ bottom
	call dein#add('cocopon/lightline-hybrid.vim') " hybrid theme for lightline

	call dein#add('itchyny/vim-autoft') " determine filetype automatically
	"input
	call dein#add('tpope/vim-abolish') " better substituter/searcher
	call dein#add('vim-scripts/autodate.vim') " update date @ top automatically
	call dein#add('cohama/lexima.vim') " auto close parenthesis
	call dein#add('tomtom/tcomment_vim') " gcc = comment out
	call dein#add('junegunn/vim-easy-align') " VXga*Y = align X with Y
	call dein#add('mattn/emmet-vim') " for HTMLs
	"files
	call dein#add('soramugi/auto-ctags.vim') " automatically generate tags
	call dein#add('majutsushi/tagbar') " show tagbar
	call dein#add('scrooloose/nerdtree') " show nerdtree
	"filetype
	call dein#add('dag/vim-fish') " fish
	call dein#add('lervag/vimtex') " tex
	call dein#add('matze/vim-tex-fold') " tex foldings
	call dein#add('vim-scripts/verilog.vim') " verilog
	call dein#add('stephpy/vim-yaml') " yaml
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
	"}}}
	"plugins{{{
	let g:neosnippet#enable_snipmate_compatibility=1
	"autodate
	nnoremap <F10> OLast Change: .<Esc>
	let autodate_format="%Y/%m/%d (%a) %H:%M:%S"
	let autodate_lines=3
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
	"comment
	if !exists('g:tcomment_types')
		let g:tcomment_types = {}
	endif
	let g:tcomment_types = {
				\'php_surround' : "<?php %s ?>",
				\'eruby_surround' : "<%% %s %%>",
				\'eruby_surround_minus' : "<%% %s -%%>",
				\'eruby_surround_equality' : "<%%= %s %%>",
				\'basic' : "' %s",
				\}
	"easy-align
	nmap ga <Plug>(EasyAlign)
	xmap ga <Plug>(EasyAlign)
	"files&ctags
	nnoremap <F2> :TodoToggle<CR>:wincmd w<CR>:echo<CR>:NERDTreeToggle<CR>:TagbarToggle<CR>:echo<CR>
	nnoremap ,n :NERDTreeToggle<CR>
	autocmd StdinReadPre * let s:std_in = 1
	if argc() == 0 || argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in")
		autocmd vimenter * NERDTree
	else
		autocmd vimenter * NERDTree | wincmd p
	endif
	autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
	let g:auto_ctags=0
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
	let g:vimtex_compiler_latexmk = {'callback' : 0}
	call lexima#add_rule({'char': '$', 'input_after': '$', 'filetype': 'tex'})
	call lexima#add_rule({'char': '$', 'at': '\%#\$', 'leave': 1, 'filetype': 'tex'})
	call lexima#add_rule({'char': '<BS>', 'at': '\$\%#\$', 'delete': 1, 'filetype': 'tex'})
	"lightline
	set laststatus=2
	set noshowmode
	if g:patched_font && version>=802
		let g:lightline={
					\ 'colorscheme': 'jellybeans',
					\ 'separator': { 'left': "\ue0b0", 'right': "\ue0b2"  },
					\ 'subseparator': { 'left': "\ue0b1", 'right': "\ue0b3"  }
					\ }
		call setcellwidths([[0xe0b0,0xe0b3,1]])
	else
		let g:lightline={
					\ 'colorscheme': 'jellybeans',
					\ }
	endif
	let g:lightline.component = {
				\ 'lineinfo': '%4l [%L]:%-3v',
				\ }
	let g:lightline.active = {
				\ 'left':  [ [ 'mode', 'paste' ],
				\            [ 'readonly', 'filename', 'modified', 'method'] ],
				\ 'right': [ [ 'lineinfo','winform'],
				\            [ 'percent' ],
				\            [ 'fileformat', 'fileencoding', 'filetype' ] ] ,
				\ }
	let g:lightline.inactive = {
				\ 'right': [ [ 'lineinfo' ] ],
				\ 'left': [ [ 'filename' ] ],
				\ }
	"completion
	inoremap <expr><Tab>  pumvisible() ? "\<C-n>" : "\<Tab>"
	set completeopt=menuone
	"poslist
	nmap H <Plug>(poslist-prev-pos)
	nmap L <Plug>(poslist-next-pos)
	let g:poslist_hstsize=100
	"yankround
	nmap p <Plug>(yankround-p)
	xmap p <Plug>(yankround-p)
	nmap P <Plug>(yankround-P)
	nmap <C-p> <Plug>(yankround-prev)
	nmap <C-n> <Plug>(yankround-next)
	let g:yankround_max_history=5
	"abolish
	nnoremap / :S/
	nnoremap [Space]s :<C-u>%Subvert/
	vnoremap [Space]s :Subvert/
else
	let g:colorscheme_no=0
	"abolish
	set gdefault
	nnoremap [Space]s :<C-u>%s/
	vnoremap [Space]s :s/
	nnoremap <F2> :TodoToggle<CR>
endif
"}}}

"appearence{{{
set t_Co=256
syntax enable
set title
set number ruler
if version>=704
	set relativenumber
endif
set showcmd
set list listchars=eol:~,tab:\|_
set background=dark
if version>=800
	set breakindent showbreak=+++
endif
set smartindent autoindent
set tabstop=4 shiftwidth=4 shiftround noexpandtab smarttab
autocmd filetype tex,text,vim,yaml setlocal tabstop=2 shiftwidth=2
autocmd filetype markdown,php setlocal expandtab tabstop=4 softtabstop=4 shiftwidth=4
autocmd filetype css,html,javascript,json,typescript setlocal expandtab tabstop=2 softtabstop=2 shiftwidth=2
set display=lastline
set scrolloff=7
set helpheight=1000
set splitbelow splitright
set showmatch
set matchpairs+=<:>
if g:colorscheme_no==1
	colorscheme hybrid
	autocmd CursorMoved,CursorMovedI,WinLeave * setlocal nocursorline
	autocmd CursorHold,CursorHoldI * setlocal cursorline
	highlight MatchParen ctermfg=cyan ctermbg=NONE
	highlight PmenuSel ctermbg=lightgray ctermfg=black
	highlight LineNr ctermbg=NONE ctermfg=darkgray
else
	colorscheme darkblue
endif
highlight normal ctermbg=NONE
"}}}

"encoding{{{
set encoding=utf-8 fileencodings=utf-8,iso-2022-jp,euc-jp,sjis fileencoding=utf-8
set fileformat=unix fileformats=unix,dos,mac
"}}}

"files{{{
set noswapfile
set nobackup nowritebackup
set autochdir
set hidden
nnoremap Q     <NOP>
nnoremap <C-z> <NOP>
nnoremap [Space]w :<C-u>w<CR>
nnoremap [Space]W :<C-u>W<CR>
command! W call s:Su_Write()
function! s:Su_Write()
	:w !sudo tee %
endfunction
nnoremap [Space]q :<C-u>q<CR>
nnoremap q<Space> :<C-u>q<CR>
nnoremap [Space]Q :<C-u>qa!<CR>
nnoremap Q<Space> :<C-u>qa!<CR>
"}}}

"foldings {{{
nnoremap z za
nnoremap Z zR
vnoremap z zf
autocmd filetype vim set foldmethod=marker
autocmd filetype tex set foldmethod=marker
set foldtext=MyFoldText()
function! MyFoldText()
	let line=getline(v:foldstart)
	let space=strpart('|---------------',0,&tabstop)
	let line=substitute(line,"\t",space,'g')
	let line=substitute(line,'/\*\|\*/\|{{{\d\=','','g') "}}}
	let cnt=printf(' [%2s,%3s]',v:foldlevel,(v:foldend-v:foldstart+1))
	let line_width=winwidth(0)-&foldcolumn
	if &number==1
		let line_width -= max([&numberwidth, len(line('$'))])
	endif
	let alignment=line_width - len(cnt)
	let line=strpart(printf('%-'.alignment.'s',line),0,alignment)
	let line=substitute(line,'\%( \)\@<= \%( *$\)\@=','-','g')
	return line.cnt
endfunction
"}}}

"history{{{
set history=100
noremap q: <NOP>
noremap [Space]; q:
noremap q/ <NOP>
noremap [Space]/ q/
"}}}

"searches{{{
set incsearch wrapscan ignorecase smartcase
if version>=704
	set wildignorecase
endif
set wildmode=list:longest,full
set wildignore=*.o,*.obj,tags*,*.pyc,*.class,*.out
nnoremap <Esc><Esc> :<C-u>set nohlsearch<CR>
nnoremap / :<C-u>set hlsearch<CR>/
nnoremap ? :<C-u>set hlsearch<CR>?
nnoremap * :<C-u>set hlsearch<CR>*N:echo<CR>zz
nnoremap # :<C-u>set hlsearch<CR>#N:echo<CR>zz
nnoremap <expr> n <SID>search_forward_p() ? ':<C-u>set hlsearch<CR>nzvzz' : ':<C-u>set hlsearch<CR>Nzvzz'
nnoremap <expr> N <SID>search_forward_p() ? ':<C-u>set hlsearch<CR>Nzvzz' : ':<C-u>set hlsearch<CR>nzvzz'
vnoremap <expr> n <SID>search_forward_p() ? ':<C-u>set hlsearch<CR>nzvzz' : ':<C-u>set hlsearch<CR>Nzvzz'
vnoremap <expr> N <SID>search_forward_p() ? ':<C-u>set hlsearch<CR>Nzvzz' : ':<C-u>set hlsearch<CR>nzvzz'
function! s:search_forward_p()
	return exists('v:searchforward') ? v:searchforward : 1
endfunction
"}}}

"others{{{
set backspace=start,eol,indent
set pumheight=10
if has("clipboard")
	set clipboard=unnamed,unnamedplus
endif
if filereadable('/proc/version') && readfile('/proc/version')[0] =~? 'microsoft\|wsl' "if WSL
	augroup Yank
		au!
		autocmd TextYankPost * :call system('clip.exe', @")
	augroup END
endif
set ambiwidth=double
set virtualedit=block
set nojoinspaces
autocmd BufReadPost *
			\ if line("'\"") > 0 && line ("'\"") <= line("$") |
			\   exe "normal! g'\"" |
			\ endif
"}}}

"mapping&function{{{
"unused:
"<F3><F4><F6><F7><F8><F9>^
"[Space] + abcefgmnrxz
"   ,    + abdefghijklmopqrsuvwxyz
map <Space> [Space]
noremap [Space] <NOP>
set timeout timeoutlen=3000 ttimeoutlen=100

"movements{{{
for s:m in ['n', 'i', 'v']
	for s:k in ['Up', 'Down', 'Right', 'Left']
		execute s:m . 'noremap <' . s:k . '> <NOP>'
	endfor
endfor
unlet s:m s:k
nnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
nnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
vnoremap <expr> k (v:count == 0 ? 'gk' : 'k')
vnoremap <expr> j (v:count == 0 ? 'gj' : 'j')
nnoremap gk  k
nnoremap gj  j
vnoremap gk  k
vnoremap gj  j
noremap! <C-f> <Right>
noremap! <C-b> <Left>
noremap! <C-a> <HOME>
noremap! <C-e> <END>
nnoremap <Tab> <C-w><C-w>
vnoremap <Tab> <C-w><C-w>
nnoremap [Space]h ^
nnoremap [Space]l $
nnoremap [Space]k <C-u>
nnoremap [Space]j <C-d>
vnoremap [Space]h ^
vnoremap [Space]l $
vnoremap [Space]k <C-u>
vnoremap [Space]j <C-d>
nnoremap [Space]t :$tabnew<Space>
nnoremap <expr> gg line(".")==1 ? 'G':'gg'
vnoremap <expr> gg line(".")==1 ? 'G':'gg'
nnoremap 0 ^
vnoremap 0 ^
nnoremap <C-a> ggVG
"}}}

"actions{{{
nnoremap ; :
nnoremap : ;
nnoremap [Space]o  :<C-u>for i in range(v:count1) \| call append(line('.'), '') \| endfor<CR>
nnoremap [Space]O  :<C-u>for i in range(v:count1) \| call append(line('.')-1, '') \| endfor<CR>
nnoremap Y y$
nnoremap [Space]i gg=G
nnoremap [Space]v ^v$h
nnoremap [Space]d ^v$hx
nnoremap [Space]y ^v$hy
vnoremap [Space]p "0p
nnoremap <C-g> g<C-g>
nnoremap + <C-a>
nnoremap - <C-x>
vnoremap + <C-a>
vnoremap - <C-x>
vnoremap g+ g<C-a>
vnoremap g- g<C-x>
function! s:remove_dust()
	let cursor=getpos(".")
	%s/\s\+$//ge
	call setpos(".", cursor)
	unlet cursor
endfunction
autocmd BufWritePre * call <SID>remove_dust()
nnoremap U <C-r>
nnoremap [Space]u U
"}}}

"input{{{
vnoremap i{     "zdi<C-v>{<C-R>z}<Esc>
vnoremap i}     "zdi<C-v>{<C-R>z}<Esc>
vnoremap i[     "zdi<C-v>[<C-R>z]<Esc>
vnoremap i]     "zdi<C-v>[<C-R>z]<Esc>
vnoremap i(     "zdi<C-v>(<C-R>z)<Esc>
vnoremap i)     "zdi<C-v>(<C-R>z)<Esc>
vnoremap i"     "zdi<C-v>"<C-R>z<C-v>"<Esc>
vnoremap i'     "zdi'<C-R>z'<Esc>
vnoremap i$     "zdi$<C-R>z$<Esc>
vnoremap i&     "zdi&<C-R>z&<Esc>
vnoremap i<Bar> "zdi<Bar><C-R>z<Bar><Esc>
autocmd FileType tex vnoremap iR "zdi\color{red}<C-R>z\color{black}<Esc>
autocmd FileType tex vnoremap iU "zdi<C-v>\underline{<C-R>z}<Esc>
autocmd FileType tex vnoremap iB "zdi<C-v>\textbf{<C-R>z}<Esc>
autocmd FileType tex vnoremap i" "zdi<C-v>``<C-R>z"<Esc>
autocmd FileType php vnoremap iP "zdi<C-v><?php <C-R>z?><Esc>
inoremap zl ->
inoremap zh <-
inoremap <C-j> <CR>
"}}}

"mark{{{
nnoremap [Space]M ['
nnoremap [Space]m ]'
if !exists('g:markrement_char')
	let g:markrement_char = [
				\'a', 'b', 'c', 'd', 'e', 'f', 'g', 'h', 'i', 'j', 'k', 'l', 'm',
				\'n', 'o', 'p', 'q', 'r', 's', 't', 'u', 'v', 'w', 'x', 'y', 'z'
				\ ]
endif
nnoremap <silent>m :<C-u>call <SID>AutoMarkrement()<CR>
function! s:AutoMarkrement()
	if !exists('b:markrement_pos')
		let b:markrement_pos = 0
	else
		let b:markrement_pos = (b:markrement_pos + 1) % len(g:markrement_char)
	endif
	execute 'mark' g:markrement_char[b:markrement_pos]
	echo 'marked' g:markrement_char[b:markrement_pos]
endfunction
"}}}

"text{{{
autocmd filetype php inoremap PHP <?php<Space>?><Left><Left><Left>
autocmd filetype tex inoremap REF \ref{xxx}
autocmd filetype tex inoremap FIG \begin{figure}[t]<CR>\centering<CR>%<Space>\includegraphics[width=8cm,clip]{./pdf/xxx.pdf}<CR>\caption{.\label{xxx}}<CR>\end{figure}
autocmd filetype tex inoremap TAB \begin{table}[t]<CR>\centering<CR>\caption{.\label{xxx}}<CR>\begin{tabular}{\|c\|\|c\|c\|}<Space>\hline<CR>a<Space>&<Space>b<Space>&<Space>c<Space>\\<Space>\hline<Space>\hline<CR>\end{tabular}<CR>\end{table}
autocmd filetype tex inoremap LIST \lstinputlisting[caption=.,label=xxx]{sample.txt}<CR>
"}}}

"todo{{{
nnoremap T :VTodoToggle<CR>
command! TodoToggle call s:TodoToggle()
function! s:TodoToggle()
	let todowinnr = bufwinnr(".todo")
	if todowinnr != -1
		exe todowinnr."wincmd w"
		write
		bdelete
		return
	endif
	if filereadable(".todo")
		7 split .todo
	else
		7 split ~/.todo
	endif
endfunction
command! VTodoToggle call s:VTodoToggle()
function! s:VTodoToggle()
	let todowinnr = bufwinnr(".todo")
	if todowinnr != -1
		exe todowinnr."wincmd w"
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
inoremap tL - [ ]<Space>
nnoremap tL /- [<CR>
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
"}}}

"RUN{{{
"intentionally semicolon
nmap <F5> <Esc>;RUN<CR>
imap <F5> <Esc><Esc>;RUN<CR>
vmap <F5> <Esc><Esc>;RUN<CR>
nnoremap [Space]<F5> <Esc>:RUN<CR>

let s:run_simple = {
			\ 'rb':  '!ruby % -w',
			\ 'ml':  '!ocaml -init %',
			\ 'pml': '!spin -search %',
			\ 'js':  '!node %',
			\ 'tex': '!latexmk % -pv; rm platex*.fls *.dvi *.gz',
			\ }
command! RUN call s:RUN()
function! s:RUN()
	wall
	let e=expand("%:e")
	if has_key(s:run_simple, e)
		execute s:run_simple[e]
	elseif e=="c"
		if filereadable("Makefile")
			make
		elseif filereadable("main.c")
			!gcc *.c -O0 -lm -g -o main -Wall;
		else
			!gcc % -O0 -lm -g -o .x_%:r -Wall;
		endif
		if filereadable("main") | !./main | else | !./.x_%:r | endif
	elseif e=="cpp"
		if filereadable("Makefile")
			make
		else
			!g++ % -O3 -lm -o .x_%:r -Wall -std=c++11 `pkg-config --cflags opencv4` `pkg-config --libs opencv4`;
		endif
		if filereadable("main") | !./main | else | !./.x_%:r | endif
	elseif e=="java"
		if filereadable("Makefile")
			make; !java Main
		else
			!javac %
			!java %:r
		endif
	elseif e=="py"
		if bufwinnr("main.py")!=-1
			!python3 -B main.py
		else
			!python3 -B %
		endif
	endif
endfunction
autocmd filetype vim nnoremap <F5> :w<CR>:source %<CR>
autocmd filetype vim inoremap <F5> <Esc>:w<CR>:source %<CR>
autocmd filetype vim vnoremap <F5> <Esc>:w<CR>:source %<CR>
"}}}

"template{{{
for s:ext in ['c', 'cpp', 'java', 'sh', 'tex', 'py']
	execute 'autocmd BufNewFile,BufRead *.' . s:ext . ' if getfsize(@%)<=0 | 0read ' . s:dotfiles_dir . '/template/template.' . s:ext . ' | %substitute/filename/\=expand(''%:t:r'')/g | endif'
endfor
unlet s:ext
execute 'autocmd BufNewFile,BufRead .todo if getfsize(@%)<=0 | 0read ' . s:dotfiles_dir . '/template/template.todo | endif'
"}}}
"}}}
