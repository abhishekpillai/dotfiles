" ############
set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'gmarik/Vundle.vim'

Plugin 'flazz/vim-colorschemes'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-surround'

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
" ############ ^GOT THIS SECTION FROM https://github.com/gmarik/Vundle.vim#quick-start

syntax on               " syntax highlighting
colorscheme jellybeans

set autoindent
set autoread            " reload files when changed on disk, i.e. via `git checkout`
set backspace=2         " Fix broken backspace in some setups
set backupcopy=yes      " see :help crontab
set clipboard=unnamed   " yank and paste with the system clipboard
set directory-=.        " don't store swapfiles in the current directory
set encoding=utf-8
set expandtab           " expand tabs to spaces
set list                " show trailing whitespace
set listchars=tab:▸\ ,trail:▫
set number              " show line numbers
set nobackup            " get rid of anoying ~file 
set ruler               " show where you are
set shiftwidth=2        " normal mode indentation commands use 2 spaces
set scrolloff=3         " show context above/below cursorline
set softtabstop=2                                            " insert mode tab and backspace use 2 spaces
