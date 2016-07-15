"20160715
"dein
if &compatible
    set nocompatible
endif
set runtimepath^=~/.vim/bundle/dein.vim
call dein#begin(expand('~/.vim/bundle/'))
call dein#add('Shougo/dein.vim')

call dein#add('scrooloose/nerdtree')
call dein#add('tpope/vim-surround')
call dein#add('nathanaelkane/vim-indent-guides')
call dein#add('bronson/vim-trailing-whitespace')
call dein#add('tomtom/tcomment_vim')
call dein#add('itchyny/lightline.vim')
call dein#add('mattn/emmet-vim')
call dein#add('w0ng/vim-hybrid')

call dein#end()
filetype plugin indent on
if dein#check_install()
    call dein#install()
endif


"appearence
set showcmd
set title
set number ruler
set clipboard=unnamedplus
set cursorline
set cursorcolumn
set background=dark
syntax on
" hi MatchParen gui=NONE guibg=NONE guifg=green
" hi MatchParen ctermbg=1
colorscheme hybrid
" highlight Cursor ctermbg=red ctermfg=black
" hi MatchParen ctermfg=LightGreen ctermbg=blue
set display=lastline
" set list listchars=eol:~
" let g:loaded_matchparen = 1


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
set pumheight=10
set showmatch
set matchpairs+=<:>
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
" let loaded_matchparen = 1
highlight normal ctermbg=none
let g:lightline = {
            \ 'colorscheme': 'jellybeans',
            \ }


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
inoremap <C-j> <Down>
inoremap <C-k> <Up>
inoremap <C-h> <Left>
inoremap <C-l> <Right>
nnoremap <Space> <NOP>
vnoremap <Space> <NOP>
nnoremap <Space>h  ^
nnoremap <Space>l  $
nnoremap <silent> [b :bprevious<CR>
nnoremap <silent> ]b :bnext<CR>
nnoremap <silent> [B :bfirst<CR>
nnoremap <silent> ]B :blast<CR>
cnoremap <C-l> <right>
"esc
inoremap <silent> jj  <Esc>
vnoremap <Tab> <Esc>
"search
nnoremap <Esc><Esc> :<C-u>set nohlsearch<CR>
nnoremap / :<C-u>set hlsearch<CR>/
nnoremap ? :<C-u>set hlsearch<CR>?
nnoremap * :<C-u>set hlsearch<CR>*
nnoremap # :<C-u>set hlsearch<CR>#
nnoremap n :<C-u>set hlsearch<CR>n
nnoremap <expr> n <SID>search_forward_p() ? 'nzv' : 'Nzv'
nnoremap <expr> N <SID>search_forward_p() ? 'Nzv' : 'nzv'
vnoremap <expr> n <SID>search_forward_p() ? 'nzv' : 'Nzv'
vnoremap <expr> N <SID>search_forward_p() ? 'Nzv' : 'nzv'
function! s:search_forward_p()
    return exists('v:searchforward') ? v:searchforward : 1
endfunction
"functions
nnoremap ZZ <Nop>
nnoremap ZQ <Nop>
nnoremap Y y$
nnoremap + <C-a>
nnoremap - <C-x>
nnoremap & :&&<CR>
xnoremap & :&&<CR>
nnoremap <Space>o  :<C-u>for i in range(v:count1) \| call append(line('.'), '') \| endfor<CR>
nnoremap <Space>O  :<C-u>for i in range(v:count1) \| call append(line('.')-1, '') \| endfor<CR>
nnoremap gs  :<C-u>%s///g<Left><Left><Left>
vnoremap gs  :s///g<Left><Left><Left>
nnoremap <Space>w :<C-u>w<CR>
nnoremap <Space>W :<C-u>W<CR>
command! W call s:SU_W()
function! s:SU_W()
    :w !sudo tee %
endfunction
nnoremap <Space>q :<C-u>q<CR>
nnoremap <Space>Q :<C-u>q!<CR>
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
    if e == "rb"
        :!ruby %
    endif
    if e == "py"
        :!python %
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
