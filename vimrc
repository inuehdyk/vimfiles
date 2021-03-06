"
" Vim8用サンプル vimrc
"
if has('win32')                   " Windows 32bit または 64bit ?
	set encoding=utf-8              " cp932 が嫌なら utf-8 にしてください
else
	set encoding=utf-8
endif
scriptencoding utf-8              " This file's encoding

" 推奨設定の読み込み (:h defaults.vim)
unlet! skip_defaults_vim
source $VIMRUNTIME/defaults.vim

"===============================================================================
" 設定の追加はこの行以降でおこなうこと！
" 分からないオプション名は先頭に ' を付けてhelpしましょう。例:
" :h 'helplang

" packadd! vimdoc-ja                " 日本語help の読み込み
" set helplang=ja,en                " help言語の設定

set scrolloff=0
set laststatus=2                  " 常にステータス行を表示する
set cmdheight=2                   " hit-enter回数を減らすのが目的
if !has('gui_running')            " gvimではない？ (== 端末)
	set mouse=                      " マウス無効 (macOS時は不便かも？)
	set ttimeoutlen=0               " モード変更時の表示更新を最速化
	if $COLORTERM == "truecolor"    " True Color対応端末？
		set termguicolors
	endif
endif
set nofixendofline                " Windowsのエディタの人達に嫌われない設定
set ambiwidth=double              " ○, △, □等の文字幅をASCII文字の倍にする
set directory-=.                  " swapファイルはローカル作成がトラブル少なめ
set formatoptions+=mM             " 日本語の途中でも折り返す
let &grepprg="grep -rnIH --exclude=.git --exclude-dir=.hg --exclude-dir=.svn --exclude=tags"
let loaded_matchparen = 1         " カーソルが括弧上にあっても括弧ペアをハイライトさせない

" :grep 等でquickfixウィンドウを開く (:lgrep 等でlocationlistウィンドウを開く)
"augroup qf_win
"  autocmd!
"  autocmd QuickfixCmdPost [^l]* copen
"  autocmd QuickfixCmdPost l* lopen
"augroup END

" マウスの中央ボタンクリックによるクリップボードペースト動作を抑制する
noremap <MiddleMouse> <Nop>
noremap! <MiddleMouse> <Nop>
noremap <2-MiddleMouse> <Nop>
noremap! <2-MiddleMouse> <Nop>
noremap <3-MiddleMouse> <Nop>
noremap! <3-MiddleMouse> <Nop>
noremap <4-MiddleMouse> <Nop>
noremap! <4-MiddleMouse> <Nop>

"-------------------------------------------------------------------------------
" ステータスライン設定
let &statusline = "%<%f %m%r%h%w[%{&ff}][%{(&fenc!=''?&fenc:&enc).(&bomb?':bom':'')}] "
if has('iconv')
	let &statusline .= "0x%{FencB()}"

	function! FencB()
		let c = matchstr(getline('.'), '.', col('.') - 1)
		if c != ''
			let c = iconv(c, &enc, &fenc)
			return s:Byte2hex(s:Str2byte(c))
		else
			return '0'
		endif
	endfunction
	function! s:Str2byte(str)
		return map(range(len(a:str)), 'char2nr(a:str[v:val])')
	endfunction
	function! s:Byte2hex(bytes)
		return join(map(copy(a:bytes), 'printf("%02X", v:val)'), '')
	endfunction
else
	let &statusline .= "0x%B"
endif
let &statusline .= "%=%l,%c%V %P"

"-------------------------------------------------------------------------------
" ファイルエンコーディング検出設定
let &fileencoding = &encoding
if has('iconv')
	if &encoding ==# 'utf-8'
		let &fileencodings = 'iso-2022-jp,euc-jp,cp932,' . &fileencodings
	else
		let &fileencodings .= ',iso-2022-jp,utf-8,ucs-2le,ucs-2,euc-jp'
	endif
endif
" 日本語を含まないファイルのエンコーディングは encoding と同じにする
if has('autocmd')
	function! AU_ReSetting_Fenc()
		if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
			let &fileencoding = &encoding
		endif
	endfunction
	augroup resetting_fenc
		autocmd!
		autocmd BufReadPost * call AU_ReSetting_Fenc()
	augroup END
endif

"-------------------------------------------------------------------------------
" カラースキームの設定
" https://github.com/tomasiser/vim-code-dark.git
colorscheme codedark

try
	silent hi CursorIM
catch /E411/
	" CursorIM (IME ON中のカーソル色)が定義されていなければ、紫に設定
	hi CursorIM ctermfg=16 ctermbg=127 guifg=#000000 guibg=#af00af
endtry

" vim:set et ts=2 sw=0:

"-------------------------------------------------------------------------------
" vim-plug Setting
"
" Specify a directory for plugins
call plug#begin('~/.vim/plugged')

" plugins
Plug 'tomtom/tcomment_vim'
Plug 'bronson/vim-trailing-whitespace'

" LSP
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'mattn/vim-lsp-icons'
Plug 'hrsh7th/vim-vsnip'
Plug 'hrsh7th/vim-vsnip-integ'

" FERN
Plug 'lambdalisue/fern.vim'
Plug 'lambdalisue/fern-git-status.vim'
Plug 'lambdalisue/fern-renderer-nerdfont.vim'
Plug 'lambdalisue/nerdfont.vim'
Plug 'lambdalisue/fern-git-status.vim'

" CTRLP
Plug 'ctrlpvim/ctrlp.vim'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

Plug 'tomasiser/vim-code-dark'

call plug#end()

"
" airline用設定
"
let g:airline#extensions#tabline#enabled = 1
" ステータスラインに表示する項目を変更する
let g:airline#extensions#default#layout = [
  \ [ 'a', 'b', 'c' ],
  \ ['z']
  \ ]
let g:airline_section_c = '%t %M'
let g:airline_section_z = get(g:, 'airline_linecolumn_prefix', '').'%3l:%-2v'
" 変更がなければdiffの行数を表示しない
let g:airline#extensions#hunks#non_zero_only = 1 

" タブラインの表示を変更する
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#tabline#show_buffers = 1
let g:airline#extensions#tabline#show_splits = 0
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_tab_type = 1
let g:airline#extensions#tabline#show_close_button = 0


" fern用設定
let g:fern#renderer = 'nerdfont'
nnoremap <C-n> :Fern . -reveal=% -drawer -toggle -width=40<CR>

"-------------------------------------------------------------------------------
"other settings
filetype plugin indent on

set undofile
set hlsearch
set showmatch

syntax on

set wrap
set ruler
set shiftwidth=2
set tabstop=2
set autoindent

set guifont=Cica:h11
set printfont=Cica:h8
" set renderingoptions=type:directx,renmode:5
set ambiwidth=double

"
" 各種設定の読み込み
"
" 各種設定の読み込み
call map(sort(split(globpath(&runtimepath, '_config/*.vim'))), {->[execute('exec "so" v:val')]})
