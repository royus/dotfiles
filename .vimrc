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

" auto-enable hlsearch on / ? * #, keep cursor on * #, direction-aware n/N with center
function! s:search_forward_p()
	return exists('v:searchforward') ? v:searchforward : 1
endfunction
nnoremap / :<C-u>set hlsearch<CR>/
nnoremap ? :<C-u>set hlsearch<CR>?
nnoremap * :<C-u>set hlsearch<CR>*N:echo<CR>zz
nnoremap # :<C-u>set hlsearch<CR>#N:echo<CR>zz
nnoremap <expr> n <SID>search_forward_p() ? ':<C-u>set hlsearch<CR>nzvzz' : ':<C-u>set hlsearch<CR>Nzvzz'
nnoremap <expr> N <SID>search_forward_p() ? ':<C-u>set hlsearch<CR>Nzvzz' : ':<C-u>set hlsearch<CR>nzvzz'
vnoremap <expr> n <SID>search_forward_p() ? ':<C-u>set hlsearch<CR>nzvzz' : ':<C-u>set hlsearch<CR>Nzvzz'
vnoremap <expr> N <SID>search_forward_p() ? ':<C-u>set hlsearch<CR>Nzvzz' : ':<C-u>set hlsearch<CR>nzvzz'
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

" insert/cmdline movement
noremap! <C-f> <Right>
noremap! <C-b> <Left>
noremap! <C-a> <HOME>
noremap! <C-e> <END>

" window switch
noremap <Tab> <C-w><C-w>

" save / quit
nnoremap [Space]w :<C-u>w<CR>
nnoremap [Space]q :<C-u>q<CR>
nnoremap q<Space> :<C-u>q<CR>
nnoremap [Space]Q :<C-u>qa!<CR>
nnoremap Q<Space> :<C-u>qa!<CR>
nnoremap Q <NOP>
nnoremap <C-z> <NOP>

" misc
nnoremap ; :
nnoremap : ;
nnoremap Y y$
nnoremap 0 ^
vnoremap 0 ^
"}}}

"navigation & edit (layout-independent){{{
" k motion is unchanged across QWERTY/eucalyn
noremap [Space]k <C-u>

" auto-indent / insert blank lines
nnoremap [Space]i gg=G
nnoremap [Space]o :<C-u>for i in range(v:count1) <Bar> call append(line('.'), '') <Bar> endfor<CR>
nnoremap [Space]O :<C-u>for i in range(v:count1) <Bar> call append(line('.')-1, '') <Bar> endfor<CR>

" U: redo, [Space]u: original U (undo line)
nnoremap U <C-r>
nnoremap [Space]u U

" increment / decrement
noremap + <C-a>
noremap - <C-x>

" select all
nnoremap <C-a> ggVG

" history windows under leader
noremap q: <NOP>
noremap q/ <NOP>
noremap [Space]; q:
noremap [Space]/ q/
"}}}

"input snippets{{{
inoremap zl ->
inoremap zh <-

" visual surround insertions
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
"}}}

"eucalyn toggle{{{
" When eucalyn=1 (default): physical h/j/l output g/t/s.
"   Map g/t/s to Vim h/j/l motion. k unchanged.
"   'hh' (rarely-typed physical M-M) substitutes for gg toggle.
"   [Space]g/s/t take over [Space]h/l/j roles.
" When eucalyn=0: classic QWERTY mappings.
" Toggle at runtime with :EucalynToggle
function! s:SmartGG()
	return line(".")==1 ? 'G' : 'gg'
endfunction
let g:eucalyn = 1
function! s:ApplyEucalyn(enable)
	if a:enable
		nnoremap g h
		nnoremap t j
		nnoremap s l
		vnoremap g h
		vnoremap t j
		vnoremap s l
		nnoremap <expr> hh <SID>SmartGG()
		noremap [Space]g ^
		noremap [Space]s $
		noremap [Space]t <C-d>
		silent! nunmap gg
		silent! vunmap gg
		silent! vunmap g+
		silent! vunmap g-
		silent! unmap [Space]h
		silent! unmap [Space]j
		silent! unmap [Space]l
	else
		silent! nunmap g
		silent! nunmap t
		silent! nunmap s
		silent! vunmap g
		silent! vunmap t
		silent! vunmap s
		silent! nunmap hh
		silent! unmap [Space]g
		silent! unmap [Space]s
		silent! unmap [Space]t
		nnoremap <expr> gg <SID>SmartGG()
		vnoremap <expr> gg <SID>SmartGG()
		vnoremap g+ g<C-a>
		vnoremap g- g<C-x>
		noremap [Space]h ^
		noremap [Space]l $
		noremap [Space]j <C-d>
	endif
	let g:eucalyn = a:enable
	echo "eucalyn: " . (a:enable ? "on" : "off")
endfunction
call s:ApplyEucalyn(g:eucalyn)
command! EucalynToggle call s:ApplyEucalyn(!g:eucalyn)
"}}}

"strip trailing whitespace on save{{{
function! s:remove_dust()
	let l:cursor=getpos(".")
	%s/\s\+$//ge
	call setpos(".", l:cursor)
endfunction
autocmd BufWritePre * call <SID>remove_dust()
"}}}
