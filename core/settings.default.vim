" ---------------------------
" Basic editor settings
" ---------------------------
set encoding=utf-8
set number
set autoindent
set smartindent
set tabstop=2
set shiftwidth=2
set expandtab
set foldmethod=syntax
set foldlevelstart=99
set termguicolors
syntax on
set background=dark

" Completion & UI tweaks
set completeopt=menu,menuone,noselect
set shortmess+=c
set updatetime=300

" Modern UI enhancements
set cursorline
set signcolumn=yes
set cmdheight=1
set showmatch
set matchtime=2
set scrolloff=5
set sidescrolloff=5

" Better search
set ignorecase
set smartcase
set incsearch
set hlsearch

" File handling
set hidden
set autoread
set confirm
set backup
set backupdir=~/.config/vim/backups/
set directory=~/.config/vim/swaps/
set undodir=~/.config/vim/undo/
set undofile
set timeout

" Create directories if they don't exist
silent! call mkdir(expand('~/.config/vim/backups'), 'p')
silent! call mkdir(expand('~/.config/vim/swaps'), 'p')
silent! call mkdir(expand('~/.config/vim/undo'), 'p')
