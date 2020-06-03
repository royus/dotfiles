" Last Change: 2020/06/03 (Wed) 22:28:58.

" yankround https://github.com/LeafCage/yankround.vim/{{{
" plugin {{{
if expand('<sfile>:p')!=#expand('%:p') && exists('g:loaded_yankround')| finish| endif| let g:loaded_yankround = 1
let s:save_cpo = &cpo| set cpo&vim
scriptencoding utf-8
"=============================================================================
let g:yankround_dir = get(g:, 'yankround_dir', '~/.config/vim/yankround')
let g:yankround_max_history = get(g:, 'yankround_max_history', 30)
let g:yankround_max_element_length = get(g:, 'yankround_max_element_length', 512000)
let g:yankround_use_region_hl = get(g:, 'yankround_use_region_hl', 0)
let g:yankround_region_hl_groupname = get(g:, 'yankround_region_hl_groupname', 'YankRoundRegion')
"======================================
nnoremap <silent><Plug>(yankround-p)    :<C-u>exe yankround#init('p')<Bar>call yankround#activate()<CR>
nnoremap <silent><Plug>(yankround-P)    :<C-u>exe yankround#init('P')<Bar>call yankround#activate()<CR>
nnoremap <silent><Plug>(yankround-gp)    :<C-u>exe yankround#init('gp')<Bar>call yankround#activate()<CR>
nnoremap <silent><Plug>(yankround-gP)    :<C-u>exe yankround#init('gP')<Bar>call yankround#activate()<CR>
xnoremap <silent><Plug>(yankround-p)    :<C-u>exe yankround#init('p', 'v')<Bar>call yankround#activate()<CR>
xmap <Plug>(yankround-P)  <Plug>(yankround-p)
xnoremap <silent><Plug>(yankround-gp)    :<C-u>exe yankround#init('gp', 'v')<Bar>call yankround#activate()<CR>
xmap <Plug>(yankround-gP)  <Plug>(yankround-gp)
nnoremap <silent><Plug>(yankround-prev)    :<C-u>call yankround#prev()<CR>
nnoremap <silent><Plug>(yankround-next)    :<C-u>call yankround#next()<CR>
cnoremap <expr><Plug>(yankround-insert-register)   getcmdline()=="" ? "\<C-r>" : "\<C-\>eyankround#cmdline_base()\<CR>\<C-r>"
cnoremap <Plug>(yankround-pop)    <C-\>eyankround#cmdline_pop(1)<CR>
cnoremap <Plug>(yankround-backpop)   <C-\>eyankround#cmdline_pop(-1)<CR>

"=============================================================================

let s:yankround_dir = expand(g:yankround_dir)
if !(s:yankround_dir=='' || isdirectory(s:yankround_dir))
	call mkdir(s:yankround_dir, 'p')
end

let s:path = s:yankround_dir. '/history'
let s:is_readable = filereadable(s:path)
let g:_yankround_cache = s:is_readable ? readfile(s:path) : []
let s:_histfilever = s:is_readable ? getftime(s:path) : 0
unlet s:path s:is_readable
let g:_yankround_stop_caching = 0

aug yankround
	autocmd!
	autocmd CursorMoved *   call Yankround_append()
	autocmd ColorScheme *   call s:define_region_hl()
	autocmd VimLeavePre *   call s:_persistent()
	autocmd CmdwinEnter *   call yankround#on_cmdwinenter()
	autocmd CmdwinLeave *   call yankround#on_cmdwinleave()
aug END

function! s:define_region_hl() "{{{
	if &bg=='dark'
		highlight default YankRoundRegion   guibg=Brown ctermbg=Brown term=reverse
	else
		highlight default YankRoundRegion   guibg=LightRed ctermbg=LightRed term=reverse
	end
endfunction
"}}}
call s:define_region_hl()

