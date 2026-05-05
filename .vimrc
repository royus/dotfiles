" Last Change: 2026-05-05
" Minimal Vim configuration

"appearance{{{
set t_Co=256
syntax enable
set title
set number relativenumber ruler
set showcmd
set list listchars=eol:~,tab:\|_
set background=dark
set breakindent showbreak=+++
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
colorscheme darkblue
highlight normal ctermbg=NONE
"}}}

"encoding{{{
set encoding=utf-8 fileencodings=utf-8,iso-2022-jp,euc-jp,sjis fileencoding=utf-8
set fileformat=unix fileformats=unix,dos,mac
set ambiwidth=double
"}}}

"files{{{
set noswapfile nobackup nowritebackup
set autochdir hidden
"}}}

"folding{{{
nnoremap z za
nnoremap Z zR
vnoremap z zf
autocmd filetype vim,tex set foldmethod=marker
"}}}

"searches{{{
set incsearch wrapscan ignorecase smartcase wildignorecase
set wildmode=list:longest,full
set wildignore=*.o,*.obj,tags*,*.pyc,*.class,*.out
nnoremap <Esc><Esc> :<C-u>nohlsearch<CR>
"}}}

"others{{{
set shell=/bin/sh
set history=100
set backspace=start,eol,indent
set pumheight=10
set virtualedit=block
set nojoinspaces
if has("clipboard")
	set clipboard=unnamed,unnamedplus
endif
if filereadable('/proc/version') && readfile('/proc/version')[0] =~? 'microsoft\|wsl'
	augroup Yank
		au!
		autocmd TextYankPost * :call system('clip.exe', @")
	augroup END
endif
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
"}}}

"mappings{{{
map <Space> [Space]
noremap [Space] <NOP>
set timeout timeoutlen=3000 ttimeoutlen=100

for s:m in ['n', 'i', 'v']
	for s:k in ['Up', 'Down', 'Right', 'Left']
		execute s:m . 'noremap <' . s:k . '> <NOP>'
	endfor
endfor
unlet s:m s:k

noremap! <C-f> <Right>
noremap! <C-b> <Left>
noremap! <C-a> <HOME>
noremap! <C-e> <END>

nnoremap <Tab> <C-w><C-w>
vnoremap <Tab> <C-w><C-w>

nnoremap [Space]w :<C-u>w<CR>
nnoremap [Space]q :<C-u>q<CR>
nnoremap q<Space> :<C-u>q<CR>
nnoremap [Space]Q :<C-u>qa!<CR>
nnoremap Q<Space> :<C-u>qa!<CR>
nnoremap Q <NOP>
nnoremap <C-z> <NOP>

nnoremap ; :
nnoremap : ;
nnoremap Y y$
nnoremap 0 ^
vnoremap 0 ^
"}}}

"strip trailing whitespace on save{{{
function! s:remove_dust()
	let l:cursor=getpos(".")
	%s/\s\+$//ge
	call setpos(".", l:cursor)
endfunction
autocmd BufWritePre * call <SID>remove_dust()
"}}}
