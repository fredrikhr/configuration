set dir=$TEMP,/tmp/vim/swap,/tmp/vim,/tmp
set bdir=$TEMP,/tmp/vim/backup,/tmp/vim,/tmp
set undodir=$TEMP,/tmp/vim/undo,/tmp/vim,/tmp

set encoding=utf-8
set number
" set relativenumber
syntax on
colorscheme darkblue

set tabstop=4
set softtabstop=0 noexpandtab
set shiftwidth=4
set smarttab
set backspace=2 " make backspace work like most other apps

" Render Whitespace
set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<
set list

set autoindent
filetype plugin indent on

set nocompatible              " be iMproved, required
filetype off                  " required

" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" dispatch.vim
Plugin 'tpope/vim-dispatch'

" Syntastic
Plugin 'scrooloose/syntastic'

" NeoComplete
" Plugin 'Shougo/neocomplete.vim'

" OmniSharp Vim
" Plugin 'OmniSharp/omnisharp-vim'

" Vim-JSON
Plugin 'elzr/vim-json'

Plugin 'ctrlpvim/ctrlp.vim'

Plugin 'zah/nim.vim'
" Plugin 'baabelfish/nvim-nim'

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

" -----------------------------------------------------------------------------
" Syntastic recommended settings

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

" Syntastic recommended settings -- END
" -----------------------------------------------------------------------------

" -----------------------------------------------------------------------------
"  VIM-JSON Configuration
let g:vim_json_syntax_conceal = 0
" -----------------------------------------------------------------------------