function! Yankround_append() "{{{
	call s:_reloadhistory()
	if g:_yankround_stop_caching || @" ==# substitute(get(g:_yankround_cache, 0, ''), '^.\d*\t', '', '') || @"=~'^.\?$'
				\ || g:yankround_max_element_length!=0 && strlen(@")>g:yankround_max_element_length
		return
	end
	call insert(g:_yankround_cache, getregtype('"'). "\t". @")
	call s:newDupliMiller().mill(g:_yankround_cache)
	if len(g:_yankround_cache) > g:yankround_max_history
		call remove(g:_yankround_cache, g:yankround_max_history, -1)
	end
	call s:_persistent()
endfunction
"}}}
function! s:_persistent() "{{{
	if g:yankround_dir=='' || g:_yankround_cache==[]
		return
	end
	let path = s:yankround_dir. '/history'
	call writefile(g:_yankround_cache, path)
	let s:_histfilever = getftime(path)
endfunction
"}}}
function! s:_reloadhistory() "{{{
	if g:yankround_dir==''
		return
	end
	let path = expand(g:yankround_dir). '/history'
	if !filereadable(path) || getftime(path) <= s:_histfilever
		return
	end
	let g:_yankround_cache = readfile(path)
	let s:_histfilever = getftime(path)
endfunction
"}}}

"=============================================================================
"Misc:
let s:DupliMiller = {}
function! s:newDupliMiller() "{{{
	let obj = copy(s:DupliMiller)
	let obj.seens = {}
	return obj
endfunction
"}}}
function! s:DupliMiller._is_firstseen(str) "{{{
	if has_key(self.seens, a:str)
		return
	end
	if a:str!=''
		let self.seens[a:str] = 1
	end
	return 1
endfunction
"}}}
function! s:DupliMiller.mill(list) "{{{
	return filter(a:list, 'self._is_firstseen(v:val)')
endfunction
"}}}

"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo
" }}}
" autoload {{{
if exists('s:save_cpo')| finish| endif
let s:save_cpo = &cpo| set cpo&vim
"=============================================================================
let s:Rounder = {}
function! s:newRounder(keybind, is_vmode) "{{{
	let obj = {'keybind': a:keybind, 'count': v:count1, 'register': v:register, 'idx': -1, 'match_id': 0,
				\ 'in_cmdwin': bufname('%')==#'[Command Line]', 'anchortime': localtime(), 'is_vmode': a:is_vmode}
	if !obj.in_cmdwin && undotree().seq_last!=0
		let obj.undofilepath = expand(g:yankround_dir).'/save_undo'
		exe 'wundo!' fnameescape(obj.undofilepath)
	end
	call extend(obj, s:Rounder)
	return obj
endfunction
"}}}
function! s:Rounder.activate() "{{{
	let self.pos = getpos('.')
	call self.update_changedtick()
	let self.using_region_hl = g:yankround_use_region_hl
	if self.using_region_hl
		call self._region_hl(getregtype(self.register))
	end
endfunction
"}}}
function! s:Rounder._region_hl(regtype) "{{{
	let [sl, sc] = [line("'["), col("'[")]
	let [el, ec] = [line("']"), col("']")]
	let dots = sl==el ? '.*' : '\_.*'
	let pat =
				\ a:regtype[0]==#"\<C-v>" ? printf('\v%%>%dl%%>%dc.*%%<%dl%%<%dc', sl-1, sc-1, el+1, ec+1) :
				\ a:regtype==#'v' ? printf('\v%%%dl%%>%dc%s%%%dl%%<%dc', sl, sc-1, dots, el, ec+1) :
				\ printf('\v%%%dl%s%%%dl', sl, dots, el)
	let self.match_id = matchadd(g:yankround_region_hl_groupname, pat)
	if !self.in_cmdwin
		let t:yankround_anchor = self.anchortime
		let w:yankround_anchor = self.anchortime
	end
endfunction
"}}}

function! s:Rounder.update_changedtick() "{{{
	let self.changedtick = b:changedtick
endfunction
"}}}

function! s:Rounder.is_cursormoved() "{{{
	return getpos('.')!=s:rounder.pos
endfunction
"}}}
function! s:Rounder.is_valid() "{{{
	if get(self, '_cachelen', 1) != 0 && has_key(self, 'changedtick') && self.changedtick==b:changedtick
		return 1
	end
	call s:destroy_rounder()
endfunction
"}}}

function! s:Rounder.round_cache(delta) "{{{
	let self._cachelen = len(g:_yankround_cache)
	if !self.is_valid()
		return
	end
	let g:_yankround_stop_caching = 1
	let self.idx = self._round_idx(a:delta)
	let [str, regtype] = yankround#_get_cache_and_regtype(self.idx)
	call setreg('"', str, regtype)
	silent undo
	call self._rest_undotree()
	if self.is_vmode
		silent exe 'norm! gv"0'. self.count. self.keybind
	else
		silent exe 'norm! ""'. self.count. self.keybind
	end
	if self.using_region_hl
		call self.clear_region_hl()
		call self._region_hl(regtype)
	end
	let self.pos = getpos('.')
	call self.update_changedtick()
endfunction
"}}}
function! s:Rounder._round_idx(delta) "{{{
	if self.idx==-1
		if @"!=yankround#_get_cache_and_regtype(0)[0] || self.register!='"'
			return 0
		else
			let self.idx = self.is_vmode ? 1 : 0
		end
	end
	let self.idx += a:delta
	return self.idx>=self._cachelen ? 0 : self.idx<0 ? self._cachelen-1 : self.idx
endfunction
"}}}
function! s:Rounder._rest_undotree() "{{{
	if self.in_cmdwin
		return
	elseif has_key(self, 'undofilepath')
		silent exe 'rundo' fnameescape(self.undofilepath)
		return
	end
	let save_ul = &undolevels
	set ul=-1
	call setline('.', getline('.'))
	set nomod
	let &ul = save_ul
endfunction
"}}}

function! s:Rounder.clear_region_hl() "{{{
	if !(has_key(self, 'using_region_hl') && self.using_region_hl && self.match_id)
		return
	end
	if self.in_cmdwin
		if bufname('%')==#'[Command Line]'
			call matchdelete(self.match_id)
			let self.match_id = 0
		end
		return
	end
	let save_here = [tabpagenr(), winnr(), winsaveview()]
	if !has_key(t:, 'yankround_anchor') && !s:_caught_tabpage_anchor(self.anchortime)
		return
	end
	if !has_key(w:, 'yankround_anchor') && !s:_caught_win_anchor(self.anchortime)
		silent exe 'tabn' save_here[0]
		call winrestview(save_here[2])
		return
	end
	call matchdelete(self.match_id)
	let self.match_id = 0
	unlet t:yankround_anchor w:yankround_anchor
	try
		silent exe 'tabn' save_here[0]
		silent exe save_here[1].'wincmd w'
	catch /E523:/ "in :map-<expr>
	endtry
	call winrestview(save_here[2])
endfunction
"}}}
function! s:_caught_tabpage_anchor(anchortime) "{{{
	for tn in range(1, tabpagenr('$'))
		if gettabvar(tn, 'yankround_anchor')==a:anchortime
			silent exe 'tabn' tn
			return 1
		end
	endfor
endfunction
"}}}
function! s:_caught_win_anchor(anchortime) "{{{
	for wn in range(1, winnr('$'))
		if getwinvar(wn, 'yankround_anchor')==a:anchortime
			silent exe wn.'wincmd w'
			return 1
		end
	endfor
endfunction
"}}}

let s:BaseCmdline = {}
function! s:newBaseCmdline() "{{{
	let obj = copy(s:BaseCmdline)
	let obj.idx = -1
	let obj.pos = getpos('.')
	let obj.line = getcmdline()
	let cursor = getcmdpos()-1
	let obj.head = obj.line[:cursor-1]
	let obj.tail = obj.line[cursor :]
	return obj
endfunction
"}}}
function! s:BaseCmdline.is_identical(context) "{{{
	return self.pos==getpos('.') && stridx(a:context.line, self.head)==0 && a:context.line[a:context.cursor :]==self.tail
endfunction
"}}}
function! s:BaseCmdline.get_popstr(context, delta) "{{{
	let self._cachelen = len(g:_yankround_cache)
	if self._cachelen==0
		return ''
	elseif self.idx==-1
		let self.idx = 0
		let self.origin = a:context.line[len(self.head)-1 : a:context.cursor-1]
		let str = self._get_yankcache()
		if str !=# self.origin
			return str
		end
	end
	let self.idx += a:delta
	let self.idx = self.idx>self._cachelen ? 0 : self.idx<0 ? self._cachelen : self.idx
	return self._get_yankcache()
endfunction
"}}}
function! s:BaseCmdline.replace_cmdline(str) "{{{
	let upper = self.head. a:str
	call setcmdpos(len(upper) +1)
	return upper. self.tail
endfunction
"}}}
function! s:BaseCmdline._get_yankcache() "{{{
	if self.idx==self._cachelen
		return self.origin
	end
	let [str, regtype] = yankround#_get_cache_and_regtype(self.idx)
	return substitute(substitute(str, '\%(^\|\n\)\@<=\s*\n\|\n$', '', 'g'), '\n', '| ', 'g')
endfunction
"}}}


"=============================================================================
"Main:
function! yankround#init(keybind, ...) "{{{
	let is_vmode = a:0
	if has_key(s:, 'rounder')
		call s:destroy_rounder()
	end
	if getregtype()!=''
		let s:rounder = s:newRounder(a:keybind, is_vmode)
	end
	if !is_vmode || v:register!='"'
		return 'norm! '. (is_vmode ? 'gv' : ''). '"'. v:register. v:count1. a:keybind
	end
	let @0 = @"
	return 'norm! gv"0'. v:count1. a:keybind
endfunction
"}}}
function! yankround#activate() "{{{
	if !has_key(s:, 'rounder')
		return
	end
	call s:rounder.activate()
	call s:_rounder_autocmd()
endfunction
"}}}

function! s:destroy_rounder() "{{{
	call s:rounder.clear_region_hl()
	unlet s:rounder
	aug yankround_rounder
		autocmd!
	aug END
	let g:_yankround_stop_caching = 0
	call Yankround_append()
endfunction
"}}}

function! yankround#prev() "{{{
	if !has_key(s:, 'rounder')
		return
	end
	call s:rounder.round_cache(1)
	echo 'yankround:' yankround#get_roundstatus()
endfunction
"}}}
function! yankround#next() "{{{
	if !has_key(s:, 'rounder')
		return
	end
	call s:rounder.round_cache(-1)
	echo 'yankround:' yankround#get_roundstatus()
endfunction
"}}}

function! yankround#is_active() "{{{
	return has_key(s:, 'rounder') && s:rounder.is_valid()
endfunction
"}}}
function! yankround#get_roundstatus() "{{{
	return has_key(s:, 'rounder') ? '('. (s:rounder.idx+1). '/'. s:rounder._cachelen. ')' : ''
endfunction
"}}}

"--------------------------------------
function! yankround#is_cmdline_popable() "{{{
	let context = {'line': getcmdline(), 'cursor': getcmdpos()-1}
	let ret = exists('s:basecmdline') && s:basecmdline.is_identical(context)
	if !ret
		unlet! s:basecmdline
	end
	return ret
endfunction
"}}}
function! yankround#cmdline_base() "{{{
	let s:basecmdline = s:newBaseCmdline()
	return s:basecmdline.line
endfunction
"}}}
function! yankround#cmdline_pop(delta) "{{{
	let context = {'line': getcmdline(), 'cursor': getcmdpos()-1}
	if !(exists('s:basecmdline') && s:basecmdline.is_identical(context))
		unlet! s:basecmdline
		return context.line
	end
	let str = s:basecmdline.get_popstr(context, a:delta)
	return str=='' ? context.line : s:basecmdline.replace_cmdline(str)
endfunction
"}}}

"======================================
function! s:_rounder_autocmd() "{{{
	aug yankround_rounder
		autocmd!
		autocmd CursorMoved *   if s:rounder.is_cursormoved()| call s:destroy_rounder()| end
		autocmd BufWritePost *  call s:rounder.update_changedtick()
		autocmd InsertEnter *   call s:rounder.clear_region_hl()
	aug END
endfunction
"}}}

function! yankround#on_cmdwinenter() "{{{
	if !has_key(s:, 'rounder')
		return
	end
	let s:save_rounder = deepcopy(s:rounder)
	unlet s:rounder
	aug yankround_rounder
		autocmd!
	aug END
	let g:_yankround_stop_caching = 0
endfunction
"}}}
function! yankround#on_cmdwinleave() "{{{
	if !has_key(s:, 'save_rounder')
		return
	end
	let g:_yankround_stop_caching = 1
	let s:rounder = s:save_rounder
	call s:_rounder_autocmd()
endfunction
"}}}

function! yankround#_get_cache_and_regtype(idx) "{{{
	let ret = matchlist(g:_yankround_cache[a:idx], '^\(.\d*\)\t\(.*\)')
	return [ret[2], ret[1]]
endfunction
"}}}

"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo
if exists('s:save_cpo')| finish| endif
let s:save_cpo = &cpo| set cpo&vim
"=============================================================================
function! unite#sources#yankround#define() "{{{
	return s:source
endfunction
"}}}

"=============================================================================
let s:source = {'name': 'yankround', 'description': 'candidates from yankround', 'default_kind': 'word'}
function! s:source.gather_candidates(args, context) "{{{
	return map(copy(g:_yankround_cache), 's:_candidatify(v:val)')
endfunction
"}}}
function! s:_candidatify(cache) "{{{
	let matchlist = matchlist(a:cache, "^\\(.\\d*\\)\t\\(.*\\)")
	return {'word': matchlist[2], 'action__regtype': matchlist[1], 'is_multiline': 1, 'source__raw': a:cache}
endfunction
"}}}
"==================
let s:source.action_table = {'delete': {'description': 'delete from yankround',
			\ 'is_invalidate_cache': 1, 'is_quit': 0, 'is_selectable': 1}}
function! s:source.action_table.delete.func(candidates) "{{{
	for candidate in a:candidates
		call filter(g:_yankround_cache, 'v:val!=#candidate.source__raw')
		let @" = @"==#candidate.word ? '' : @"
	endfor
endfunction
"}}}


"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo
if exists('s:save_cpo')| finish| endif
let s:save_cpo = &cpo| set cpo&vim
"=============================================================================
let s:CTRLP_BUILTINS = ctrlp#getvar('g:ctrlp_builtins')
"======================================
let s:ctrlp_yankround_var = {'lname': 'yankround', 'sname': 'ykrd', 'type': 'tabe', 'sort': 0, 'nolim': 1, 'opmul': 1}
let s:ctrlp_yankround_var.init = 'ctrlp#yankround#init()'
let s:ctrlp_yankround_var.accept = 'ctrlp#yankround#accept'
let s:ctrlp_yankround_var.wipe = 'ctrlp#yankround#wipe'
let g:ctrlp_ext_vars = add(get(g:, 'ctrlp_ext_vars', []), s:ctrlp_yankround_var)
unlet s:ctrlp_yankround_var
let s:index_id = s:CTRLP_BUILTINS + len(g:ctrlp_ext_vars)
function! ctrlp#yankround#id() "{{{
	return s:index_id
endfunction
"}}}
function! ctrlp#yankround#init() "{{{
	return map(copy(g:_yankround_cache), 's:_cache_to_ctrlpline(v:val)')
endfunction
"}}}
function! ctrlp#yankround#accept(action, str) "{{{
	if a:action=='t'
		return
	end
	call ctrlp#exit()
	let str = a:str
	let strlist = map(copy(g:_yankround_cache), 's:_cache_to_ctrlpline(v:val)')
	let idx = index(strlist, str)
	let [str, regtype] = yankround#_get_cache_and_regtype(idx)
	call setreg('"', str, regtype)
	if a:action=='e'
		exe 'norm! P'
	elseif a:action=='v'
		exe 'norm! p'
	end
endfunction
"}}}
function! ctrlp#yankround#wipe(entries) "{{{
	let strlist = map(copy(g:_yankround_cache), 's:_cache_to_ctrlpline(v:val)')
	for item in a:entries
		let idx = index(strlist, item)
		let removed = remove(g:_yankround_cache, idx)
	endfor
	let @" = @"==#substitute(removed, '^.\d*\t', '', '') ? '' : @"
	return ctrlp#yankround#init()
endfunction
"}}}
unlet s:CTRLP_BUILTINS

"======================================
function! s:_cache_to_ctrlpline(str) "{{{
	let entry = matchlist(a:str, "^\\(.\\d*\\)\t\\(.*\\)")
	return s:_change_regmodechar(entry[1]). "\t". strtrans(entry[2])
endfunction
"}}}
function! s:_change_regmodechar(char) "{{{
	return a:char==#'v' ? 'c' : a:char==#'V' ? 'l' : a:char
endfunction
"}}}

"=============================================================================
let &cpo = s:save_cpo| unlet s:save_cpo

if exists(':CtrlP')
	command! -nargs=0   CtrlPYankRound    call ctrlp#init(ctrlp#yankround#id())
end
endif
" }}}
nmap p <Plug>(yankround-p)
xmap p <Plug>(yankround-p)
nmap P <Plug>(yankround-P)
nmap <C-p> <Plug>(yankround-prev)
nmap <C-n> <Plug>(yankround-next)
let g:yankround_max_history=10
" }}}

" hybrid https://github.com/w0ng/vim-hybrid/ {{{
" File:       hybrid.vim
" Maintainer: Andrew Wong (w0ng)
" URL:        https://github.com/w0ng/vim-hybrid
" Modified:   27 Jan 2013 07:33 AM AEST
" License:    MIT

" Description:"{{{
" ----------------------------------------------------------------------------
" The default RGB colour palette is taken from Tomorrow-Night.vim:
" https://github.com/chriskempson/vim-tomorrow-theme
"
" The reduced RGB colour palette is taken from Codecademy's online editor:
" https://www.codecademy.com/learn
"
" The syntax highlighting scheme is taken from jellybeans.vim:
" https://github.com/nanotech/jellybeans.vim
"
" The is code taken from solarized.vim:
" https://github.com/altercation/vim-colors-solarized

"}}}
" Requirements And Recommendations:"{{{
" ----------------------------------------------------------------------------
" Requirements
"   - gVim 7.3+ on Linux, Mac and Windows.
"   - Vim 7.3+ on Linux and Mac, using a terminal that supports 256 colours.
"
" Due to the limited 256 palette, colours in Vim and gVim will still be slightly
" different.
"
" In order to have Vim use the same colours as gVim (the way this colour scheme
" is intended), it is recommended that you define the basic 16 colours in your
" terminal.
"
" For Linux users (rxvt-unicode, xterm):
"
" 1.  Add the default palette to ~/.Xresources:
"
"         https://gist.github.com/3278077
"
"     or alternatively, add the reduced contrast palette to ~/.Xresources:
"
"         https://gist.github.com/w0ng/16e33902508b4a0350ae
"
" 2.  Add to ~/.vimrc:
"
"         let g:hybrid_custom_term_colors = 1
"         let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette.
"         colorscheme hybrid
"
" For OSX users (iTerm):
"
" 1.  Import the default colour preset into iTerm:
"
"         https://raw.githubusercontent.com/w0ng/dotfiles/master/iterm2/hybrid.itermcolors
"
"     or alternatively, import the reduced contrast color preset into iTerm:
"
"         https://raw.githubusercontent.com/w0ng/dotfiles/master/iterm2/hybrid-reduced-contrast.itermcolors
"
" 2.  Add to ~/.vimrc:
"
"         let g:hybrid_custom_term_colors = 1
"         let g:hybrid_reduced_contrast = 1 " Remove this line if using the default palette.
"         colorscheme hybrid

"}}}
" Initialisation:"{{{
" ----------------------------------------------------------------------------

hi clear

if exists("syntax_on")
	syntax reset
endif

let s:style = &background

let g:colors_name = "hybrid"

"}}}
" GUI And Cterm Palettes:"{{{
" ----------------------------------------------------------------------------

let s:palette = {'gui' : {} , 'cterm' : {}}

if exists("g:hybrid_reduced_contrast") && g:hybrid_reduced_contrast == 1
	let s:gui_background = "#232c31"
	let s:gui_selection  = "#425059"
	let s:gui_line       = "#2d3c46"
	let s:gui_comment    = "#6c7a80"
else
	let s:gui_background = "#1d1f21"
	let s:gui_selection  = "#373b41"
	let s:gui_line       = "#282a2e"
	let s:gui_comment    = "#707880"
endif

let s:palette.gui.background = { 'dark' : s:gui_background , 'light' : "#e4e4e4" }
let s:palette.gui.foreground = { 'dark' : "#c5c8c6"        , 'light' : "#000000" }
let s:palette.gui.selection  = { 'dark' : s:gui_selection  , 'light' : "#bcbcbc" }
let s:palette.gui.line       = { 'dark' : s:gui_line       , 'light' : "#d0d0d0" }
let s:palette.gui.comment    = { 'dark' : s:gui_comment    , 'light' : "#5f5f5f" }
let s:palette.gui.red        = { 'dark' : "#cc6666"        , 'light' : "#5f0000" }
let s:palette.gui.orange     = { 'dark' : "#de935f"        , 'light' : "#875f00" }
let s:palette.gui.yellow     = { 'dark' : "#f0c674"        , 'light' : "#5f5f00" }
let s:palette.gui.green      = { 'dark' : "#b5bd68"        , 'light' : "#005f00" }
let s:palette.gui.aqua       = { 'dark' : "#8abeb7"        , 'light' : "#005f5f" }
let s:palette.gui.blue       = { 'dark' : "#81a2be"        , 'light' : "#00005f" }
let s:palette.gui.purple     = { 'dark' : "#b294bb"        , 'light' : "#5f005f" }
let s:palette.gui.window     = { 'dark' : "#303030"        , 'light' : "#9e9e9e" }
let s:palette.gui.darkcolumn = { 'dark' : "#1c1c1c"        , 'light' : "#808080" }
let s:palette.gui.addbg      = { 'dark' : "#5F875F"        , 'light' : "#d7ffd7" }
let s:palette.gui.addfg      = { 'dark' : "#d7ffaf"        , 'light' : "#005f00" }
let s:palette.gui.changebg   = { 'dark' : "#5F5F87"        , 'light' : "#d7d7ff" }
let s:palette.gui.changefg   = { 'dark' : "#d7d7ff"        , 'light' : "#5f005f" }
let s:palette.gui.delbg      = { 'dark' : "#cc6666"        , 'light' : "#ffd7d7" }
let s:palette.gui.darkblue   = { 'dark' : "#00005f"        , 'light' : "#d7ffd7" }
let s:palette.gui.darkcyan   = { 'dark' : "#005f5f"        , 'light' : "#005f00" }
let s:palette.gui.darkred    = { 'dark' : "#5f0000"        , 'light' : "#d7d7ff" }
let s:palette.gui.darkpurple = { 'dark' : "#5f005f"        , 'light' : "#5f005f" }

if exists("g:hybrid_custom_term_colors") && g:hybrid_custom_term_colors == 1
	let s:cterm_foreground = "15"  " White
	let s:cterm_selection  = "8"   " DarkGrey
	let s:cterm_line       = "0"   " Black
	let s:cterm_comment    = "7"   " LightGrey
	let s:cterm_red        = "9"   " LightRed
	let s:cterm_orange     = "3"   " DarkYellow
	let s:cterm_yellow     = "11"  " LightYellow
	let s:cterm_green      = "10"  " LightGreen
	let s:cterm_aqua       = "14"  " LightCyan
	let s:cterm_blue       = "12"  " LightBlue
	let s:cterm_purple     = "13"  " LightMagenta
	let s:cterm_delbg      = "9"   " LightRed
else
	let s:cterm_foreground = "250"
	let s:cterm_selection  = "237"
	let s:cterm_line       = "235"
	let s:cterm_comment    = "243"
	let s:cterm_red        = "167"
	let s:cterm_orange     = "173"
	let s:cterm_yellow     = "221"
	let s:cterm_green      = "143"
	let s:cterm_aqua       = "109"
	let s:cterm_blue       = "110"
	let s:cterm_purple     = "139"
	let s:cterm_delbg      = "167"
endif

let s:palette.cterm.background = { 'dark' : "234"              , 'light' : "254" }
let s:palette.cterm.foreground = { 'dark' : s:cterm_foreground , 'light' : "16"  }
let s:palette.cterm.window     = { 'dark' : "236"              , 'light' : "247" }
let s:palette.cterm.selection  = { 'dark' : s:cterm_selection  , 'light' : "250" }
let s:palette.cterm.line       = { 'dark' : s:cterm_line       , 'light' : "252" }
let s:palette.cterm.comment    = { 'dark' : s:cterm_comment    , 'light' : "59"  }
let s:palette.cterm.red        = { 'dark' : s:cterm_red        , 'light' : "52"  }
let s:palette.cterm.orange     = { 'dark' : s:cterm_orange     , 'light' : "94"  }
let s:palette.cterm.yellow     = { 'dark' : s:cterm_yellow     , 'light' : "58"  }
let s:palette.cterm.green      = { 'dark' : s:cterm_green      , 'light' : "22"  }
let s:palette.cterm.aqua       = { 'dark' : s:cterm_aqua       , 'light' : "23"  }
let s:palette.cterm.blue       = { 'dark' : s:cterm_blue       , 'light' : "17"  }
let s:palette.cterm.purple     = { 'dark' : s:cterm_purple     , 'light' : "53"  }
let s:palette.cterm.darkcolumn = { 'dark' : "234"              , 'light' : "244" }
let s:palette.cterm.addbg      = { 'dark' : "65"               , 'light' : "194" }
let s:palette.cterm.addfg      = { 'dark' : "193"              , 'light' : "22"  }
let s:palette.cterm.changebg   = { 'dark' : "60"               , 'light' : "189" }
let s:palette.cterm.changefg   = { 'dark' : "189"              , 'light' : "53"  }
let s:palette.cterm.delbg      = { 'dark' : s:cterm_delbg      , 'light' : "224" }
let s:palette.cterm.darkblue   = { 'dark' : "17"               , 'light' : "194" }
let s:palette.cterm.darkcyan   = { 'dark' : "24"               , 'light' : "22"  }
let s:palette.cterm.darkred    = { 'dark' : "52"               , 'light' : "189" }
let s:palette.cterm.darkpurple = { 'dark' : "53"               , 'light' : "53"  }

"}}}
" Formatting Options:"{{{
" ----------------------------------------------------------------------------
let s:none   = "NONE"
let s:t_none = "NONE"
let s:n      = "NONE"
let s:c      = ",undercurl"
let s:r      = ",reverse"
let s:s      = ",standout"
let s:b      = ",bold"
let s:u      = ",underline"
let s:i      = ",italic"

"}}}
" Highlighting Primitives:"{{{
" ----------------------------------------------------------------------------
function! s:build_prim(hi_elem, field)
	" Given a:hi_elem = bg, a:field = comment
	let l:vname = "s:" . a:hi_elem . "_" . a:field " s:bg_comment
	let l:gui_assign = "gui".a:hi_elem."=".s:palette.gui[a:field][s:style] " guibg=...
	let l:cterm_assign = "cterm".a:hi_elem."=".s:palette.cterm[a:field][s:style] " ctermbg=...
	exe "let " . l:vname . " = ' " . l:gui_assign . " " . l:cterm_assign . "'"
endfunction

let s:bg_none = ' guibg=NONE ctermbg=NONE'
call s:build_prim('bg', 'foreground')
call s:build_prim('bg', 'background')
call s:build_prim('bg', 'selection')
call s:build_prim('bg', 'line')
call s:build_prim('bg', 'comment')
call s:build_prim('bg', 'red')
call s:build_prim('bg', 'orange')
call s:build_prim('bg', 'yellow')
call s:build_prim('bg', 'green')
call s:build_prim('bg', 'aqua')
call s:build_prim('bg', 'blue')
call s:build_prim('bg', 'purple')
call s:build_prim('bg', 'window')
call s:build_prim('bg', 'darkcolumn')
call s:build_prim('bg', 'addbg')
call s:build_prim('bg', 'addfg')
call s:build_prim('bg', 'changebg')
call s:build_prim('bg', 'changefg')
call s:build_prim('bg', 'delbg')
call s:build_prim('bg', 'darkblue')
call s:build_prim('bg', 'darkcyan')
call s:build_prim('bg', 'darkred')
call s:build_prim('bg', 'darkpurple')

let s:fg_none = ' guifg=NONE ctermfg=NONE'
call s:build_prim('fg', 'foreground')
call s:build_prim('fg', 'background')
call s:build_prim('fg', 'selection')
call s:build_prim('fg', 'line')
call s:build_prim('fg', 'comment')
call s:build_prim('fg', 'red')
call s:build_prim('fg', 'orange')
call s:build_prim('fg', 'yellow')
call s:build_prim('fg', 'green')
call s:build_prim('fg', 'aqua')
call s:build_prim('fg', 'blue')
call s:build_prim('fg', 'purple')
call s:build_prim('fg', 'window')
call s:build_prim('fg', 'darkcolumn')
call s:build_prim('fg', 'addbg')
call s:build_prim('fg', 'addfg')
call s:build_prim('fg', 'changebg')
call s:build_prim('fg', 'changefg')
call s:build_prim('fg', 'darkblue')
call s:build_prim('fg', 'darkcyan')
call s:build_prim('fg', 'darkred')
call s:build_prim('fg', 'darkpurple')

exe "let s:fmt_none = ' gui=NONE".          " cterm=NONE".          " term=NONE"        ."'"
exe "let s:fmt_bold = ' gui=NONE".s:b.      " cterm=NONE".s:b.      " term=NONE".s:b    ."'"
exe "let s:fmt_bldi = ' gui=NONE".s:b.      " cterm=NONE".s:b.      " term=NONE".s:b    ."'"
exe "let s:fmt_undr = ' gui=NONE".s:u.      " cterm=NONE".s:u.      " term=NONE".s:u    ."'"
exe "let s:fmt_undb = ' gui=NONE".s:u.s:b.  " cterm=NONE".s:u.s:b.  " term=NONE".s:u.s:b."'"
exe "let s:fmt_undi = ' gui=NONE".s:u.      " cterm=NONE".s:u.      " term=NONE".s:u    ."'"
exe "let s:fmt_curl = ' gui=NONE".s:c.      " cterm=NONE".s:c.      " term=NONE".s:c    ."'"
exe "let s:fmt_ital = ' gui=NONE".s:i.      " cterm=NONE".s:i.      " term=NONE".s:i    ."'"
exe "let s:fmt_stnd = ' gui=NONE".s:s.      " cterm=NONE".s:s.      " term=NONE".s:s    ."'"
exe "let s:fmt_revr = ' gui=NONE".s:r.      " cterm=NONE".s:r.      " term=NONE".s:r    ."'"
exe "let s:fmt_revb = ' gui=NONE".s:r.s:b.  " cterm=NONE".s:r.s:b.  " term=NONE".s:r.s:b."'"

exe "let s:sp_none       = ' guisp=". s:none                            ."'"
exe "let s:sp_foreground = ' guisp=". s:palette.gui.foreground[s:style] ."'"
exe "let s:sp_background = ' guisp=". s:palette.gui.background[s:style] ."'"
exe "let s:sp_selection  = ' guisp=". s:palette.gui.selection[s:style]  ."'"
exe "let s:sp_line       = ' guisp=". s:palette.gui.line[s:style]       ."'"
exe "let s:sp_comment    = ' guisp=". s:palette.gui.comment[s:style]    ."'"
exe "let s:sp_red        = ' guisp=". s:palette.gui.red[s:style]        ."'"
exe "let s:sp_orange     = ' guisp=". s:palette.gui.orange[s:style]     ."'"
exe "let s:sp_yellow     = ' guisp=". s:palette.gui.yellow[s:style]     ."'"
exe "let s:sp_green      = ' guisp=". s:palette.gui.green[s:style]      ."'"
exe "let s:sp_aqua       = ' guisp=". s:palette.gui.aqua[s:style]       ."'"
exe "let s:sp_blue       = ' guisp=". s:palette.gui.blue[s:style]       ."'"
exe "let s:sp_purple     = ' guisp=". s:palette.gui.purple[s:style]     ."'"
exe "let s:sp_window     = ' guisp=". s:palette.gui.window[s:style]     ."'"
exe "let s:sp_addbg      = ' guisp=". s:palette.gui.addbg[s:style]      ."'"
exe "let s:sp_addfg      = ' guisp=". s:palette.gui.addfg[s:style]      ."'"
exe "let s:sp_changebg   = ' guisp=". s:palette.gui.changebg[s:style]   ."'"
exe "let s:sp_changefg   = ' guisp=". s:palette.gui.changefg[s:style]   ."'"
exe "let s:sp_darkblue   = ' guisp=". s:palette.gui.darkblue[s:style]   ."'"
exe "let s:sp_darkcyan   = ' guisp=". s:palette.gui.darkcyan[s:style]   ."'"
exe "let s:sp_darkred    = ' guisp=". s:palette.gui.darkred[s:style]    ."'"
exe "let s:sp_darkpurple = ' guisp=". s:palette.gui.darkpurple[s:style] ."'"

"}}}
" Vim Highlighting: (see :help highlight-groups)"{{{
" ----------------------------------------------------------------------------
exe "hi! ColorColumn"   .s:fg_none        .s:bg_line        .s:fmt_none
"   Conceal"
"   Cursor"
"   CursorIM"
exe "hi! CursorColumn"  .s:fg_none        .s:bg_line        .s:fmt_none
exe "hi! CursorLine"    .s:fg_none        .s:bg_line        .s:fmt_none
exe "hi! Directory"     .s:fg_blue        .s:bg_none        .s:fmt_none
exe "hi! DiffAdd"       .s:fg_addfg       .s:bg_addbg       .s:fmt_none
exe "hi! DiffChange"    .s:fg_changefg    .s:bg_changebg    .s:fmt_none
exe "hi! DiffDelete"    .s:fg_background  .s:bg_delbg       .s:fmt_none
exe "hi! DiffText"      .s:fg_background  .s:bg_blue        .s:fmt_none
exe "hi! ErrorMsg"      .s:fg_background  .s:bg_red         .s:fmt_stnd
exe "hi! VertSplit"     .s:fg_window      .s:bg_none        .s:fmt_none
exe "hi! Folded"        .s:fg_comment     .s:bg_darkcolumn  .s:fmt_none
exe "hi! FoldColumn"    .s:fg_none        .s:bg_darkcolumn  .s:fmt_none
exe "hi! SignColumn"    .s:fg_none        .s:bg_darkcolumn  .s:fmt_none
"   Incsearch"
exe "hi! LineNr"        .s:fg_selection   .s:bg_none        .s:fmt_none
exe "hi! CursorLineNr"  .s:fg_yellow      .s:bg_none        .s:fmt_none
exe "hi! MatchParen"    .s:fg_background  .s:bg_changebg    .s:fmt_none
exe "hi! ModeMsg"       .s:fg_green       .s:bg_none        .s:fmt_none
exe "hi! MoreMsg"       .s:fg_green       .s:bg_none        .s:fmt_none
exe "hi! NonText"       .s:fg_selection   .s:bg_none        .s:fmt_none
exe "hi! Pmenu"         .s:fg_foreground  .s:bg_selection   .s:fmt_none
exe "hi! PmenuSel"      .s:fg_foreground  .s:bg_selection   .s:fmt_revr
"   PmenuSbar"
"   PmenuThumb"
exe "hi! Question"      .s:fg_green       .s:bg_none        .s:fmt_none
exe "hi! Search"        .s:fg_background  .s:bg_yellow      .s:fmt_none
exe "hi! SpecialKey"    .s:fg_selection   .s:bg_none        .s:fmt_none
exe "hi! SpellCap"      .s:fg_blue        .s:bg_darkblue    .s:fmt_undr
exe "hi! SpellLocal"    .s:fg_aqua        .s:bg_darkcyan    .s:fmt_undr
exe "hi! SpellBad"      .s:fg_red         .s:bg_darkred     .s:fmt_undr
exe "hi! SpellRare"     .s:fg_purple      .s:bg_darkpurple  .s:fmt_undr
exe "hi! StatusLine"    .s:fg_comment     .s:bg_background  .s:fmt_revr
exe "hi! StatusLineNC"  .s:fg_window      .s:bg_comment     .s:fmt_revr
exe "hi! TabLine"       .s:fg_foreground  .s:bg_darkcolumn  .s:fmt_revr
"   TabLineFill"
"   TabLineSel"
exe "hi! Title"         .s:fg_yellow      .s:bg_none        .s:fmt_none
exe "hi! Visual"        .s:fg_none        .s:bg_selection   .s:fmt_none
"   VisualNos"
exe "hi! WarningMsg"    .s:fg_red         .s:bg_none        .s:fmt_none
" FIXME LongLineWarning to use variables instead of hardcoding
hi LongLineWarning  guifg=NONE        guibg=#371F1C     gui=underline ctermfg=NONE        ctermbg=NONE        cterm=underline
"   WildMenu"

" Use defined custom background colour for terminal Vim.
if !has('gui_running') && exists("g:hybrid_custom_term_colors") && g:hybrid_custom_term_colors == 1
	let s:bg_normal = s:bg_none
else
	let s:bg_normal = s:bg_background
endif
exe "hi! Normal"        .s:fg_foreground  .s:bg_normal      .s:fmt_none

"}}}
" Generic Syntax Highlighting: (see :help group-name)"{{{
" ----------------------------------------------------------------------------
exe "hi! Comment"         .s:fg_comment     .s:bg_none        .s:fmt_none

exe "hi! Constant"        .s:fg_red         .s:bg_none        .s:fmt_none
exe "hi! String"          .s:fg_green       .s:bg_none        .s:fmt_none
"   Character"
"   Number"
"   Boolean"
"   Float"

exe "hi! Identifier"      .s:fg_purple      .s:bg_none        .s:fmt_none
exe "hi! Function"        .s:fg_yellow      .s:bg_none        .s:fmt_none

exe "hi! Statement"       .s:fg_blue        .s:bg_none        .s:fmt_none
"   Conditional"
"   Repeat"
"   Label"
exe "hi! Operator"        .s:fg_aqua        .s:bg_none        .s:fmt_none
"   Keyword"
"   Exception"

exe "hi! PreProc"         .s:fg_aqua        .s:bg_none        .s:fmt_none
"   Include"
"   Define"
"   Macro"
"   PreCondit"

exe "hi! Type"            .s:fg_orange      .s:bg_none        .s:fmt_none
"   StorageClass"
exe "hi! Structure"       .s:fg_aqua        .s:bg_none        .s:fmt_none
"   Typedef"

exe "hi! Special"         .s:fg_green       .s:bg_none        .s:fmt_none
"   SpecialChar"
"   Tag"
"   Delimiter"
"   SpecialComment"
"   Debug"
"
exe "hi! Underlined"      .s:fg_blue        .s:bg_none        .s:fmt_none

exe "hi! Ignore"          .s:fg_none        .s:bg_none        .s:fmt_none

exe "hi! Error"           .s:fg_red         .s:bg_darkred     .s:fmt_undr

exe "hi! Todo"            .s:fg_addfg       .s:bg_none        .s:fmt_none

" Quickfix window highlighting
exe "hi! qfLineNr"        .s:fg_yellow      .s:bg_none        .s:fmt_none
"   qfFileName"
"   qfLineNr"
"   qfError"

"}}}
" Diff Syntax Highlighting:"{{{
" ----------------------------------------------------------------------------
" Diff
"   diffOldFile
"   diffNewFile
"   diffFile
"   diffOnly
"   diffIdentical
"   diffDiffer
"   diffBDiffer
"   diffIsA
"   diffNoEOL
"   diffCommon
hi! link diffRemoved Constant
"   diffChanged
hi! link diffAdded Special
"   diffLine
"   diffSubname
"   diffComment

"}}}
"
" This is needed for some reason: {{{

let &background = s:style

" }}}
" Legal:"{{{
" ----------------------------------------------------------------------------
" Copyright (c) 2011 Ethan Schoonover
" Copyright (c) 2009-2012 NanoTech
" Copyright (c) 2012 w0ng
"
" Permission is hereby granted, free of charge, to any per‐
" son obtaining a copy of this software and associated doc‐
" umentation files (the “Software”), to deal in the Soft‐
" ware without restriction, including without limitation
" the rights to use, copy, modify, merge, publish, distrib‐
" ute, sublicense, and/or sell copies of the Software, and
" to permit persons to whom the Software is furnished to do
" so, subject to the following conditions:
"
" The above copyright notice and this permission notice
" shall be included in all copies or substantial portions
" of the Software.
"
" THE SOFTWARE IS PROVIDED “AS IS”, WITHOUT WARRANTY OF ANY
" KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO
" THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICU‐
" LAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
" DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CON‐
" TRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CON‐
" NECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
" THE SOFTWARE.

" }}}
" }}}

" matchit https://github.com/vimtaku/hl_matchit.vim/ {{{
" plugin {{{
if exists('g:loaded_hl_matchit')
	finish
endif
let g:loaded_hl_matchit = 1

let s:save_cpo = &cpo
set cpo&vim

let s:SPEED_MOST_IMPORTANT = 1
let s:SPEED_DEFAULT = 2


if !exists('g:hl_matchit_hl_groupname')
	let g:hl_matchit_hl_groupname = 'cursorline'
endif
if !exists('g:hl_matchit_hl_priority')
	let g:hl_matchit_hl_priority = 0
endif
if !exists('g:hl_matchit_speed_level')
	let g:hl_matchit_speed_level = s:SPEED_DEFAULT
endif
if !exists('g:hl_matchit_cursor_wait')
	let g:hl_matchit_cursor_wait = 0.200
endif
if !exists('g:hl_matchit_allow_ft')
	let g:hl_matchit_allow_ft = ''
endif

if exists('g:hl_matchit_allow_ft_regexp')
	echoerr 'hl_matchit: g:hl_matchit_allow_ft_regexp is removed. use g:hl_matchit_allow_ft'
endif

com! HiMatch call hl_matchit#do_highlight()
com! NoHiMatch call hl_matchit#hide()
com! HiMatchOn call hl_matchit#enable()
com! HiMatchOff call hl_matchit#disable()

if exists('g:hl_matchit_enable_on_vim_startup') && g:hl_matchit_enable_on_vim_startup
	HiMatchOn
endif

let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" autoload {{{
scriptencoding utf-8
let s:save_cpo = &cpo
set cpo&vim

let s:SPEED_MOST_IMPORTANT = 1
let s:SPEED_DEFAULT = 2

let s:EXCEPT_ETERNAL_LOOP_COUNT = 30

let s:last_cursor_moved = reltime()

function! hl_matchit#enable()
	let ft = (exists('g:hl_matchit_allow_ft') && '' != g:hl_matchit_allow_ft) ?
				\ g:hl_matchit_allow_ft : '*'
	augroup hl_matchit
		au!
		exec 'au FileType' ft 'call hl_matchit#enable_buffer()'
	augroup END
	doautoall hl_matchit FileType
endfunction

function! hl_matchit#disable()
	augroup hl_matchit
		au!
		au User * call hl_matchit#hide()
	augroup END
	doautoall hl_matchit User
	au! hl_matchit User *
endfunction

function! hl_matchit#enable_buffer()
	call hl_matchit#disable_buffer()
	augroup hl_matchit
		if 0 < g:hl_matchit_cursor_wait
			au CursorMoved,CursorHold <buffer> call hl_matchit#do_highlight_lazy()
		else
			au CursorMoved <buffer> call hl_matchit#do_highlight()
		endif
	augroup END
	call hl_matchit#do_highlight()
endfunction

function! hl_matchit#disable_buffer()
	augroup hl_matchit
		au! CursorMoved <buffer>
		au! CursorHold <buffer>
	augroup END
	call hl_matchit#hide()
endfunction

function! hl_matchit#hide()
	if exists('b:hl_matchit_current_match_id')
		try
			call matchdelete(b:hl_matchit_current_match_id)
		catch
		endtry
		unlet b:hl_matchit_current_match_id
	endif
endfunction

function! hl_matchit#do_highlight_lazy()
	let dt = str2float(reltimestr(reltime(s:last_cursor_moved)))
	if g:hl_matchit_cursor_wait < dt
		call hl_matchit#do_highlight()
	endif
	let s:last_cursor_moved = reltime()
endfunction

function! hl_matchit#do_highlight()
	if !exists('b:match_words')
		return
	endif

	call hl_matchit#hide()

	let l = getline('.')
	if g:hl_matchit_speed_level <= s:SPEED_MOST_IMPORTANT
		if l =~ '[(){}]'
			return
		endif
	endif
	let char = l[col('.')-1]

	if g:hl_matchit_speed_level <= s:SPEED_DEFAULT
		if char !~ '\w'
			return
		endif
	endif

	if foldclosed(line('.')) != -1
		return
	endif

	let restore_eventignore = &eventignore
	try
		set ei=all

		let wsv = winsaveview()
		let lcs = []

		let i = 0
		while 1
			if (i > s:EXCEPT_ETERNAL_LOOP_COUNT)
				let lcs = []
				break
			endif
			normal %
			let lc = {'line': line('.'), 'col': col('.')}
			if len(lcs) > 0 && lc.line == lcs[0].line && lc.col == lcs[0].col
				break
			endif
			call add(lcs, lc)
			let i = i+1
		endwhile

		"" temporary bug fix. when visual mode, Ctrl-v is not good...
		if s:is_visualmode()
			normal! gv
		endif

		if len(lcs) > 1
			let lcre = ''
			call map(lcs, '"\\%" . v:val.line . "l" . "\\%" . v:val.col . "c"')
			let lcre = join(lcs, '\|')
			let mw = split(b:match_words, ',\|:')
			let mw = filter(mw, 'v:val !~ "^[(){}[\\]]$"')
			if &filetype =~# 'html'
				" hack to improve html
				call insert(mw,  '<\_[^>]\+>')
			endif
			let mwre = '\%(' . join(mw, '\|') . '\)'
			let mwre = substitute(mwre, "'", "''", 'g')
			let pattern = '.*\%(' . lcre . '\).*\&' . mwre
			let b:hl_matchit_current_match_id =
						\ matchadd(g:hl_matchit_hl_groupname, pattern, g:hl_matchit_hl_priority)
		endif
		call winrestview(wsv)
	finally
		execute("set eventignore=" . restore_eventignore)
	endtry
endfun


function! s:is_visualmode()
	let mode = mode()
	if (mode == 'v' || mode == 'V' || mode == 'CTRL-V')
		return 1
	endif
	return 0
endfun


let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
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
" }}}

" autoft https://github.com/itchyny/vim-autoft/ {{{
" plugin {{{
" =============================================================================
" " Filename: plugin/autoft.vim
" " Author: itchyny
" " License: MIT License
" " Last Change: 2015/01/08 08:43:31.
" "
" =============================================================================

if exists('g:loaded_autoft') || v:version < 700
	finish
endif
let g:loaded_autoft = 1

let s:save_cpo = &cpo
set cpo&vim

augroup autoft
	autocmd!
	autocmd CursorHold,CursorHoldI * if &l:ft ==# '' | sil! cal
	autoft#set() | en
augroup END

let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
" autoload {{{
" =============================================================================
" Filename: autoload/autoft.vim
" Author: itchyny
" License: MIT License
" Last Change: 2018/03/01 23:06:34.
" =============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! autoft#set() abort
	if &l:filetype !=# '' || &l:buftype !=# '' && &l:buftype !=# 'nofile' || !get(b:, 'autoft_enable', get(g:, 'autoft_enable', 1))
		return
	endif
	try
		let save_cpo = &cpo
		set cpo&vim
		let maxline = min([max([get(g:, 'autoft_maxline', 10), 1]), line('$')])
		let maxcol = max([get(g:, 'autoft_maxcol', 80), 10]) - 1
		let lines = map(range(1, maxline), 'getline(v:val)[:(maxcol)]')
		if len(lines) == 1 && lines[0] ==# ''
			return
		endif
		let ftpat = {}
		for ftpat in get(g:, 'autoft_config', [])
			for line in lines
				if line =~# ftpat.pattern && ftpat.filetype !=# ''
					let &l:filetype = ftpat.filetype
					return
				endif
			endfor
		endfor
	catch
		call autoft#error(v:exception, ftpat)
	finally
		let &cpo = save_cpo
	endtry
endfunction

function! autoft#error(message, ftpat) abort
	let prefix = '[autoft]: '
	let filetype = has_key(a:ftpat, 'filetype') ? 'filetype: ' . a:ftpat.filetype : ''
	let pattern = has_key(a:ftpat, 'pattern') ? 'pattern: ' . a:ftpat.pattern : ''
	let message = 'message: ' . substitute(a:message, '^Vim[^:]*:', '', '')
	let error = prefix . join(filter([ filetype, pattern, message ], 'v:val !=# ""'), ', ')
	let s:messages = get(s:, 'messages', {})
	if has_key(s:messages, error)
		return
	endif
	let s:messages[error] = 1
	echohl ErrorMsg
	echom error
	echohl None
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" }}}
let g:autoft_config = [
			\ { 'filetype': 'html' , 'pattern': '<\%(!DOCTYPE\|html\|head\|script\)' },
			\ { 'filetype': 'c'    , 'pattern': '^\s*#\s*\%(include\|define\)\>' },
			\ { 'filetype': 'diff' , 'pattern': '^diff -' },
			\ { 'filetype': 'sh'   , 'pattern': '^#!.*\%(\<sh\>\|\<bash\>\)\s*$' },
			\ ]
" }}}

" abolish https://github.com/tpope/vim-abolish/ {{{
" abolish.vim - Language friendly searches, substitutions, and abbreviations
" Maintainer:   Tim Pope <http://tpo.pe/>
" Version:      1.1
" GetLatestVimScripts: 1545 1 :AutoInstall: abolish.vim

" Initialization {{{

if exists("g:loaded_abolish") || &cp || v:version < 700
	finish
endif
let g:loaded_abolish = 1

if !exists("g:abolish_save_file")
	if isdirectory(expand("~/.vim"))
		let g:abolish_save_file = expand("~/.vim/after/plugin/abolish.vim")
	elseif isdirectory(expand("~/vimfiles")) || has("win32")
		let g:abolish_save_file = expand("~/vimfiles/after/plugin/abolish.vim")
	else
		let g:abolish_save_file = expand("~/.vim/after/plugin/abolish.vim")
	endif
endif

" }}}
" Utility functions {{{

function! s:function(name)
	return function(substitute(a:name,'^s:',matchstr(expand('<sfile>'), '<SNR>\d\+_'),''))
endfunction

function! s:send(self,func,...)
	if type(a:func) == type('') || type(a:func) == type(0)
		let l:Func = get(a:self,a:func,'')
	else
		let l:Func = a:func
	endif
	let s = type(a:self) == type({}) ? a:self : {}
	if type(Func) == type(function('tr'))
		return call(Func,a:000,s)
	elseif type(Func) == type({}) && has_key(Func,'apply')
		return call(Func.apply,a:000,Func)
	elseif type(Func) == type({}) && has_key(Func,'call')
		return call(Func.call,a:000,s)
	elseif type(Func) == type('') && Func == '' && has_key(s,'function missing')
		return call('s:send',[s,'function missing',a:func] + a:000)
	else
		return Func
	endif
endfunction

let s:object = {}
function! s:object.clone(...)
	let sub = deepcopy(self)
	return a:0 ? extend(sub,a:1) : sub
endfunction

if !exists("g:Abolish")
	let Abolish = {}
endif
call extend(Abolish, s:object, 'force')
call extend(Abolish, {'Coercions': {}}, 'keep')

function! s:throw(msg)
	let v:errmsg = a:msg
	throw "Abolish: ".a:msg
endfunction

function! s:words()
	let words = []
	let lnum = line('w0')
	while lnum <= line('w$')
		let line = getline(lnum)
		let col = 0
		while match(line,'\<\k\k\+\>',col) != -1
			let words += [matchstr(line,'\<\k\k\+\>',col)]
			let col = matchend(line,'\<\k\k\+\>',col)
		endwhile
		let lnum += 1
	endwhile
	return words
endfunction

function! s:extractopts(list,opts)
	let i = 0
	while i < len(a:list)
		if a:list[i] =~ '^-[^=]' && has_key(a:opts,matchstr(a:list[i],'-\zs[^=]*'))
			let key   = matchstr(a:list[i],'-\zs[^=]*')
			let value = matchstr(a:list[i],'=\zs.*')
			if type(get(a:opts,key)) == type([])
				let a:opts[key] += [value]
			elseif type(get(a:opts,key)) == type(0)
				let a:opts[key] = 1
			else
				let a:opts[key] = value
			endif
		else
			let i += 1
			continue
		endif
		call remove(a:list,i)
	endwhile
	return a:opts
endfunction

" }}}
" Dictionary creation {{{

function! s:mixedcase(word)
	return substitute(s:camelcase(a:word),'^.','\u&','')
endfunction

function! s:camelcase(word)
	let word = substitute(a:word, '-', '_', 'g')
	if word !~# '_' && word =~# '\l'
		return substitute(word,'^.','\l&','')
	else
		return substitute(word,'\C\(_\)\=\(.\)','\=submatch(1)==""?tolower(submatch(2)) : toupper(submatch(2))','g')
	endif
endfunction

function! s:snakecase(word)
	let word = substitute(a:word,'::','/','g')
	let word = substitute(word,'\(\u\+\)\(\u\l\)','\1_\2','g')
	let word = substitute(word,'\(\l\|\d\)\(\u\)','\1_\2','g')
	let word = substitute(word,'[.-]','_','g')
	let word = tolower(word)
	return word
endfunction

function! s:uppercase(word)
	return toupper(s:snakecase(a:word))
endfunction

function! s:dashcase(word)
	return substitute(s:snakecase(a:word),'_','-','g')
endfunction

function! s:spacecase(word)
	return substitute(s:snakecase(a:word),'_',' ','g')
endfunction

function! s:dotcase(word)
	return substitute(s:snakecase(a:word),'_','.','g')
endfunction

function! s:titlecase(word)
	return substitute(s:spacecase(a:word), '\(\<\w\)','\=toupper(submatch(1))','g')
endfunction

call extend(Abolish, {
			\ 'camelcase':  s:function('s:camelcase'),
			\ 'mixedcase':  s:function('s:mixedcase'),
			\ 'snakecase':  s:function('s:snakecase'),
			\ 'uppercase':  s:function('s:uppercase'),
			\ 'dashcase':   s:function('s:dashcase'),
			\ 'dotcase':    s:function('s:dotcase'),
			\ 'spacecase':  s:function('s:spacecase'),
			\ 'titlecase':  s:function('s:titlecase')
			\ }, 'keep')

function! s:create_dictionary(lhs,rhs,opts)
	let dictionary = {}
	let i = 0
	let expanded = s:expand_braces({a:lhs : a:rhs})
	for [lhs,rhs] in items(expanded)
		if get(a:opts,'case',1)
			let dictionary[s:mixedcase(lhs)] = s:mixedcase(rhs)
			let dictionary[tolower(lhs)] = tolower(rhs)
			let dictionary[toupper(lhs)] = toupper(rhs)
		endif
		let dictionary[lhs] = rhs
	endfor
	let i += 1
	return dictionary
endfunction

function! s:expand_braces(dict)
	let new_dict = {}
	for [key,val] in items(a:dict)
		if key =~ '{.*}'
			let redo = 1
			let [all,kbefore,kmiddle,kafter;crap] = matchlist(key,'\(.\{-\}\){\(.\{-\}\)}\(.*\)')
			let [all,vbefore,vmiddle,vafter;crap] = matchlist(val,'\(.\{-\}\){\(.\{-\}\)}\(.*\)') + ["","","",""]
			if all == ""
				let [vbefore,vmiddle,vafter] = [val, ",", ""]
			endif
			let targets      = split(kmiddle,',',1)
			let replacements = split(vmiddle,',',1)
			if replacements == [""]
				let replacements = targets
			endif
			for i in range(0,len(targets)-1)
				let new_dict[kbefore.targets[i].kafter] = vbefore.replacements[i%len(replacements)].vafter
			endfor
		else
			let new_dict[key] = val
		endif
	endfor
	if exists("redo")
		return s:expand_braces(new_dict)
	else
		return new_dict
	endif
endfunction

" }}}
" Abolish Dispatcher {{{

function! s:SubComplete(A,L,P)
	if a:A =~ '^[/?]\k\+$'
		let char = strpart(a:A,0,1)
		return join(map(s:words(),'char . v:val'),"\n")
	elseif a:A =~# '^\k\+$'
		return join(s:words(),"\n")
	endif
endfunction

function! s:Complete(A,L,P)
	" Vim bug: :Abolish -<Tab> calls this function with a:A equal to 0
	if a:A =~# '^[^/?-]' && type(a:A) != type(0)
		return join(s:words(),"\n")
	elseif a:L =~# '^\w\+\s\+\%(-\w*\)\=$'
		return "-search\n-substitute\n-delete\n-buffer\n-cmdline\n"
	elseif a:L =~# ' -\%(search\|substitute\)\>'
		return "-flags="
	else
		return "-buffer\n-cmdline"
	endif
endfunction

let s:commands = {}
let s:commands.abstract = s:object.clone()

function! s:commands.abstract.dispatch(bang,line1,line2,count,args)
	return self.clone().go(a:bang,a:line1,a:line2,a:count,a:args)
endfunction

function! s:commands.abstract.go(bang,line1,line2,count,args)
	let self.bang = a:bang
	let self.line1 = a:line1
	let self.line2 = a:line2
	let self.count = a:count
	return self.process(a:bang,a:line1,a:line2,a:count,a:args)
endfunction

function! s:dispatcher(bang,line1,line2,count,args)
	let i = 0
	let args = copy(a:args)
	let command = s:commands.abbrev
	while i < len(args)
		if args[i] =~# '^-\w\+$' && has_key(s:commands,matchstr(args[i],'-\zs.*'))
			let command = s:commands[matchstr(args[i],'-\zs.*')]
			call remove(args,i)
			break
		endif
		let i += 1
	endwhile
	try
		return command.dispatch(a:bang,a:line1,a:line2,a:count,args)
	catch /^Abolish: /
		echohl ErrorMsg
		echo   v:errmsg
		echohl NONE
		return ""
	endtry
endfunction

" }}}
" Subvert Dispatcher {{{

function! s:subvert_dispatcher(bang,line1,line2,count,args)
	try
		return s:parse_subvert(a:bang,a:line1,a:line2,a:count,a:args)
	catch /^Subvert: /
		echohl ErrorMsg
		echo   v:errmsg
		echohl NONE
		return ""
	endtry
endfunction

function! s:parse_subvert(bang,line1,line2,count,args)
	if a:args =~ '^\%(\w\|$\)'
		let args = (a:bang ? "!" : "").a:args
	else
		let args = a:args
	endif
	let separator = matchstr(args,'^.')
	let split = split(args,separator,1)[1:]
	if a:count || split == [""]
		return s:parse_substitute(a:bang,a:line1,a:line2,a:count,split)
	elseif len(split) == 1
		return s:find_command(separator,"",split[0])
	elseif len(split) == 2 && split[1] =~# '^[A-Za-z]*n[A-Za-z]*$'
		return s:parse_substitute(a:bang,a:line1,a:line2,a:count,[split[0],"",split[1]])
	elseif len(split) == 2 && split[1] =~# '^[A-Za-z]*\%([+-]\d\+\)\=$'
		return s:find_command(separator,split[1],split[0])
	elseif len(split) >= 2 && split[1] =~# '^[A-Za-z]* '
		let flags = matchstr(split[1],'^[A-Za-z]*')
		let rest = matchstr(join(split[1:],separator),' \zs.*')
		return s:grep_command(rest,a:bang,flags,split[0])
	elseif len(split) >= 2 && separator == ' '
		return s:grep_command(join(split[1:],' '),a:bang,"",split[0])
	else
		return s:parse_substitute(a:bang,a:line1,a:line2,a:count,split)
	endif
endfunction

function! s:normalize_options(flags)
	if type(a:flags) == type({})
		let opts = a:flags
		let flags = get(a:flags,"flags","")
	else
		let opts = {}
		let flags = a:flags
	endif
	if flags =~# 'w'
		let opts.boundaries = 2
	elseif flags =~# 'v'
		let opts.boundaries = 1
	elseif !has_key(opts,'boundaries')
		let opts.boundaries = 0
	endif
	let opts.case = (flags !~# 'I' ? get(opts,'case',1) : 0)
	let opts.flags = substitute(flags,'\C[avIiw]','','g')
	return opts
endfunction

" }}}
" Searching {{{

function! s:subesc(pattern)
	return substitute(a:pattern,'[][\\/.*+?~%()&]','\\&','g')
endfunction

function! s:sort(a,b)
	if a:a ==? a:b
		return a:a == a:b ? 0 : a:a > a:b ? 1 : -1
	elseif strlen(a:a) == strlen(a:b)
		return a:a >? a:b ? 1 : -1
	else
		return strlen(a:a) < strlen(a:b) ? 1 : -1
	endif
endfunction

function! s:pattern(dict,boundaries)
	if a:boundaries == 2
		let a = '<'
		let b = '>'
	elseif a:boundaries
		let a = '%(<|_@<=|[[:lower:]]@<=[[:upper:]]@=)'
		let b =  '%(>|_@=|[[:lower:]]@<=[[:upper:]]@=)'
	else
		let a = ''
		let b = ''
	endif
	return '\v\C'.a.'%('.join(map(sort(keys(a:dict),function('s:sort')),'s:subesc(v:val)'),'|').')'.b
endfunction

function! s:egrep_pattern(dict,boundaries)
	if a:boundaries == 2
		let a = '\<'
		let b = '\>'
	elseif a:boundaries
		let a = '(\<\|_)'
		let b = '(\>\|_\|[[:upper:]][[:lower:]])'
	else
		let a = ''
		let b = ''
	endif
	return a.'('.join(map(sort(keys(a:dict),function('s:sort')),'s:subesc(v:val)'),'\|').')'.b
endfunction

function! s:c()
	call histdel('search',-1)
	return ""
endfunction

function! s:find_command(cmd,flags,word)
	let opts = s:normalize_options(a:flags)
	let dict = s:create_dictionary(a:word,"",opts)
	" This is tricky.  If we use :/pattern, the search drops us at the
	" beginning of the line, and we can't use position flags (e.g., /foo/e).
	" If we use :norm /pattern, we leave ourselves vulnerable to "press enter"
	" prompts (even with :silent).
	let cmd = (a:cmd =~ '[?!]' ? '?' : '/')
	let @/ = s:pattern(dict,opts.boundaries)
	if opts.flags == "" || !search(@/,'n')
		return "norm! ".cmd."\<CR>"
	elseif opts.flags =~ ';[/?]\@!'
		call s:throw("E386: Expected '?' or '/' after ';'")
	else
		return "exe 'norm! ".cmd.cmd.opts.flags."\<CR>'|call histdel('search',-1)"
		return ""
	endif
endfunction

function! s:grep_command(args,bang,flags,word)
	let opts = s:normalize_options(a:flags)
	let dict = s:create_dictionary(a:word,"",opts)
	if &grepprg == "internal"
		let lhs = "'".s:pattern(dict,opts.boundaries)."'"
	else
		let lhs = "-E '".s:egrep_pattern(dict,opts.boundaries)."'"
	endif
	return "grep".(a:bang ? "!" : "")." ".lhs." ".a:args
endfunction

let s:commands.search = s:commands.abstract.clone()
let s:commands.search.options = {"word": 0, "variable": 0, "flags": ""}

function! s:commands.search.process(bang,line1,line2,count,args)
	call s:extractopts(a:args,self.options)
	if self.options.word
		let self.options.flags .= "w"
	elseif self.options.variable
		let self.options.flags .= "v"
	endif
	let opts = s:normalize_options(self.options)
	if len(a:args) > 1
		return s:grep_command(join(a:args[1:]," "),a:bang,opts,a:args[0])
	elseif len(a:args) == 1
		return s:find_command(a:bang ? "!" : " ",opts,a:args[0])
	else
		call s:throw("E471: Argument required")
	endif
endfunction

" }}}
" Substitution {{{

function! Abolished()
	return get(g:abolish_last_dict,submatch(0),submatch(0))
endfunction

function! s:substitute_command(cmd,bad,good,flags)
	let opts = s:normalize_options(a:flags)
	let dict = s:create_dictionary(a:bad,a:good,opts)
	let lhs = s:pattern(dict,opts.boundaries)
	let g:abolish_last_dict = dict
	return a:cmd.'/'.lhs.'/\=Abolished()'."/".opts.flags
endfunction

function! s:parse_substitute(bang,line1,line2,count,args)
	if get(a:args,0,'') =~ '^[/?'']'
		let separator = matchstr(a:args[0],'^.')
		let args = split(join(a:args,' '),separator,1)
		call remove(args,0)
	else
		let args = a:args
	endif
	if len(args) < 2
		call s:throw("E471: Argument required")
	elseif len(args) > 3
		call s:throw("E488: Trailing characters")
	endif
	let [bad,good,flags] = (args + [""])[0:2]
	if a:count == 0
		let cmd = "substitute"
	else
		let cmd = a:line1.",".a:line2."substitute"
	endif
	return s:substitute_command(cmd,bad,good,flags)
endfunction

let s:commands.substitute = s:commands.abstract.clone()
let s:commands.substitute.options = {"word": 0, "variable": 0, "flags": "g"}

function! s:commands.substitute.process(bang,line1,line2,count,args)
	call s:extractopts(a:args,self.options)
	if self.options.word
		let self.options.flags .= "w"
	elseif self.options.variable
		let self.options.flags .= "v"
	endif
	let opts = s:normalize_options(self.options)
	if len(a:args) <= 1
		call s:throw("E471: Argument required")
	else
		let good = join(a:args[1:],"")
		let cmd = a:bang ? "." : "%"
		return s:substitute_command(cmd,a:args[0],good,self.options)
	endif
endfunction

" }}}
" Abbreviations {{{

function! s:badgood(args)
	let words = filter(copy(a:args),'v:val !~ "^-"')
	call filter(a:args,'v:val =~ "^-"')
	if empty(words)
		call s:throw("E471: Argument required")
	elseif !empty(a:args)
		call s:throw("Unknown argument: ".a:args[0])
	endif
	let [bad; words] = words
	return [bad, join(words," ")]
endfunction

function! s:abbreviate_from_dict(cmd,dict)
	for [lhs,rhs] in items(a:dict)
		exe a:cmd lhs rhs
	endfor
endfunction

let s:commands.abbrev     = s:commands.abstract.clone()
let s:commands.abbrev.options = {"buffer":0,"cmdline":0,"delete":0}
function! s:commands.abbrev.process(bang,line1,line2,count,args)
	let args = copy(a:args)
	call s:extractopts(a:args,self.options)
	if self.options.delete
		let cmd = "unabbrev"
		let good = ""
	else
		let cmd = "noreabbrev"
	endif
	if !self.options.cmdline
		let cmd = "i" . cmd
	endif
	if self.options.delete
		let cmd = "silent! ".cmd
	endif
	if self.options.buffer
		let cmd = cmd . " <buffer>"
	endif
	let [bad, good] = s:badgood(a:args)
	if substitute(bad, '[{},]', '', 'g') !~# '^\k*$'
		call s:throw("E474: Invalid argument (not a keyword: ".string(bad).")")
	endif
	if !self.options.delete && good == ""
		call s:throw("E471: Argument required".a:args[0])
	endif
	let dict = s:create_dictionary(bad,good,self.options)
	call s:abbreviate_from_dict(cmd,dict)
	if a:bang
		let i = 0
		let str = "Abolish ".join(args," ")
		let file = g:abolish_save_file
		if !isdirectory(fnamemodify(file,':h'))
			call mkdir(fnamemodify(file,':h'),'p')
		endif

		if filereadable(file)
			let old = readfile(file)
		else
			let old = ["\" Exit if :Abolish isn't available.","if !exists(':Abolish')","    finish","endif",""]
		endif
		call writefile(old + [str],file)
	endif
	return ""
endfunction

let s:commands.delete   = s:commands.abbrev.clone()
let s:commands.delete.options.delete = 1

" }}}
" Maps {{{

function! s:unknown_coercion(letter,word)
	return a:word
endfunction

call extend(Abolish.Coercions, {
			\ 'c': Abolish.camelcase,
			\ 'm': Abolish.mixedcase,
			\ 's': Abolish.snakecase,
			\ '_': Abolish.snakecase,
			\ 'u': Abolish.uppercase,
			\ 'U': Abolish.uppercase,
			\ '-': Abolish.dashcase,
			\ 'k': Abolish.dashcase,
			\ '.': Abolish.dotcase,
			\ ' ': Abolish.spacecase,
			\ 't': Abolish.titlecase,
			\ "function missing": s:function("s:unknown_coercion")
			\}, "keep")

function! s:coerce(type) abort
	if a:type !~# '^\%(line\|char\|block\)'
		let s:transformation = a:type
		let &opfunc = matchstr(expand('<sfile>'), '<SNR>\w*')
		return 'g@'
	endif
	let selection = &selection
	let clipboard = &clipboard
	try
		set selection=inclusive clipboard-=unnamed clipboard-=unnamedplus
		let regbody = getreg('"')
		let regtype = getregtype('"')
		let c = v:count1
		while c > 0
			let c -= 1
			if a:type ==# 'line'
				let move = "'[V']"
			elseif a:type ==# 'block'
				let move = "`[\<C-V>`]"
			else
				let move = "`[v`]"
			endif
			silent exe 'normal!' move.'y'
			let word = @@
			let @@ = s:send(g:Abolish.Coercions,s:transformation,word)
			if !exists('begin')
				let begin = getpos("'[")
			endif
			if word !=# @@
				let changed = 1
				exe 'normal!' move.'p'
			endif
		endwhile
		call setreg('"',regbody,regtype)
		call setpos("'[",begin)
		call setpos(".",begin)
	finally
		let &selection = selection
		let &clipboard = clipboard
	endtry
endfunction

nnoremap <expr> <Plug>(abolish-coerce) <SID>coerce(nr2char(getchar()))
nnoremap <expr> <Plug>(abolish-coerce) <SID>coerce(nr2char(getchar()))
nnoremap <expr> <plug>(abolish-coerce-word) <SID>coerce(nr2char(getchar())).'iw'

" }}}

if !exists("g:abolish_no_mappings") || ! g:abolish_no_mappings
	nmap cr  <Plug>(abolish-coerce-word)
endif

command! -nargs=+ -bang -bar -range=0 -complete=custom,s:Complete Abolish
			\ :exec s:dispatcher(<bang>0,<line1>,<line2>,<count>,[<f-args>])
command! -nargs=1 -bang -bar -range=0 -complete=custom,s:SubComplete Subvert
			\ :exec s:subvert_dispatcher(<bang>0,<line1>,<line2>,<count>,<q-args>)
if exists(':S') != 2
	command -nargs=1 -bang -bar -range=0 -complete=custom,s:SubComplete S
				\ :exec s:subvert_dispatcher(<bang>0,<line1>,<line2>,<count>,<q-args>)
endif

nnoremap / :S/
nnoremap [Space]s :<C-u>%Subvert/
vnoremap [Space]s :Subvert/

" }}}

" autodate https://github.com/vim-scripts/autodate.vim/ {{{
" vi:set ts=8 sts=2 sw=2 tw=0:
"
" autodate.vim - A plugin to update time stamps automatically
"
" Maintainer:	MURAOKA Taro <koron@tka.att.ne.jp>
" Last Change:	24-Jun-2003.

" Description:
" Command:
"   :Autodate	    Manually autodate.
"   :AutodateON	    Turn on autodate in current buffer (default).
"   :AutodateOFF    Turn off autodate in current buffer.
"
" Options:
"   Each global variable (option) is overruled by buffer variable (what
"   starts with "b:").
"
"   'autodate_format'
"	Format string used for time stamps.  See |strftime()| for details.
"	See MonthnameString() for special extension of format.
"	Default: '%d-%3m-%Y'
"
"   'autodate_lines'
"	The number of lines searched for the existence of a time stamp when
"	writing a buffer.  The search range will be from top of buffer (or
"	line 'autodate_start_line') to 'autodate_lines' lines below.  The
"	bigger value you have, the longer it'll take to search words.  You
"	can expect to improve performance by decreasing the value of this
"	option.
"	Default: 50
"
"   'autodate_start_line'
"	Line number to start searching for time stamps when writing buffer
"	to file.
"	If minus, line number is counted from the end of file.
"	Default: 1
"
"   'autodate_keyword_pre'
"	A prefix pattern (see |pattern| for details) which denotes time
"	stamp's location.  If empty, default value will be used.
"	Default: '\cLast Change:'
"
"   'autodate_keyword_post'
"	A postfix pattern which denotes time stamp's location.  If empty,
"	default value will be used.
"	Default: '\.'
"
" Usage:
"   Write a line as below (case ignored) somewhere in the first 50 lines of
"   a buffer:
"	Last Change: .
"   When writing the buffer to a file, this line will be modified and a time
"   stamp will be inserted automatically.  Example:
"	Last Change: 11-May-2002.
"
"   You can execute :Autodate command to update time stamps manually.  The
"   range of lines which looks for a time stamp can also be specified.  When
"   no range is given, the command will be applied to the current line.
"   Example:
"	:%Autodate		" Whole file
"	:\<,\>Autodate		" Range selected by visual mode
"	:Autodate		" Current cursor line
"
"   The format of the time stamp to insert can be specified by
"   'autodate_format' option.  See |strftime()| (vim script function) for
"   details.  Sample format settings and the corresponding outputs are show
"   below.
"	FORMAT: %Y/%m/%d	OUTPUT: 2001/12/24
"	FORMAT: %H:%M:%S	OUTPUT: 10:06:32
"	FORMAT: %y%m%d-%H%M	OUTPUT: 011224-1006
"
"   Autodate.vim determines where to insert a time stamp by looking for a
"   KEYWORD.  A keyword consists of a PREFIX and a POSTFIX part, and they
"   can be set by 'autodate_keyword_pre' and 'autodate_keyword_post'
"   options, respectively.  If you set these values as below in your .vimrc:
"	:let autodate_format = ': %Y/%m/%d %H:%M:%S '
"	:let autodate_keyword_pre  = '\$Date'
"	:let autodate_keyword_post = '\$'
"   They will function like $Date$ in cvs.  Example:
"	$Date: 2001/12/24 10:06:32 $
"
"   Just another application. To insert a time stamp between '<!--DATE-->'
"   when writing HTML, try below:
"	:let b:autodate_keyword_pre = '<!--DATE-->'
"	:let b:autodate_keyword_post = '<!--DATE-->'
"   It will be useful if to put these lines in your ftplugin/html.vim.
"   Example:
"	<!--DATE-->24-Dec-2001<!--DATE-->
"
"   In addition, priority is given to a buffer local option (what starts in
"   b:) about all the options of autodate.
"
"
" To make vim NOT TO LOAD this plugin, write next line in your .vimrc:
"	:let plugin_autodate_disable = 1

" Japanese Description:
" コマンド:
"   :Autodate	    手動でタイムスタンプ更新
"   :AutodateON	    現在のバッファの自動更新を有効化
"   :AutodateOFF    現在のバッファの自動更新を無効化
"
" オプション: (それぞれのオプションはバッファ版(b:)が優先される)
"
"   'autodate_format'
"	タイムスタンプに使用されるフォーマット文字列。フォーマットの詳細は
"	|strftime()|を参照。フォーマットへの独自拡張についてはMonthnameString()
"	を参照。省略値: '%d-%3m-%Y'
"
"   'autodate_lines'
"	保存時にタイムスタンプの存在をチェックする行数。増やせば増やすほど
"	キーワードを検索するために時間がかかり動作が遅くなる。逆に遅いと感じ
"	たときには小さな値を設定すればパフォーマンスの改善が期待できる。
"	省略値: 50
"
"   'autodate_keyword_pre'
"	タイムスタンプの存在を示す前置キーワード(正規表現)。必須。空文字列を
"	指定すると省略値が使われる。省略値: '\cLast Change:'
"
"   'autodate_keyword_post'
"	タイムスタンプの存在を示す後置キーワード(正規表現)。必須。空文字列を
"	指定すると省略値が使われる。省略値: '\.'
"
" 使用法:
"   ファイルの先頭から50行以内に
"	Last Change: .
"   と書いた行(大文字小文字は区別しません)を用意すると、ファイルの保存(:w)時
"   に自動的にその時刻(タイムスタンプ)が挿入されます。結果例:
"	Last Change: 11-May-2002.
"
"   Exコマンドの:Autodateを実行することで手動でタイムスタンプの更新が行なえ
"   ます。その際にタイムスタンプを探す範囲を指定することもできます。特に範囲
"   を指定しなければカーソルのある行が対象になります。例:
"	:%Autodate		" ファイル全体
"	:\<,\>Autodate		" ビジュアル選択領域
"	:Autodate		" 現在カーソルのある行
"
"   挿入するタイムスタンプの書式はオプション'autodate_format'で指定すること
"   ができます。詳細はVimスクリプト関数|strftime()|の説明に従います。以下に
"   書式とその出力の例を示します:
"	書式: %Y/%m/%d		出力: 2001/12/24
"	書式: %H:%M:%S		出力: 10:06:32
"	書式: %y%m%d-%H%M	出力: 011224-1006
"
"   autodate.vimはキーワードを探すことでタイムスタンプを挿入すべき位置を決定
"   しています。キーワードは前置部と後置部からなり、それぞれオプションの
"   'autodate_keyword_pre'と'autodate_keyword_post'を設定することで変更でき
"   ます。個人設定ファイル(_vimrc)で次のように設定すると:
"	:let autodate_format = ': %Y/%m/%d %H:%M:%S '
"	:let autodate_keyword_pre  = '\$Date'
"	:let autodate_keyword_post = '\$'
"   cvsにおける$Date$のように動作します。例:
"	$Date: 2001/12/24 10:06:32 $
"
"   応用としてHTMLを記述する際に<!--DATE-->で囲まれた中にタイムスタンプを挿
"   入させたい場合には:
"	:let b:autodate_keyword_pre = '<!--DATE-->'
"	:let b:autodate_keyword_post = '<!--DATE-->'
"   と指定します。ftplugin/html.vimで設定すると便利でしょう。例:
"	<!--DATE-->24-Dec-2001<!--DATE-->
"
"   なおautodateの総てのオプションについて、バッファローカルオプション(b:で
"   始まるもの)が優先されます。
"
" このプラグインを読込みたくない時は.vimrcに次のように書くこと:
"	:let plugin_autodate_disable = 1

if exists('plugin_autodate_disable')
	finish
endif
let s:debug = 0

"---------------------------------------------------------------------------
"				    Options

"
" 'autodate_format'
"
if !exists('autodate_format')
	let g:autodate_format = '%d-%3m-%Y'
endif

"
" 'autodate_lines'
"
if !exists('autodate_lines')
	let g:autodate_lines = 50
endif

"
" 'autodate_start_line'
"
if !exists('autodate_start_line')
	let g:autodate_start_line = 1
endif

"
" 'autodate_keyword_pre'
"
if !exists('autodate_keyword_pre')
	let g:autodate_keyword_pre = '\cLast Change:'
endif

"
" 'autodate_keyword_post'
"
if !exists('autodate_keyword_post')
	let g:autodate_keyword_post = '\.'
endif

"---------------------------------------------------------------------------
"				    Mappings

command! -range Autodate call <SID>Autodate(<line1>, <line2>)
command! AutodateOFF let b:autodate_disable = 1
command! AutodateON let b:autodate_disable = 0
if has("autocmd")
	augroup Autodate
		au!
		autocmd BufUnload,FileWritePre,BufWritePre * call <SID>Autodate()
	augroup END
endif " has("autocmd")

"---------------------------------------------------------------------------
"				 Implementation

"
" Autodate([{firstline} [, {lastline}]])
"
"   {firstline}と{lastline}で指定された範囲について、タイムスタンプの自動
"   アップデートを行なう。{firstline}が省略された場合はファイルの先頭、
"   {lastline}が省略された場合は{firstline}から'autodate_lines'行の範囲が対
"   象になる。
"
function! s:Autodate(...)
	" Check enable
	if (exists('b:autodate_disable') && b:autodate_disable != 0) || &modified == 0
		return
	endif

	" Verify {firstline}
	if a:0 > 0 && a:1 > 0
		let firstline = a:1
	else
		let firstline = s:GetAutodateStartLine()
	endif

	" Verify {lastline}
	if a:0 > 1 && a:2 <= line('$')
		let lastline = a:2
	else
		let lastline = firstline + s:GetAutodateLines() - 1
		" Range check
		if lastline > line('$')
			let lastline = line('$')
		endif
	endif

	if firstline <= lastline
		call s:AutodateStub(firstline, lastline)
	endif
endfunction

"
" GetAutodateStartLine()
"
"   探索開始点を取得する
"
function! s:GetAutodateStartLine()
	let retval = 1
	if exists('b:autodate_start_line')
		let retval = b:autodate_start_line
	elseif exists('g:autodate_start_line')
		let retval = g:autodate_start_line
	endif

	if retval < 0
		let retval = retval + line('$') + 1
	endif
	if retval <= 0
		let retval = 1
	endif
	return retval
endfunction

"
" GetAutodateLines()
"
"   autodate対象範囲を取得する
"
function! s:GetAutodateLines()
	if exists('b:autodate_lines') && b:autodate_lines > 0
		return b:autodate_lines
	elseif exists('g:autodate_lines') && g:autodate_lines > 0
		return g:autodate_lines
	else
		return 50
	endif
endfunction

"
" AutodateStub(first, last)
"
"   指定された範囲についてタイムスタンプの自動アップデートを行なう。
"
function! s:AutodateStub(first, last)

	" Verify pre-keyword.
	if exists('b:autodate_keyword_pre') && b:autodate_keyword_pre != ''
		let pre = b:autodate_keyword_pre
	else
		if exists('g:autodate_keyword_pre') && g:autodate_keyword_pre != ''
			let pre = g:autodate_keyword_pre
		else
			let pre = '\cLast Change:'
		endif
	endif

	" Verify post-keyword.
	if exists('b:autodate_keyword_post') && b:autodate_keyword_post != ''
		let post = b:autodate_keyword_post
	else
		if exists('g:autodate_keyword_post') && g:autodate_keyword_post != ''
			let post = g:autodate_keyword_post
		else
			let post = '\.'
		endif
	endif

	" Verify format.
	if exists('b:autodate_format') && b:autodate_format != ''
		let format = b:autodate_format
	else
		if exists('g:autodate_format') && g:autodate_format != ''
			let format = g:autodate_format
		else
			let format = '%d-%3m-%Y'
		endif
	endif

	" Generate substitution pattern
	let pat = '\('.pre.'\s*\)\(\S.*\)\?\('.post.'\)'
	let sub = Strftime2(format)
	" For debug
	if s:debug
		echo "range=".a:first."-".a:last
		echo "pat= ".pat
		echo "sub= ".sub
	endif

	" Process
	let i = a:first
	while i <= a:last
		let curline = getline(i)
		if curline =~ pat
			let newline = substitute(curline, pat, '\1' . sub . '\3', '')
			if curline !=# newline
				call setline(i, newline)
			endif
		endif
		let i = i + 1
	endwhile
endfunction

"
" Strftime2({format} [, {time}])
"   Enchanced version of strftime().
"
"   strftime()のフォーマット拡張バージョン。フォーマット書式はほとんどオリジ
"   ナルと一緒。しかし月の英語名に置換わる特別な書式 %{n}m が使用可能。{n}に
"   は英語名の文字列の長さを指定する(最大9)。0を指定すれば余分な空白は付加さ
"   れない。
"	例:
"	    :echo Strftime2("%d-%3m-%Y")
"	    07-Oct-2001
"	    :echo Strftime2("%d-%0m-%Y")
"	    07-October-2001
"
function! Strftime2(...)
	if a:0 > 0
		" Get {time} argument.
		if a:0 > 1
			let time = a:2
		else
			let time = localtime()
		endif
		" Parse special format.
		let format = a:1
		let format = substitute(format, '%\(\d\+\)m', '\=MonthnameString(-1, submatch(1), time)', 'g')
		let format = substitute(format, '%\(\d\+\)a', '\=DaynameString(-1, submatch(1), time)', 'g')
		return strftime(format, time)
	endif
	" Genrate error!
	return strftime()
endfunction

"
" MonthnameString([{month} [, {length} [, {time}]]])
"   Get month name string in English with first specified letters.
"
"   英語の月名を指定した長さで返す。{month}を省略した場合には現在の月名が返
"   される。{month}に無効な指定(1～12以外)が行なわれた場合は{time}で示される
"   月名が返される。{time}を省略した場合には代わりに|localtime()|が使用され
"   る。{length}には返す名前の長さを指定するが省略すると任意長になる。
"	例:
"	    :echo MonthnameString(8) . " 2001"
"	    August 2001
"	    :echo MonthnameString(8,3) . " 2001"
"	    Aug 2001
"
function! MonthnameString(...)
	" Get {time} argument.
	if a:0 > 2
		let time = a:3
	else
		let time = localtime()
	endif
	" Verify {month}.
	if a:0 > 0 && (a:1 >= 1 && a:1 <= 12)
		let month = a:1
	else
		let month = substitute(strftime('%m', time), '^0\+', '', '')
	endif
	" Verify {length}.
	if a:0 > 1 && (a:2 >= 1 && a:2 <= 9)
		let length = a:2
	else
		let length = strpart('785534469788', month - 1, 1)
	endif
	" Generate string of month name.
	return strpart('January  February March    April    May      June     July     August   SeptemberOctober  November December ', month * 9 - 9, length)
endfunction

"
" DaynameString([{month} [, {length} [, {time}]]])
"   Get day name string in English with first specified letters.
"
"   英語の曜日名を指定した長さで返す。{day}を省略した場合には本日の曜日名が
"   返される。{day}に無効な指定(0～6以外)が行なわれた場合は{time}で示される
"   曜日名が返される。{time}を省略した場合には代わりに|localtime()|が使用さ
"   れる。{length}には返す名前の長さを指定するが省略すると任意長になる。
"	例:
"	    :echo DaynameString(0)
"	    Sunday
"	    :echo DaynameString(5,3).', 13th'
"	    Fri, 13th
"
function! DaynameString(...)
	" Get {time} argument.
	if a:0 > 2
		let time = a:3
	else
		let time = localtime()
	endif
	" Verify {day}.
	if a:0 > 0 && (a:1 >= 0 && a:1 <= 6)
		let day = a:1
	else
		let day = strftime('%w', time) + 0
	endif
	" Verify {length}.
	if a:0 > 1 && (a:2 >= 1 && a:2 <= 9)
		let length = a:2
	else
		let length = strpart('6798686', day, 1)
	endif
	" Generate string of day name.
	return strpart('Sunday   Monday   Tuesday  WednesdayThursday Friday   Saturday ', day * 9, length)
endfunction
nnoremap <F10> OLast Change: 2018/03/08 (Thu) 11:35:00.<Esc>
let autodate_format="%Y/%m/%d (%a) %H:%M:%S"
let autodate_lines=3
" }}}

" easy-align https://github.com/junegunn/vim-easy-align/ {{{
" plugin {{{
" Copyright (c) 2014 Junegunn Choi
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

if exists("g:loaded_easy_align_plugin")
	finish
endif
let g:loaded_easy_align_plugin = 1

command! -nargs=* -range -bang EasyAlign <line1>,<line2>call easy_align#align(<bang>0, 0, 'command', <q-args>)
command! -nargs=* -range -bang LiveEasyAlign <line1>,<line2>call easy_align#align(<bang>0, 1, 'command', <q-args>)

let s:last_command = 'EasyAlign'

function! s:abs(v)
	return a:v >= 0 ? a:v : - a:v
endfunction

function! s:remember_visual(mode)
	let s:last_visual = [a:mode, s:abs(line("'>") - line("'<")), s:abs(col("'>") - col("'<"))]
endfunction

function! s:repeat_visual()
	let [mode, ldiff, cdiff] = s:last_visual
	let cmd = 'normal! '.mode
	if ldiff > 0
		let cmd .= ldiff . 'j'
	endif

	let ve_save = &virtualedit
	try
		if mode == "\<C-V>"
			if cdiff > 0
				let cmd .= cdiff . 'l'
			endif
			set virtualedit+=block
		endif
		execute cmd.":\<C-r>=g:easy_align_last_command\<Enter>\<Enter>"
		call s:set_repeat()
	finally
		if ve_save != &virtualedit
			let &virtualedit = ve_save
		endif
	endtry
endfunction

function! s:repeat_in_visual()
	if exists('g:easy_align_last_command')
		call s:remember_visual(visualmode())
		call s:repeat_visual()
	endif
endfunction

function! s:set_repeat()
	silent! call repeat#set("\<Plug>(EasyAlignRepeat)")
endfunction

function! s:generic_easy_align_op(type, vmode, live)
	if !&modifiable
		if a:vmode
			normal! gv
		endif
		return
	endif
	let sel_save = &selection
	let &selection = "inclusive"

	if a:vmode
		let vmode = a:type
		let [l1, l2] = ["'<", "'>"]
		call s:remember_visual(vmode)
	else
		let vmode = ''
		let [l1, l2] = [line("'["), line("']")]
		unlet! s:last_visual
	endif

	try
		let range = l1.','.l2
		if get(g:, 'easy_align_need_repeat', 0)
			execute range . g:easy_align_last_command
		else
			execute range . "call easy_align#align(0, a:live, vmode, '')"
		end
		call s:set_repeat()
	finally
		let &selection = sel_save
	endtry
endfunction

function! s:easy_align_op(type, ...)
	call s:generic_easy_align_op(a:type, a:0, 0)
endfunction

function! s:live_easy_align_op(type, ...)
	call s:generic_easy_align_op(a:type, a:0, 1)
endfunction

function! s:easy_align_repeat()
	if exists('s:last_visual')
		call s:repeat_visual()
	else
		try
			let g:easy_align_need_repeat = 1
			normal! .
		finally
			unlet! g:easy_align_need_repeat
		endtry
	endif
endfunction

nnoremap <silent> <Plug>(EasyAlign) :set opfunc=<SID>easy_align_op<Enter>g@
vnoremap <silent> <Plug>(EasyAlign) :<C-U>call <SID>easy_align_op(visualmode(), 1)<Enter>
nnoremap <silent> <Plug>(LiveEasyAlign) :set opfunc=<SID>live_easy_align_op<Enter>g@
vnoremap <silent> <Plug>(LiveEasyAlign) :<C-U>call <SID>live_easy_align_op(visualmode(), 1)<Enter>

" vim-repeat support
nnoremap <silent> <Plug>(EasyAlignRepeat) :call <SID>easy_align_repeat()<Enter>
vnoremap <silent> <Plug>(EasyAlignRepeat) :<C-U>call <SID>repeat_in_visual()<Enter>

" Backward-compatibility (deprecated)
nnoremap <silent> <Plug>(EasyAlignOperator) :set opfunc=<SID>easy_align_op<Enter>g@
" }}}
" autoload {{{
" Copyright (c) 2014 Junegunn Choi
"
" MIT License
"
" Permission is hereby granted, free of charge, to any person obtaining
" a copy of this software and associated documentation files (the
" "Software"), to deal in the Software without restriction, including
" without limitation the rights to use, copy, modify, merge, publish,
" distribute, sublicense, and/or sell copies of the Software, and to
" permit persons to whom the Software is furnished to do so, subject to
" the following conditions:
"
" The above copyright notice and this permission notice shall be
" included in all copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
" EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
" MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
" NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
" LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
" OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
" WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

if exists("g:loaded_easy_align")
	finish
endif
let g:loaded_easy_align = 1

let s:cpo_save = &cpo
set cpo&vim

let s:easy_align_delimiters_default = {
			\  ' ': { 'pattern': ' ',  'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0 },
			\  '=': { 'pattern': '===\|<=>\|\(&&\|||\|<<\|>>\)=\|=\~[#?]\?\|=>\|[:+/*!%^=><&|.?-]\?=[#?]\?',
			\                          'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
			\  ':': { 'pattern': ':',  'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1 },
			\  ',': { 'pattern': ',',  'left_margin': 0, 'right_margin': 1, 'stick_to_left': 1 },
			\  '|': { 'pattern': '|',  'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
			\  '.': { 'pattern': '\.', 'left_margin': 0, 'right_margin': 0, 'stick_to_left': 0 },
			\  '#': { 'pattern': '#\+', 'delimiter_align': 'l', 'ignore_groups': ['!Comment']  },
			\  '"': { 'pattern': '"\+', 'delimiter_align': 'l', 'ignore_groups': ['!Comment']  },
			\  '&': { 'pattern': '\\\@<!&\|\\\\',
			\                          'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
			\  '{': { 'pattern': '(\@<!{',
			\                          'left_margin': 1, 'right_margin': 1, 'stick_to_left': 0 },
			\  '}': { 'pattern': '}',  'left_margin': 1, 'right_margin': 0, 'stick_to_left': 0 }
			\ }

let s:mode_labels = { 'l': '', 'r': '[R]', 'c': '[C]' }

let s:known_options = {
			\ 'margin_left':   [0, 1], 'margin_right':     [0, 1], 'stick_to_left':   [0],
			\ 'left_margin':   [0, 1], 'right_margin':     [0, 1], 'indentation':     [1],
			\ 'ignore_groups': [3   ], 'ignore_unmatched': [0   ], 'delimiter_align': [1],
			\ 'mode_sequence': [1   ], 'ignores':          [3],    'filter':          [1],
			\ 'align':         [1   ]
			\ }

let s:option_values = {
			\ 'indentation':      ['shallow', 'deep', 'none', 'keep', -1],
			\ 'delimiter_align':  ['left', 'center', 'right', -1],
			\ 'ignore_unmatched': [0, 1, -1],
			\ 'ignore_groups':    [[], ['String'], ['Comment'], ['String', 'Comment'], -1]
			\ }

let s:shorthand = {
			\ 'margin_left':   'lm', 'margin_right':     'rm', 'stick_to_left':   'stl',
			\ 'left_margin':   'lm', 'right_margin':     'rm', 'indentation':     'idt',
			\ 'ignore_groups': 'ig', 'ignore_unmatched': 'iu', 'delimiter_align': 'da',
			\ 'mode_sequence': 'a',  'ignores':          'ig', 'filter':          'f',
			\ 'align':         'a'
			\ }

if exists("*strdisplaywidth")
	function! s:strwidth(str)
		return strdisplaywidth(a:str)
	endfunction
else
	function! s:strwidth(str)
		return len(split(a:str, '\zs')) + len(matchstr(a:str, '^\t*')) * (&tabstop - 1)
	endfunction
endif

function! s:ceil2(v)
	return a:v % 2 == 0 ? a:v : a:v + 1
endfunction

function! s:floor2(v)
	return a:v % 2 == 0 ? a:v : a:v - 1
endfunction

function! s:highlighted_as(line, col, groups)
	if empty(a:groups) | return 0 | endif
	let hl = synIDattr(synID(a:line, a:col, 0), 'name')
	for grp in a:groups
		if grp[0] == '!'
			if hl !~# grp[1:-1]
				return 1
			endif
		elseif hl =~# grp
			return 1
		endif
	endfor
	return 0
endfunction

function! s:ignored_syntax()
	if has('syntax') && exists('g:syntax_on')
		" Backward-compatibility
		return get(g:, 'easy_align_ignore_groups',
					\ get(g:, 'easy_align_ignores',
					\ (get(g:, 'easy_align_ignore_comment', 1) == 0) ?
					\ ['String'] : ['String', 'Comment']))
	else
		return []
	endif
endfunction

function! s:echon_(tokens)
	" http://vim.wikia.com/wiki/How_to_print_full_screen_width_messages
	let xy = [&ruler, &showcmd]
	try
		set noruler noshowcmd

		let winlen = winwidth(winnr()) - 2
		let len = len(join(map(copy(a:tokens), 'v:val[1]'), ''))
		let ellipsis = len > winlen ? '..' : ''

		echon "\r"
		let yet = 0
		for [hl, msg] in a:tokens
			if empty(msg) | continue | endif
			execute "echohl ". hl
			let yet += len(msg)
			if yet > winlen - len(ellipsis)
				echon msg[ 0 : (winlen - len(ellipsis) - yet - 1) ] . ellipsis
				break
			else
				echon msg
			endif
		endfor
	finally
		echohl None
		let [&ruler, &showcmd] = xy
	endtry
endfunction

function! s:echon(l, n, r, d, o, warn)
	let tokens = [
				\ ['Function', s:live ? ':LiveEasyAlign' : ':EasyAlign'],
				\ ['ModeMsg', get(s:mode_labels, a:l, a:l)],
				\ ['None', ' ']]

	if a:r == -1 | call add(tokens, ['Comment', '(']) | endif
	call add(tokens, [a:n =~ '*' ? 'Repeat' : 'Number', a:n])
	call extend(tokens, a:r == 1 ?
				\ [['Delimiter', '/'], ['String', a:d], ['Delimiter', '/']] :
				\ [['Identifier', a:d == ' ' ? '\ ' : (a:d == '\' ? '\\' : a:d)]])
	if a:r == -1 | call extend(tokens, [['Normal', '_'], ['Comment', ')']]) | endif
	call add(tokens, ['Statement', empty(a:o) ? '' : ' '.string(a:o)])
	if !empty(a:warn)
		call add(tokens, ['WarningMsg', ' ('.a:warn.')'])
	endif

	call s:echon_(tokens)
	return join(map(tokens, 'v:val[1]'), '')
endfunction

function! s:exit(msg)
	call s:echon_([['ErrorMsg', a:msg]])
	throw 'exit'
endfunction

function! s:ltrim(str)
	return substitute(a:str, '^\s\+', '', '')
endfunction

function! s:rtrim(str)
	return substitute(a:str, '\s\+$', '', '')
endfunction

function! s:trim(str)
	return substitute(a:str, '^\s*\(.\{-}\)\s*$', '\1', '')
endfunction

function! s:fuzzy_lu(key)
	if has_key(s:known_options, a:key)
		return a:key
	endif
	let key = tolower(a:key)

	" stl -> ^s.*_t.*_l.*
	let regexp1 = '^' .key[0]. '.*' .substitute(key[1 : -1], '\(.\)', '_\1.*', 'g')
	let matches = filter(keys(s:known_options), 'v:val =~ regexp1')
	if len(matches) == 1
		return matches[0]
	endif

	" stl -> ^s.*t.*l.*
	let regexp2 = '^' . substitute(substitute(key, '-', '_', 'g'), '\(.\)', '\1.*', 'g')
	let matches = filter(keys(s:known_options), 'v:val =~ regexp2')

	if empty(matches)
		call s:exit("Unknown option key: ". a:key)
	elseif len(matches) == 1
		return matches[0]
	else
		" Avoid ambiguity introduced by deprecated margin_left and margin_right
		if sort(matches) == ['margin_left', 'margin_right', 'mode_sequence']
			return 'mode_sequence'
		endif
		if sort(matches) == ['ignore_groups', 'ignores']
			return 'ignore_groups'
		endif
		call s:exit("Ambiguous option key: ". a:key ." (" .join(matches, ', '). ")")
	endif
endfunction

function! s:shift(modes, cycle)
	let item = remove(a:modes, 0)
	if a:cycle || empty(a:modes)
		call add(a:modes, item)
	endif
	return item
endfunction

function! s:normalize_options(opts)
	let ret = {}
	for k in keys(a:opts)
		let v = a:opts[k]
		let k = s:fuzzy_lu(k)
		" Backward-compatibility
		if k == 'margin_left'   | let k = 'left_margin'    | endif
		if k == 'margin_right'  | let k = 'right_margin'   | endif
		if k == 'mode_sequence' | let k = 'align'          | endif
		let ret[k] = v
		unlet v
	endfor
	return s:validate_options(ret)
endfunction

function! s:compact_options(opts)
	let ret = {}
	for k in keys(a:opts)
		let ret[s:shorthand[k]] = a:opts[k]
	endfor
	return ret
endfunction

function! s:validate_options(opts)
	for k in keys(a:opts)
		let v = a:opts[k]
		if index(s:known_options[k], type(v)) == -1
			call s:exit("Invalid type for option: ". k)
		endif
		unlet v
	endfor
	return a:opts
endfunction

function! s:split_line(line, nth, modes, cycle, fc, lc, pattern, stick_to_left, ignore_unmatched, ignore_groups)
	let mode = ''

	let string = a:lc ?
				\ strpart(getline(a:line), a:fc - 1, a:lc - a:fc + 1) :
				\ strpart(getline(a:line), a:fc - 1)
	let idx     = 0
	let nomagic = match(a:pattern, '\\v') > match(a:pattern, '\C\\[mMV]')
	let pattern = '^.\{-}\s*\zs\('.a:pattern.(nomagic ? ')' : '\)')
	let tokens  = []
	let delims  = []

	" Phase 1: split
	let ignorable = 0
	let token = ''
	let phantom = 0
	while 1
		let matchidx = match(string, pattern, idx)
		" No match
		if matchidx < 0 | break | endif
		let matchend = matchend(string, pattern, idx)
		let spaces = matchstr(string, '\s'.(a:stick_to_left ? '*' : '\{-}'), matchend + (matchidx == matchend))

		" Match, but empty
		if len(spaces) + matchend - idx == 0
			let char = strpart(string, idx, 1)
			if empty(char) | break | endif
			let [match, part, delim] = [char, char, '']
			" Match
		else
			let match = strpart(string, idx, matchend - idx + len(spaces))
			let part  = strpart(string, idx, matchidx - idx)
			let delim = strpart(string, matchidx, matchend - matchidx)
		endif

		let ignorable = s:highlighted_as(a:line, idx + len(part) + a:fc, a:ignore_groups)
		if ignorable
			let token .= match
		else
			let [pmode, mode] = [mode, s:shift(a:modes, a:cycle)]
			call add(tokens, token . match)
			call add(delims, delim)
			let token = ''
		endif

		let idx += len(match)

		" If the string is non-empty and ends with the delimiter,
		" append an empty token to the list
		if idx == len(string)
			let phantom = 1
			break
		endif
	endwhile

	let leftover = token . strpart(string, idx)
	if !empty(leftover)
		let ignorable = s:highlighted_as(a:line, len(string) + a:fc - 1, a:ignore_groups)
		call add(tokens, leftover)
		call add(delims, '')
	elseif phantom
		call add(tokens, '')
		call add(delims, '')
	endif
	let [pmode, mode] = [mode, s:shift(a:modes, a:cycle)]

	" Preserve indentation - merge first two tokens
	if len(tokens) > 1 && empty(s:rtrim(tokens[0]))
		let tokens[1] = tokens[0] . tokens[1]
		call remove(tokens, 0)
		call remove(delims, 0)
		let mode = pmode
	endif

	" Skip comment line
	if ignorable && len(tokens) == 1 && a:ignore_unmatched
		let tokens = []
		let delims = []
		" Append an empty item to enable right/center alignment of the last token
		" - if the last token is not ignorable or ignorable but not the only token
	elseif a:ignore_unmatched != 1          &&
				\ (mode ==? 'r' || mode ==? 'c')  &&
				\ (!ignorable || len(tokens) > 1) &&
				\ a:nth >= 0 " includes -0
		call add(tokens, '')
		call add(delims, '')
	endif

	return [tokens, delims]
endfunction

function! s:do_align(todo, modes, all_tokens, all_delims, fl, ll, fc, lc, nth, recur, dict)
	let mode       = a:modes[0]
	let lines      = {}
	let min_indent = -1
	let max = { 'pivot_len2': 0, 'token_len': 0, 'just_len': 0, 'delim_len': 0,
				\ 'indent': 0, 'tokens': 0, 'strip_len': 0 }
	let d = a:dict
	let [f, fx] = s:parse_filter(d.filter)

	" Phase 1
	for line in range(a:fl, a:ll)
		let snip = a:lc > 0 ? getline(line)[a:fc-1 : a:lc-1] : getline(line)
		if f == 1 && snip !~ fx
			continue
		elseif f == -1 && snip =~ fx
			continue
		endif

		if !has_key(a:all_tokens, line)
			" Split line into the tokens by the delimiters
			let [tokens, delims] = s:split_line(
						\ line, a:nth, copy(a:modes), a:recur == 2,
						\ a:fc, a:lc, d.pattern,
						\ d.stick_to_left, d.ignore_unmatched, d.ignore_groups)

			" Remember tokens for subsequent recursive calls
			let a:all_tokens[line] = tokens
			let a:all_delims[line] = delims
		else
			let tokens = a:all_tokens[line]
			let delims = a:all_delims[line]
		endif

		" Skip empty lines
		if empty(tokens)
			continue
		endif

		" Calculate the maximum number of tokens for a line within the range
		let max.tokens = max([max.tokens, len(tokens)])

		if a:nth > 0 " Positive N-th
			if len(tokens) < a:nth
				continue
			endif
			let nth = a:nth - 1 " make it 0-based
		else " -0 or Negative N-th
			if a:nth == 0 && mode !=? 'l'
				let nth = len(tokens) - 1
			else
				let nth = len(tokens) + a:nth
			endif
			if empty(delims[len(delims) - 1])
				let nth -= 1
			endif

			if nth < 0 || nth == len(tokens)
				continue
			endif
		endif

		let prefix = nth > 0 ? join(tokens[0 : nth - 1], '') : ''
		let delim  = delims[nth]
		let token  = s:rtrim( tokens[nth] )
		let token  = s:rtrim( strpart(token, 0, len(token) - len(s:rtrim(delim))) )
		if empty(delim) && !exists('tokens[nth + 1]') && d.ignore_unmatched
			continue
		endif

		let indent = s:strwidth(matchstr(tokens[0], '^\s*'))
		if min_indent < 0 || indent < min_indent
			let min_indent  = indent
		endif
		if mode ==? 'c'
			let token .= substitute(matchstr(token, '^\s*'), '\t', repeat(' ', &tabstop), 'g')
		endif
		let [pw, tw] = [s:strwidth(prefix), s:strwidth(token)]
		let max.indent    = max([max.indent,    indent])
		let max.token_len = max([max.token_len, tw])
		let max.just_len  = max([max.just_len,  pw + tw])
		let max.delim_len = max([max.delim_len, s:strwidth(delim)])

		if mode ==? 'c'
			let pivot_len2 = pw * 2 + tw
			if max.pivot_len2 < pivot_len2
				let max.pivot_len2 = pivot_len2
			endif
			let max.strip_len = max([max.strip_len, s:strwidth(s:trim(token))])
		endif
		let lines[line]   = [nth, prefix, token, delim]
	endfor

	" Phase 1-5: indentation handling (only on a:nth == 1)
	if a:nth == 1
		let idt = d.indentation
		if idt ==? 'd'
			let indent = max.indent
		elseif idt ==? 's'
			let indent = min_indent
		elseif idt ==? 'n'
			let indent = 0
		elseif idt !=? 'k'
			call s:exit('Invalid indentation: ' . idt)
		end

		if idt !=? 'k'
			let max.just_len   = 0
			let max.token_len  = 0
			let max.pivot_len2 = 0

			for [line, elems] in items(lines)
				let [nth, prefix, token, delim] = elems

				let tindent = matchstr(token, '^\s*')
				while 1
					let len = s:strwidth(tindent)
					if len < indent
						let tindent .= repeat(' ', indent - len)
						break
					elseif len > indent
						let tindent = tindent[0 : -2]
					else
						break
					endif
				endwhile

				let token = tindent . s:ltrim(token)
				if mode ==? 'c'
					let token = substitute(token, '\s*$', repeat(' ', indent), '')
				endif
				let [pw, tw] = [s:strwidth(prefix), s:strwidth(token)]
				let max.token_len = max([max.token_len, tw])
				let max.just_len  = max([max.just_len,  pw + tw])
				if mode ==? 'c'
					let pivot_len2 = pw * 2 + tw
					if max.pivot_len2 < pivot_len2
						let max.pivot_len2 = pivot_len2
					endif
				endif

				let lines[line][2] = token
			endfor
		endif
	endif

	" Phase 2
	for [line, elems] in items(lines)
		let tokens = a:all_tokens[line]
		let delims = a:all_delims[line]
		let [nth, prefix, token, delim] = elems

		" Remove the leading whitespaces of the next token
		if len(tokens) > nth + 1
			let tokens[nth + 1] = s:ltrim(tokens[nth + 1])
		endif

		" Pad the token with spaces
		let [pw, tw] = [s:strwidth(prefix), s:strwidth(token)]
		let rpad = ''
		if mode ==? 'l'
			let pad = repeat(' ', max.just_len - pw - tw)
			if d.stick_to_left
				let rpad = pad
			else
				let token = token . pad
			endif
		elseif mode ==? 'r'
			let pad = repeat(' ', max.just_len - pw - tw)
			let indent = matchstr(token, '^\s*')
			let token = indent . pad . s:ltrim(token)
		elseif mode ==? 'c'
			let p1  = max.pivot_len2 - (pw * 2 + tw)
			let p2  = max.token_len - tw
			let pf1 = s:floor2(p1)
			if pf1 < p1 | let p2 = s:ceil2(p2)
			else        | let p2 = s:floor2(p2)
			endif
			let strip = s:ceil2(max.token_len - max.strip_len) / 2
			let indent = matchstr(token, '^\s*')
			let token = indent. repeat(' ', pf1 / 2) .s:ltrim(token). repeat(' ', p2 / 2)
			let token = substitute(token, repeat(' ', strip) . '$', '', '')

			if d.stick_to_left
				if empty(s:rtrim(token))
					let center = len(token) / 2
					let [token, rpad] = [strpart(token, 0, center), strpart(token, center)]
				else
					let [token, rpad] = [s:rtrim(token), matchstr(token, '\s*$')]
				endif
			endif
		endif
		let tokens[nth] = token

		" Pad the delimiter
		let dpadl = max.delim_len - s:strwidth(delim)
		let da = d.delimiter_align
		if da ==? 'l'
			let [dl, dr] = ['', repeat(' ', dpadl)]
		elseif da ==? 'c'
			let dl = repeat(' ', dpadl / 2)
			let dr = repeat(' ', dpadl - dpadl / 2)
		elseif da ==? 'r'
			let [dl, dr] = [repeat(' ', dpadl), '']
		else
			call s:exit('Invalid delimiter_align: ' . da)
		endif

		" Before and after the range (for blockwise visual mode)
		let cline  = getline(line)
		let before = strpart(cline, 0, a:fc - 1)
		let after  = a:lc ? strpart(cline, a:lc) : ''

		" Determine the left and right margin around the delimiter
		let rest   = join(tokens[nth + 1 : -1], '')
		let nomore = empty(rest.after)
		let ml     = (empty(prefix . token) || empty(delim) && nomore) ? '' : d.ml
		let mr     = nomore ? '' : d.mr

		" Adjust indentation of the lines starting with a delimiter
		let lpad = ''
		if nth == 0
			let ipad = repeat(' ', min_indent - s:strwidth(token.ml))
			if mode ==? 'l'
				let token = ipad . token
			else
				let lpad = ipad
			endif
		endif

		" Align the token
		let aligned = join([lpad, token, ml, dl, delim, dr, mr, rpad], '')
		let tokens[nth] = aligned

		" Update the line
		let a:todo[line] = before.join(tokens, '').after
	endfor

	if a:nth < max.tokens && (a:recur || len(a:modes) > 1)
		call s:shift(a:modes, a:recur == 2)
		return [a:todo, a:modes, a:all_tokens, a:all_delims,
					\ a:fl, a:ll, a:fc, a:lc, a:nth + 1, a:recur, a:dict]
	endif
	return [a:todo]
endfunction

function! s:input(str, default, vis)
	if a:vis
		normal! gv
		redraw
		execute "normal! \<esc>"
	else
		" EasyAlign command can be called without visual selection
		redraw
	endif
	let got = input(a:str, a:default)
	return got
endfunction

function! s:atoi(str)
	return (a:str =~ '^[0-9]\+$') ? str2nr(a:str) : a:str
endfunction

function! s:shift_opts(opts, key, vals)
	let val = s:shift(a:vals, 1)
	if type(val) == 0 && val == -1
		call remove(a:opts, a:key)
	else
		let a:opts[a:key] = val
	endif
endfunction

function! s:interactive(range, modes, n, d, opts, rules, vis, bvis)
	let mode = s:shift(a:modes, 1)
	let n    = a:n
	let d    = a:d
	let ch   = ''
	let opts = s:compact_options(a:opts)
	let vals = deepcopy(s:option_values)
	let regx = 0
	let warn = ''
	let undo = 0

	while 1
		" Live preview
		let rdrw = 0
		if undo
			silent! undo
			let undo = 0
			let rdrw = 1
		endif
		if s:live && !empty(d)
			let output = s:process(a:range, mode, n, d, s:normalize_options(opts), regx, a:rules, a:bvis)
			let &undolevels = &undolevels " Break undo block
			call s:update_lines(output.todo)
			let undo = !empty(output.todo)
			let rdrw = 1
		endif
		if rdrw
			if a:vis
				normal! gv
			endif
			redraw
			if a:vis | execute "normal! \<esc>" | endif
		endif
		call s:echon(mode, n, -1, regx ? '/'.d.'/' : d, opts, warn)

		let check = 0
		let warn = ''

		try
			let c = getchar()
		catch /^Vim:Interrupt$/
			let c = 27
		endtry
		let ch = nr2char(c)
		if c == 3 || c == 27 " CTRL-C / ESC
			if undo
				silent! undo
			endif
			throw 'exit'
		elseif c == "\<bs>"
			if !empty(d)
				let d = ''
				let regx = 0
			elseif len(n) > 0
				let n = strpart(n, 0, len(n) - 1)
			endif
		elseif c == 13 " Enter key
			let mode = s:shift(a:modes, 1)
			if has_key(opts, 'a')
				let opts.a = mode . strpart(opts.a, 1)
			endif
		elseif ch == '-'
			if empty(n)      | let n = '-'
			elseif n == '-'  | let n = ''
			else             | let check = 1
			endif
		elseif ch == '*'
			if empty(n)      | let n = '*'
			elseif n == '*'  | let n = '**'
			elseif n == '**' | let n = ''
			else             | let check = 1
			endif
		elseif empty(d) && ((c == 48 && len(n) > 0) || c > 48 && c <= 57) " Numbers
			if n[0] == '*'   | let check = 1
			else             | let n = n . ch
			end
		elseif ch == "\<C-D>"
			call s:shift_opts(opts, 'da', vals['delimiter_align'])
		elseif ch == "\<C-I>"
			call s:shift_opts(opts, 'idt', vals['indentation'])
		elseif ch == "\<C-L>"
			let lm = s:input("Left margin: ", get(opts, 'lm', ''), a:vis)
			if empty(lm)
				let warn = 'Set to default. Input 0 to remove it'
				silent! call remove(opts, 'lm')
			else
				let opts['lm'] = s:atoi(lm)
			endif
		elseif ch == "\<C-R>"
			let rm = s:input("Right margin: ", get(opts, 'rm', ''), a:vis)
			if empty(rm)
				let warn = 'Set to default. Input 0 to remove it'
				silent! call remove(opts, 'rm')
			else
				let opts['rm'] = s:atoi(rm)
			endif
		elseif ch == "\<C-U>"
			call s:shift_opts(opts, 'iu', vals['ignore_unmatched'])
		elseif ch == "\<C-G>"
			call s:shift_opts(opts, 'ig', vals['ignore_groups'])
		elseif ch == "\<C-P>"
			if s:live
				if !empty(d)
					let ch = d
					break
				else
					let s:live = 0
				endif
			else
				let s:live = 1
			endif
		elseif c == "\<Left>"
			let opts['stl'] = 1
			let opts['lm']  = 0
		elseif c == "\<Right>"
			let opts['stl'] = 0
			let opts['lm']  = 1
		elseif c == "\<Down>"
			let opts['lm']  = 0
			let opts['rm']  = 0
		elseif c == "\<Up>"
			silent! call remove(opts, 'stl')
			silent! call remove(opts, 'lm')
			silent! call remove(opts, 'rm')
		elseif ch == "\<C-A>" || ch == "\<C-O>"
			let modes = tolower(s:input("Alignment ([lrc...][[*]*]): ", get(opts, 'a', mode), a:vis))
			if match(modes, '^[lrc]\+\*\{0,2}$') != -1
				let opts['a'] = modes
				let mode      = modes[0]
				while mode != s:shift(a:modes, 1)
				endwhile
			else
				silent! call remove(opts, 'a')
			endif
		elseif ch == "\<C-_>" || ch == "\<C-X>"
			if s:live && regx && !empty(d)
				break
			endif

			let prompt = 'Regular expression: '
			let ch = s:input(prompt, '', a:vis)
			if !empty(ch) && s:valid_regexp(ch)
				let regx = 1
				let d = ch
				if !s:live | break | endif
			else
				let warn = 'Invalid regular expression: '.ch
			endif
		elseif ch == "\<C-F>"
			let f = s:input("Filter (g/../ or v/../): ", get(opts, 'f', ''), a:vis)
			let m = matchlist(f, '^[gv]/\(.\{-}\)/\?$')
			if empty(f)
				silent! call remove(opts, 'f')
			elseif !empty(m) && s:valid_regexp(m[1])
				let opts['f'] = f
			else
				let warn = 'Invalid filter expression'
			endif
		elseif ch =~ '[[:print:]]'
			let check = 1
		else
			let warn = 'Invalid character'
		endif

		if check
			if empty(d)
				if has_key(a:rules, ch)
					let d = ch
					if !s:live
						if a:vis
							execute "normal! gv\<esc>"
						endif
						break
					endif
				else
					let warn = 'Unknown delimiter key: '.ch
				endif
			else
				if regx
					let warn = 'Press <CTRL-X> to finish'
				else
					if d == ch
						break
					else
						let warn = 'Press '''.d.''' again to finish'
					endif
				end
			endif
		endif
	endwhile
	if s:live
		let copts = call('s:summarize', output.summarize)
		let s:live = 0
		let g:easy_align_last_command = s:echon('', n, regx, d, copts, '')
		let s:live = 1
	end
	return [mode, n, ch, opts, regx]
endfunction

function! s:valid_regexp(regexp)
	try
		call matchlist('', a:regexp)
	catch
		return 0
	endtry
	return 1
endfunction

function! s:test_regexp(regexp)
	let regexp = empty(a:regexp) ? @/ : a:regexp
	if !s:valid_regexp(regexp)
		call s:exit('Invalid regular expression: '. regexp)
	endif
	return regexp
endfunction

let s:shorthand_regex =
			\ '\s*\%('
			\   .'\(lm\?[0-9]\+\)\|\(rm\?[0-9]\+\)\|\(iu[01]\)\|\(\%(s\%(tl\)\?[01]\)\|[<>]\)\|'
			\   .'\(da\?[clr]\)\|\(\%(ms\?\|a\)[lrc*]\+\)\|\(i\%(dt\)\?[kdsn]\)\|\([gv]/.*/\)\|\(ig\[.*\]\)'
			\ .'\)\+\s*$'

function! s:parse_shorthand_opts(expr)
	let opts = {}
	let expr = substitute(a:expr, '\s', '', 'g')
	let regex = '^'. s:shorthand_regex

	if empty(expr)
		return opts
	elseif expr !~ regex
		call s:exit("Invalid expression: ". a:expr)
	else
		let match = matchlist(expr, regex)
		for m in filter(match[ 1 : -1 ], '!empty(v:val)')
			for key in ['lm', 'rm', 'l', 'r', 'stl', 's', '<', '>', 'iu', 'da', 'd', 'ms', 'm', 'ig', 'i', 'g', 'v', 'a']
				if stridx(tolower(m), key) == 0
					let rest = strpart(m, len(key))
					if key == 'i' | let key = 'idt' | endif
					if key == 'g' || key == 'v'
						let rest = key.rest
						let key = 'f'
					endif

					if key == 'idt' || index(['d', 'f', 'm', 'a'], key[0]) >= 0
						let opts[key] = rest
					elseif key == 'ig'
						try
							let arr = eval(rest)
							if type(arr) == 3
								let opts[key] = arr
							else
								throw 'Not an array'
							endif
						catch
							call s:exit("Invalid ignore_groups: ". a:expr)
						endtry
					elseif key =~ '[<>]'
						let opts['stl'] = key == '<'
					else
						let opts[key] = str2nr(rest)
					endif
					break
				endif
			endfor
		endfor
	endif
	return s:normalize_options(opts)
endfunction

function! s:parse_args(args)
	if empty(a:args)
		return ['', '', {}, 0]
	endif
	let n    = ''
	let ch   = ''
	let args = a:args
	let cand = ''
	let opts = {}

	" Poor man's option parser
	let idx = 0
	while 1
		let midx = match(args, '\s*{.*}\s*$', idx)
		if midx == -1 | break | endif

		let cand = strpart(args, midx)
		try
			let [l, r, c, k, s, d, n] = ['l', 'r', 'c', 'k', 's', 'd', 'n']
			let [L, R, C, K, S, D, N] = ['l', 'r', 'c', 'k', 's', 'd', 'n']
			let o = eval(cand)
			if type(o) == 4
				let opts = o
				if args[midx - 1 : midx] == '\ '
					let midx += 1
				endif
				let args = strpart(args, 0, midx)
				break
			endif
		catch
			" Ignore
		endtry
		let idx = midx + 1
	endwhile

	" Invalid option dictionary
	if len(substitute(cand, '\s', '', 'g')) > 2 && empty(opts)
		call s:exit("Invalid option: ". cand)
	else
		let opts = s:normalize_options(opts)
	endif

	" Shorthand option notation
	let sopts = matchstr(args, s:shorthand_regex)
	if !empty(sopts)
		let args = strpart(args, 0, len(args) - len(sopts))
		let opts = extend(s:parse_shorthand_opts(sopts), opts)
	endif

	" Has /Regexp/?
	let matches = matchlist(args, '^\(.\{-}\)\s*/\(.*\)/\s*$')

	" Found regexp
	if !empty(matches)
		return [matches[1], s:test_regexp(matches[2]), opts, 1]
	else
		let tokens = matchlist(args, '^\([1-9][0-9]*\|-[0-9]*\|\*\*\?\)\?\s*\(.\{-}\)\?$')
		" Try swapping n and ch
		let [n, ch] = empty(tokens[2]) ? reverse(tokens[1:2]) : tokens[1:2]

		" Resolving command-line ambiguity
		" '\ ' => ' '
		" '\'  => ' '
		if ch =~ '^\\\s*$'
			let ch = ' '
			" '\\' => '\'
		elseif ch =~ '^\\\\\s*$'
			let ch = '\'
		endif

		return [n, ch, opts, 0]
	endif
endfunction

function! s:parse_filter(f)
	let m = matchlist(a:f, '^\([gv]\)/\(.\{-}\)/\?$')
	if empty(m)
		return [0, '']
	else
		return [m[1] == 'g' ? 1 : -1, m[2]]
	endif
endfunction

function! s:interactive_modes(bang)
	return get(g:,
				\ (a:bang ? 'easy_align_bang_interactive_modes' : 'easy_align_interactive_modes'),
				\ (a:bang ? ['r', 'l', 'c'] : ['l', 'r', 'c']))
endfunction

function! s:alternating_modes(mode)
	return a:mode ==? 'r' ? 'rl' : 'lr'
endfunction

function! s:update_lines(todo)
	for [line, content] in items(a:todo)
		call setline(line, s:rtrim(content))
	endfor
endfunction

function! s:parse_nth(n)
	let n = a:n
	let recur = 0
	if n == '*'      | let [nth, recur] = [1, 1]
	elseif n == '**' | let [nth, recur] = [1, 2]
	elseif n == '-'  | let nth = -1
	elseif empty(n)  | let nth = 1
	elseif n == '0' || ( n != '-0' && n != string(str2nr(n)) )
		call s:exit('Invalid N-th parameter: '. n)
	else
		let nth = n
	endif
	return [nth, recur]
endfunction

function! s:build_dict(delimiters, ch, regexp, opts)
	if a:regexp
		let dict = { 'pattern': a:ch }
	else
		if !has_key(a:delimiters, a:ch)
			call s:exit('Unknown delimiter key: '. a:ch)
		endif
		let dict = copy(a:delimiters[a:ch])
	endif
	call extend(dict, a:opts)

	let ml = get(dict, 'left_margin', ' ')
	let mr = get(dict, 'right_margin', ' ')
	if type(ml) == 0 | let ml = repeat(' ', ml) | endif
	if type(mr) == 0 | let mr = repeat(' ', mr) | endif
	call extend(dict, { 'ml': ml, 'mr': mr })

	let dict.pattern = get(dict, 'pattern', a:ch)
	let dict.delimiter_align =
				\ get(dict, 'delimiter_align', get(g:, 'easy_align_delimiter_align', 'r'))[0]
	let dict.indentation =
				\ get(dict, 'indentation', get(g:, 'easy_align_indentation', 'k'))[0]
	let dict.stick_to_left =
				\ get(dict, 'stick_to_left', 0)
	let dict.ignore_unmatched =
				\ get(dict, 'ignore_unmatched', get(g:, 'easy_align_ignore_unmatched', 2))
	let dict.ignore_groups =
				\ get(dict, 'ignore_groups', get(dict, 'ignores', s:ignored_syntax()))
	let dict.filter =
				\ get(dict, 'filter', '')
	return dict
endfunction

function! s:build_mode_sequence(expr, recur)
	let [expr, recur] = [a:expr, a:recur]
	let suffix = matchstr(a:expr, '\*\+$')
	if suffix == '*'
		let expr = expr[0 : -2]
		let recur = 1
	elseif suffix == '**'
		let expr = expr[0 : -3]
		let recur = 2
	endif
	return [tolower(expr), recur]
endfunction

function! s:process(range, mode, n, ch, opts, regexp, rules, bvis)
	let [nth, recur] = s:parse_nth((empty(a:n) && exists('g:easy_align_nth')) ? g:easy_align_nth : a:n)
	let dict = s:build_dict(a:rules, a:ch, a:regexp, a:opts)
	let [mode_sequence, recur] = s:build_mode_sequence(
				\ get(dict, 'align', recur == 2 ? s:alternating_modes(a:mode) : a:mode),
				\ recur)

	let ve = &virtualedit
	set ve=all
	let args = [
				\ {}, split(mode_sequence, '\zs'),
				\ {}, {}, a:range[0], a:range[1],
				\ a:bvis             ? min([virtcol("'<"), virtcol("'>")]) : 1,
				\ (!recur && a:bvis) ? max([virtcol("'<"), virtcol("'>")]) : 0,
				\ nth, recur, dict ]
	let &ve = ve
	while len(args) > 1
		let args = call('s:do_align', args)
	endwhile

	" todo: lines to update
	" summarize: arguments to s:summarize
	return { 'todo': args[0], 'summarize': [ a:opts, recur, mode_sequence ] }
endfunction

function s:summarize(opts, recur, mode_sequence)
	let copts = s:compact_options(a:opts)
	let nbmode = s:interactive_modes(0)[0]
	if !has_key(copts, 'a') && (
				\  (a:recur == 2 && s:alternating_modes(nbmode) != a:mode_sequence) ||
				\  (a:recur != 2 && (a:mode_sequence[0] != nbmode || len(a:mode_sequence) > 1))
				\ )
		call extend(copts, { 'a': a:mode_sequence })
	endif
	return copts
endfunction

function! s:align(bang, live, visualmode, first_line, last_line, expr)
	" Heuristically determine if the user was in visual mode
	if a:visualmode == 'command'
		let vis  = a:first_line == line("'<") && a:last_line == line("'>")
		let bvis = vis && visualmode() == "\<C-V>"
	elseif empty(a:visualmode)
		let vis  = 0
		let bvis = 0
	else
		let vis  = 1
		let bvis = a:visualmode == "\<C-V>"
	end
	let range = [a:first_line, a:last_line]
	let modes = s:interactive_modes(a:bang)
	let mode  = modes[0]
	let s:live = a:live

	let rules = s:easy_align_delimiters_default
	if exists('g:easy_align_delimiters')
		let rules = extend(copy(rules), g:easy_align_delimiters)
	endif

	let [n, ch, opts, regexp] = s:parse_args(a:expr)

	let bypass_fold = get(g:, 'easy_align_bypass_fold', 0)
	let ofm = &l:foldmethod
	try
		if bypass_fold | let &l:foldmethod = 'manual' | endif

		if empty(n) && empty(ch) || s:live
			let [mode, n, ch, opts, regexp] = s:interactive(range, copy(modes), n, ch, opts, rules, vis, bvis)
		endif

		if !s:live
			let output = s:process(range, mode, n, ch, s:normalize_options(opts), regexp, rules, bvis)
			call s:update_lines(output.todo)
			let copts = call('s:summarize', output.summarize)
			let g:easy_align_last_command = s:echon('', n, regexp, ch, copts, '')
		endif
	finally
		if bypass_fold | let &l:foldmethod = ofm | endif
	endtry
endfunction

function! easy_align#align(bang, live, visualmode, expr) range
	try
		call s:align(a:bang, a:live, a:visualmode, a:firstline, a:lastline, a:expr)
	catch /^\%(Vim:Interrupt\|exit\)$/
		if empty(a:visualmode)
			echon "\r"
			echon "\r"
		else
			normal! gv
		endif
	endtry
endfunction

let &cpo = s:cpo_save
unlet s:cpo_save
" }}}
	nmap ga <Plug>(EasyAlign)
	xmap ga <Plug>(EasyAlign)
" }}}

inoremap { {}<Left>
inoremap [ []<Left>
inoremap ( {}<Left>
inoremap {<Enter> {}<Left><CR><ESC><S-o>
inoremap [<Enter> []<Left><CR><ESC><S-o>
inoremap (<Enter> ()<Left><CR><ESC><S-o>

" {{{
" plugin {{{
" }}}
" autoload {{{
" }}}
" }}}
