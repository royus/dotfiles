"20160705
"neobundle
if has('vim_starting')
    set runtimepath+=~/.vim/bundle/neobundle.vim
endif
call neobundle#begin(expand('~/.vim/bundle/'))
    NeoBundleFetch 'Shougo/neobundle.vim'
    "plugins here!
    NeoBundle 'scrooloose/nerdtree'
    NeoBundle 'tpope/vim-surround'
    NeoBundle 'nathanaelkane/vim-indent-guides'
    NeoBundle 'bronson/vim-trailing-whitespace'
    NeoBundle 'tomtom/tcomment_vim'
    NeoBundle 'itchyny/lightline.vim'
    NeoBundle 'mattn/emmet-vim'

    NeoBundle 'w0ng/vim-hybrid'
    " NeoBundle 'nanotech/jellybeans.vim'
    " NeoBundle 'jpo/vim-railscasts-theme'
    " NeoBundle 'tomasr/molokai'
    " NeoBundle 'jacoborus/tender'
    " NeoBundle 'morhetz/gruvbox'
call neobundle#end()
filetype plugin indent on

"appearence
set showcmd
set title
set number ruler
set clipboard=unnamedplus
set cursorline
set background=dark
syntax on
colorscheme hybrid
set display=lastline
" set list listchars=eol:~

"encoding
set encoding=utf-8 fileencodings=utf-8,iso-2022-jp,euc-jp,sjis

"indentation
set smartindent autoindent
set tabstop=4 shiftwidth=4 expandtab smarttab
let g:indent_guides_start_level = 2
let g:indent_guides_guide_size = 1
let g:indent_guides_enable_on_vim_startup=1

"searches
set incsearch hlsearch ignorecase smartcase
set wildignorecase
set wildmode=list:longest,full

"others
set noswapfile
set hidden
set scrolloff=7
set history=100
set backspace=start,eol,indent
set pumheight=10 "completion
set showmatch "jump2matching()[]{}
set matchpairs+=「:」
set foldmethod=syntax
set foldlevel=100
autocmd InsertEnter * if &l:foldmethod ==# 'syntax'
            \       | setlocal foldmethod=manual
            \       | endif
autocmd InsertLeave * if &l:foldmethod ==# 'manual'
            \       | setlocal foldmethod=syntax
            \       | endif

"lightline
set laststatus=2
set noshowmode
set t_Co=256
let loaded_matchparen = 1
highlight normal ctermbg=none
let g:lightline = {
            \ 'colorscheme': 'jellybeans',
            \ }

"auto_command
" autocmd BufRead *.c,*.java retab
" autocmd BufDelete *.c,*.java set noexpandtab,retab!

"mapping&function
nnoremap Y y$
nnoremap + <C-a>
nnoremap - <C-x>
nnoremap <Space>h  ^
nnoremap <Space>l  $
nnoremap k   gk
nnoremap j   gj
vnoremap k   gk
vnoremap j   gj
nnoremap gk  k
nnoremap gj  j
vnoremap gk  k
vnoremap gj  j
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
inoremap <silent> jj  <Esc>
inoremap <silent> っj <ESC>
vnoremap <Tab> <Esc>
nnoremap あ a
nnoremap い i
nnoremap う u
nnoremap お o
nnoremap っd dd
nnoremap っy yy
nnoremap <Esc><Esc> :<C-u>set nohlsearch<CR>
nnoremap / :<C-u>set hlsearch<CR>/
nnoremap ? :<C-u>set hlsearch<CR>?
nnoremap * :<C-u>set hlsearch<CR>*
nnoremap # :<C-u>set hlsearch<CR>#
nnoremap n :<C-u>set hlsearch<CR>n
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
nnoremap & :&&<CR>
xnoremap & :&&<CR>
nnoremap <C-n> :NERDTreeToggle<CR>
command! RUN call s:RUN()
nnoremap <F5> :RUN<CR>
inoremap <F5> <Esc>:RUN<CR>
vnoremap <F5> <Esc>:RUN<CR>
function! s:RUN()
    let e = expand("%:e")
    if e == "c"
        :GCC
        :!./.x_%:r
    endif
    if e == "java"
        :JAVAC
        :!java %:r
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
command! W call s:SU_W()
function! s:SU_W()
    :w !sudo tee %
endfunction
