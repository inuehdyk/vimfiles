" Vim 本体の機能のデフォルト値を経項する設定
setglobal cmdheight=2
setglobal laststatus=2
setglobal fileformat=unix
setglobal formatoptions+=mb

set number
set tabstop=2
set shiftwidth=2
set expandtab

set backup
set writebackup
set swapfile
set undofile

set backupdir=$HOME/vimfiles/tmp/backup//
set directory=$HOME/vimfiles/tmp/swap//
set undodir=$HOME/vimfiles/tmp/undo//


syntax enable
set background=dark
try
  colorscheme solarized
catch
endtry

if !has('win32') && !has('win64')
  setglobal shell=/bin/bash
endif

if exists('&termguicolors')
  setglobal termguicolors
endif

if exists('&completeslash')
  setglobal completeslash=slash
endif

" git commit 時にはプラグインは読み込まない
if $HOME != $USERPROFILE && $GIT_EXEC_PATH != ''
  finish
end

" Windows の場合は必要なパスを追加しておく
if has('win32')
  let $PATH='c:\dev\vim;c:\msys64\mingw64\bin;c:\msys64\usr\bin;'
  \ .'c:\Program Files\Java\jdk1.8.0_221\bin;'.$PATH
endif


packadd vim-jetpack
call jetpack#begin()
Jetpack 'tani/vim-jetpack', {'opt': 1} "bootstrap
Jetpack 'mattn/emmet-vim'
Jetpack 'ctrlpvim/ctrlp.vim'

Jetpack 'tpope/vim-fugitive'
Jetpack 'tpope/vim-surround'
Jetpack 'tpope/vim-rhubarb'

Jetpack 'prabirshrestha/asyncomplete.vim'
Jetpack 'prabirshrestha/asyncomplete-lsp.vim'
Jetpack 'prabirshrestha/vim-lsp'
Jetpack 'mattn/vim-lsp-settings'
Jetpack 'mattn/vim-lsp-icons'

Jetpack 'hrsh7th/vim-vsnip'
Jetpack 'hrsh7th/vim-vsnip-integ'

Jetpack 'vim-skk/eskk.vim'

Jetpack 'mattn/vim-findroot'
Jetpack 'lambdalisue/fern.vim'

Jetpack 'glidenote/memolist.vim'

call jetpack#end()

" 各種設定の読み込み
call map(sort(split(globpath(&runtimepath, '_config/*.vim'))), {->[execute('exec "so" v:val')]})
