" ---------------------------
" Plugins (vim-plug)
" ---------------------------
" Themes / 
Plug 'morhetz/gruvbox'
Plug 'junegunn/seoul256.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Completion / LSP / IDE-like
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
" Plug 'github/copilot.vim'

" Tools
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'junegunn/vim-easy-align'
Plug 'fatih/vim-go', { 'tag': '*' }

" Web Development
Plug 'pangloss/vim-javascript'
Plug 'leafgarland/typescript-vim'
Plug 'maxmellon/vim-jsx-pretty'
Plug 'othree/html5.vim'
Plug 'prisma/vim-prisma'

" PHP/Laravel
Plug 'phpactor/phpactor', {'for': 'php', 'tag': '*', 'do': 'composer install --no-dev -o'}
Plug 'jwalton512/vim-blade'

" C/C++ Development
Plug 'bfrg/vim-cpp-modern'
Plug 'octol/vim-cpp-enhanced-highlight'
Plug 'dense-analysis/ale'

" Python
Plug 'vim-python/python-syntax'

" Tree / navigation / formatting
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'preservim/nerdcommenter'
Plug 'sbdchd/neoformat'
Plug 'ellisonleao/glow.nvim'

" Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'

" Utility
Plug 'tpope/vim-surround'
" Plug 'jiangmiao/auto-pairs'
Plug 'Raimondi/delimitMate'
