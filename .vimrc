set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-fugitive'
Plugin 'flazz/vim-colorschemes'
Plugin 'rking/ag.vim'
Plugin 'tpope/vim-rails'
Plugin 'tpope/vim-surround'
Plugin 'pangloss/vim-javascript'
Plugin 'mxw/vim-jsx'
" Plugin 'scrooloose/syntastic' " not working well?
Plugin 'digitaltoad/vim-jade'
Plugin 'slim-template/vim-slim.git'
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'wakatime/vim-wakatime'
Plugin 'xolox/vim-misc'
Plugin 'xolox/vim-notes'
Plugin 'alvan/vim-closetag'

" React snippets
  " vim-react-snippets:
  Plugin 'justinj/vim-react-snippets'
  " SnipMate and its dependencies:
  Plugin 'MarcWeber/vim-addon-mw-utils'
  Plugin 'tomtom/tlib_vim'
  Plugin 'garbas/vim-snipmate'

  " Other sets of snippets
  Plugin 'honza/vim-snippets'


" All of your Plugins must be added before the following line
call vundle#end()            " required
filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
" see :h vundle for more details or wiki for FAQ
" Put your non-Plugin stuff after this line

syntax on
colorscheme jellybeans

set autoindent
set autoread
set clipboard=unnamed
set directory-=.
set encoding=utf-8
set expandtab
"set list
set number
set nobackup
set ruler
set shiftwidth=2
set scrolloff=3
set softtabstop=2
set foldmethod=indent
set nowrap
set list                " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set wildignore+=node_modules/**
set wildignore+=public/**
set wildignore+=app/assets/javascripts/bin/**

" syntastic options recommended in their Readme
" set statusline+=%#warningmsg#
" set statusline+=%{SyntasticStatuslineFlag()}
" set statusline+=%*
"
" let g:syntastic_always_populate_loc_list = 1
" let g:syntastic_auto_loc_list = 1
" let g:syntastic_check_on_open = 1
" let g:syntastic_check_on_wq = 0
"
" Use silver searcher instead of ack
let g:ackprg = 'ag --nogroup --nocolor --column'

" Increase depth of ctrlp file search
let g:ctrlp_max_files=0
let g:ctrlp_max_depth=40
let g:ctrlp_user_command = ['.git', 'cd %s && git ls-files . --cached --exclude-standard']

" for vim-notes
let g:notes_directories = ['~/Documents/Notes']

" for vim-jsx
let g:jsx_ext_required = 0

" for vim-closetag
let g:closetag_filenames = "*.html,*.xhtml,*.phtml,*.jsx"
