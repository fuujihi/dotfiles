" colorscheme
colorscheme iceberg 
set termguicolors

" encode setting
set encoding=utf-8

" editer setting
set number " 行番号表示
set wildmenu " コマンドモードの補完
set autoindent " 改行時にインデント
set clipboard=unnamed  "yankでクリップボードにコピー
set hls " 検索した結果をハイライト
let g:webdevicons_enable_nerdtree = 1 " ツリーにアイコン表示
" ;でコマンド入力
noremap ; :

" NERDTree setting
map <C-e> :NERDTreeToggle<CR>
let NERDTreeShowHidden = 1
autocmd VimEnter * execute 'NERDTree'


" cursorl setting
set ruler " カーソルの位置表示
set cursorline " カーソルハイライト
set mouse=a " マウス操作有効化


" tab setting
set expandtab "tabを複数のspaceに置き換え
set tabstop=2  "tabは半角2文字
set shiftwidth=2 "tabの幅

let g:airline_theme='iceberg'
let g:airline#extensions#tabline#enabled=1
let g:airline_powerline_fonts=1


"dein Scripts-----------------------------
if &compatible
  set nocompatible               " Be iMproved
endif

" Required:
set runtimepath+=/Users/hinata/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
call dein#begin('/Users/hinata/.cache/dein')

" Let dein manage dein
" Required:
" call dein#add('/Users/hinata/.cache/dein/repos/github.com/Shougo/dein.vim')

let s:config_dir = expand('~/.config/nvim/dein')
call dein#load_toml(s:config_dir . '/dein.toml', {'lazy': 0})

" Add or remove your plugins here like this:
" call dein#add('')


" Required:
call dein#end()

" Required:
filetype plugin indent on
syntax enable

" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif
"End dein Scripts-------------------------

