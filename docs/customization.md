# Customization Guide

Learn how to customize and personalize your Vim configuration.

## 📚 Table of Contents

- [Getting Started](#getting-started)
- [Changing Themes](#changing-themes)
- [Custom Key Mappings](#custom-key-mappings)
- [Adding Plugins](#adding-plugins)
- [Language Configuration](#language-configuration)
- [Editor Settings](#editor-settings)
- [Coc Configuration](#coc-configuration)
- [Creating Profiles](#creating-profiles)
- [Best Practices](#best-practices)

## 🚀 Getting Started

### Understanding the Structure

Before customizing, familiarize yourself with the structure:

```
~/.config/vim/
├── init.vim              # Main entry point
├── core/                 # Core configuration
│   ├── settings.vim     # Editor settings
│   ├── mappings.vim     # Key mappings
│   └── plugins.vim      # Plugin list
├── langs/                # Language configs
├── utils/                # Utility configs
└── coc-settings.json    # LSP configuration
```

### Create Custom Configuration File

Create a personal customization file that won't be overwritten:

```bash
# Create custom config
vim ~/.config/vim/utils/custom.vim
```

Add to `init.vim`:

```vim
" Load custom configuration (add at the end)
if filereadable(expand('~/.config/vim/utils/custom.vim'))
    source ~/.config/vim/utils/custom.vim
endif
```

## 🎨 Changing Themes

### Available Themes

The configuration includes:

- **Gruvbox** (default) - Retro groove color scheme
- **Seoul256** - Low-contrast color scheme

### Switch Theme

**Method 1: Edit ui.vim**

```bash
vim ~/.config/vim/utils/ui.vim
```

Find and change:

```vim
" Change from:
colorscheme gruvbox

" To:
colorscheme seoul256
```

**Method 2: In custom.vim**

```vim
" ~/.config/vim/utils/custom.vim
colorscheme seoul256
set background=dark  " or light
```

### Install New Theme

**1. Add theme plugin:**

```bash
vcfg add dracula/vim
# or
vcfg add joshdick/onedark.vim
# or
vcfg add arcticicestudio/nord-vim
```

**2. Activate theme:**

```vim
" In utils/custom.vim
colorscheme dracula
" or
colorscheme onedark
" or
colorscheme nord
```

**3. Reload Vim:**

```vim
:source ~/.vimrc
```

### Customize Theme Colors

```vim
" Override specific colors
highlight Normal guibg=#1d2021
highlight LineNr guifg=#928374
highlight Comment guifg=#928374 gui=italic
```

### Popular Theme Suggestions

| Theme       | Plugin                             | Style            |
| ----------- | ---------------------------------- | ---------------- |
| Gruvbox     | `morhetz/gruvbox`                  | Retro, warm      |
| Dracula     | `dracula/vim`                      | Dark, purple     |
| One Dark    | `joshdick/onedark.vim`             | Modern, balanced |
| Nord        | `arcticicestudio/nord-vim`         | Arctic, bluish   |
| Solarized   | `altercation/vim-colors-solarized` | Classic          |
| Tokyo Night | `folke/tokyonight.nvim`            | Modern, vibrant  |
| Catppuccin  | `catppuccin/vim`                   | Pastel           |

## ⌨️ Custom Key Mappings

### Using vcfg editmap

```bash
# Interactive editor
vcfg editmap

# Add specific mapping
vcfg editmap add '<leader>custom' ':YourCommand<CR>'

# List all mappings
vcfg editmap list
```

### Manual Mapping Configuration

**In utils/custom.vim:**

```vim
" Custom mappings

" Quick save with Ctrl+S
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a

" Quick quit
nnoremap <leader>Q :qa!<CR>

" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

" Split navigation (alternative)
nnoremap <leader>h <C-w>h
nnoremap <leader>j <C-w>j
nnoremap <leader>k <C-w>k
nnoremap <leader>l <C-w>l

" Resize splits
nnoremap <C-Up> :resize +2<CR>
nnoremap <C-Down> :resize -2<CR>
nnoremap <C-Left> :vertical resize -2<CR>
nnoremap <C-Right> :vertical resize +2<CR>

" Tab navigation
nnoremap <leader>1 1gt
nnoremap <leader>2 2gt
nnoremap <leader>3 3gt

" Quick replace word under cursor
nnoremap <leader>rw :%s/\<<C-r><C-w>\>//g<Left><Left>

" Toggle spell check
nnoremap <leader>sp :se.config spell!<CR>

" Copy entire file
nnoremap <leader>ya ggVGy

" Center search results
nnoremap n nzzzv
nnoremap N Nzzzv
```

### Mapping Conventions

```vim
" Different modes
nnoremap  " Normal mode
inoremap  " Insert mode
vnoremap  " Visual mode
xnoremap  " Visual block mode
tnoremap  " Terminal mode

" Non-recursive (recommended)
nnoremap  " Don't remap
noremap   " Never remap

" Silent mappings
nnoremap <silent> <leader>w :w<CR>
```

## 🔌 Adding Plugins

### Using vcfg

```bash
# Search for plugins
vcfg search "file explorer"
vcfg search "git integration"

# Add plugin
vcfg add tpope/vim-fugitive
vcfg add preservim/nerdcommenter

# Get plugin info
vcfg info nerdtree

# Update plugins
vcfg update
```

### Manual Plugin Addition

**1. Edit core/plugins.vim:**

```bash
vim ~/.config/vim/core/plugins.vim
```

**2. Add plugin declaration:**

```vim
" Add before call plug#end()
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'preservim/nerdcommenter'
```

**3. Install plugins:**

```vim
:PlugInstall
```

### Lazy Loading Plugins

Improve performance by lazy loading:

```vim
" Load on command
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" Load on filetype
Plug 'plasticboy/vim-markdown', { 'for': 'markdown' }

" Load on event
Plug 'vim-airline/vim-airline', { 'on': [] }
```

### Recommended Plugins

#### Productivity

```vim
" Surround text objects
Plug 'tpope/vim-surround'

" Comment code easily
Plug 'preservim/nerdcommenter'

" Multiple cursors
Plug 'terryma/vim-multiple-cursors'

" Undo tree visualizer
Plug 'mbbill/undotree'

" Session management
Plug 'tpope/vim-obsession'
```

#### Navigation

```vim
" Jump to any location
Plug 'easymotion/vim-easymotion'

" File explorer alternatives
Plug 'kyazdani42/nvim-tree.lua'  " For Neovim

" Tag bar
Plug 'preservim/tagbar'
```

#### Git

```vim
" Git wrapper
Plug 'tpope/vim-fugitive'

" Git diff in gutter
Plug 'airblade/vim-gitgutter'

" GitHub integration
Plug 'tpope/vim-rhubarb'
```

#### Code Quality

```vim
" Syntax checking
Plug 'dense-analysis/ale'

" EditorConfig support
Plug 'editorconfig/editorconfig-vim'

" Prettier formatting
Plug 'prettier/vim-prettier'
```

#### UI Enhancements

```vim
" Status line alternatives
Plug 'itchyny/lightline.vim'

" Start screen
Plug 'mhinz/vim-startify'

" Icons
Plug 'ryanoasis/vim-devicons'

" Indent guides
Plug 'Yggdroot/indentLine'
```

## 🌐 Language Configuration

### Adding New Language

**1. Create language config:**

```bash
vim ~/.config/vim/langs/rust.vim
```

**2. Add configuration:**

```vim
" Rust configuration

" File type detection
autocmd BufNewFile,BufRead *.rs set filetype=rust

" Indentation
autocmd FileType rust se.config tabstop=4 shiftwidth=4 expandtab

" Key mappings
autocmd FileType rust nnoremap <leader>rb :!cargo build<CR>
autocmd FileType rust nnoremap <leader>rr :!cargo run<CR>
autocmd FileType rust nnoremap <leader>rt :!cargo test<CR>
autocmd FileType rust nnoremap <leader>rc :!cargo check<CR>

" Formatting
autocmd FileType rust nnoremap <leader>fmt :!rustfmt %<CR>

" LSP
" Install: :CocInstall coc-rust-analyzer
```

**3. Load in init.vim:**

```vim
" Add to init.vim
runtime! langs/rust.vim
```

**4. Install LSP:**

```vim
:CocInstall coc-rust-analyzer
```

### Customize Existing Language

**Override in custom.vim:**

```vim
" Custom Python configuration
autocmd FileType python se.config tabstop=2 shiftwidth=2

" Custom JavaScript configuration
autocmd FileType javascript,typescript nnoremap <leader>test :!npm test<CR>

" Custom C++ configuration
autocmd FileType cpp nnoremap <leader>build :!g++ -std=c++17 % -o %:r<CR>
```

## ⚙️ Editor Settings

### Common Customizations

```vim
" ~/.config/vim/utils/custom.vim

" Tab settings
set tabstop=2       " 2 spaces for tab
set shiftwidth=2    " 2 spaces for indent
set expandtab       " Use spaces instead of tabs

" Line numbers
set number          " Show line numbers
set relativenumber  " Show relative line numbers

" Search settings
set ignorecase      " Case insensitive search
set smartcase       " Case sensitive if uppercase used
set hlsearch        " Highlight search results
set incsearch       " Incremental search

" UI settings
set cursorline      " Highlight current line
set colorcolumn=80  " Show column at 80 characters
set wrap            " Wrap lines
set linebreak       " Break at word boundaries

" Clipboard
set clipboard=unnamedplus  " Use system clipboard

" Backup
set nobackup        " Don't create backup files
set noswapfile      " Don't create swap files
set undofile        " Enable persistent undo
set undodir=~/.vim/undo  " Undo directory

" Split behavior
set splitbelow      " Horizontal splits below
set splitright      " Vertical splits right

" Performance
set lazyredraw      " Don't redraw during macros
set updatetime=300  " Faster completion

" Mouse
set mouse=a         " Enable mouse support

" Folding
set foldmethod=indent  " Fold based on indent
set foldlevelstart=99  " Open all folds by default
```

### Project-Specific Settings

Use `.lvimrc` or `.vimrc.config`:

```vim
" .lvimrc in project root
set tabstop=4
set shiftwidth=4
nnoremap <leader>t :!npm test<CR>
```

Enable.config vimrc:

```vim
" In utils/custom.vim
set exrc      " Enable.config vimrc
set secure    " Restrict unsafe commands
```

## 🎯 Coc Configuration

### Edit Coc Settings

```vim
:CocConfig
```

### Common Customizations

```json
{
  "suggest.maxCompleteItemCount": 20,
  "suggest.timeout": 500,
  "suggest.enablePreview": true,
  "diagnostic.level": "warning",
  "diagnostic.enableMessage": "jump",
  "coc.preferences.formatOnSaveFiletypes": [
    "javascript",
    "typescript",
    "json",
    "html",
    "css",
    "python"
  ],
  "prettier.tabWidth": 2,
  "prettier.singleQuote": true,
  "python.formatting.provider": "black",
  "python.linting.enabled": true,
  "python.linting.pylintEnabled": false,
  "python.linting.flake8Enabled": true,
  "typescript.preferences.importModuleSpecifier": "relative"
}
```

### Add Custom Language Server

```json
{
  "languageserver": {
    "golang": {
      "command": "gopls",
      "rootPatterns": ["go.mod"],
      "filetypes": ["go"]
    },
    "rust": {
      "command": "rust-analyzer",
      "filetypes": ["rust"],
      "rootPatterns": ["Cargo.toml"]
    }
  }
}
```

## 📋 Creating Profiles

### Development Profiles

Create different configurations for different workflows:

**1. Minimal Profile:**

```bash
# Create minimal config
vim ~/.config/vim/profiles/minimal.vim
```

```vim
" Minimal configuration
let g:minimal_mode = 1

" Disable heavy plugins
let g:loaded_copilot = 1
let g:coc_start_at_startup = 0

" Basic mappings only
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
```

**2. Web Dev Profile:**

```bash
vim ~/.config/vim/profiles/webdev.vim
```

```vim
" Web development profile
let g:web_dev_mode = 1

" Enable specific plugins
let g:coc_enabled_extensions = [
  \ 'coc-tsserver',
  \ 'coc-prettier',
  \ 'coc-eslint'
  \ ]

" Custom mappings
nnoremap <leader>nd :!npm run dev<CR>
nnoremap <leader>nb :!npm run build<CR>
```

**3. Load Profile:**

```vim
" In init.vim or custom.vim
if $VIM_PROFILE == 'minimal'
    source ~/.config/vim/profiles/minimal.vim
elseif $VIM_PROFILE == 'webdev'
    source ~/.config/vim/profiles/webdev.vim
endif
```

```bash
# Use profile
VIM_PROFILE=minimal vim
VIM_PROFILE=webdev vim
```

## 🎨 Status Line Customization

### Customize Airline

```vim
" ~/.config/vim/utils/custom.vim

" Theme
let g:airline_theme='gruvbox'

" Sections
let g:airline_section_a = airline#section#create(['mode'])
let g:airline_section_b = airline#section#create(['branch'])
let g:airline_section_c = airline#section#create(['%f'])

" Show buffers
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#formatter = 'unique_tail'

" Symbols
if !exists('g:airline_symbols')
    let g:airline_symbols = {}
endif
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''
```

## 📝 Auto Commands

### Custom Auto Commands

```vim
" ~/.config/vim/utils/custom.vim

" Auto-save on focus lost
autocmd FocusLost * silent! wa

" Remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

" Return to last edit position
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal! g`\"" |
  \ endif

" Auto-create parent directories
autocmd BufWritePre *
  \ if !isdirectory(expand('<afile>:p:h')) |
  \   call mkdir(expand('<afile>:p:h'), 'p') |
  \ endif

" Format on save for specific files
autocmd BufWritePre *.js,*.jsx,*.ts,*.tsx Prettier

" Highlight on yank
autocmd TextYankPost * silent! lua vim.highlight.on_yank()
```

## 🔧 Custom Functions

### Create Useful Functions

```vim
" ~/.config/vim/utils/custom.vim

" Toggle between absolute and relative line numbers
function! ToggleLineNumbers()
    if &relativenumber
        set norelativenumber
        set number
    else
        set relativenumber
    endif
endfunction
nnoremap <leader>tn :call ToggleLineNumbers()<CR>

" Strip trailing whitespace
function! StripTrailingWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction
nnoremap <leader>sw :call StripTrailingWhitespace()<CR>

" Open terminal in split
function! OpenTerminal()
    split
    terminal
    resize 15
endfunction
nnoremap <leader>term :call OpenTerminal()<CR>

" Quick note taking
function! QuickNote()
    let l:note_file = '~/notes/' . strftime('%Y-%m-%d') . '.md'
    execute 'edit' l:note_file
endfunction
nnoremap <leader>note :call QuickNote()<CR>
```

## 💡 Best Practices

### Do's

✅ **Use custom.vim** for personal settings
✅ **Test changes** before committing
✅ **Document your customizations**
✅ **Use version control** for your custom configs
✅ **Keep it modular** - separate concerns
✅ **Backup before major changes**
✅ **Use vcfg** for plugin management
✅ **Check performance** with `:profile`

### Don'ts

❌ **Don't modify core files directly** - use custom.vim
❌ **Don't add too many plugins** - affects performance
❌ **Don't ignore errors** - check `:messages`
❌ **Don't skip documentation** - comment your code
❌ **Don't forget to test** - on different file types
❌ **Don't hardcode paths** - use relative or `expand()`

## 🔄 Syncing Configuration

### Git-Based Sync

**1. Initialize git:**

```bash
cd ~/.config/vim
git init
git add .
git commit -m "Initial configuration"
git remote add origin your-repo-url
git push -u origin main
```

**2. On another machine:**

```bash
git clone your-repo-url ~/.config/vim
```

**3. Keep in sync:**

```bash
# Push changes
cd ~/.config/vim
git add .
git commit -m "Updated configuration"
git push

# Pull changes
git pull
```

### Exclude Sensitive Data

```bash
# .gitignore
plugged/
.netrwhist
*.swp
*.swo
*~
coc-settings.json
utils/custom.vim
```

## 📚 Examples

### Complete Custom Configuration Example

```vim
" ~/.config/vim/utils/custom.vim

" ============================================================================
" Personal Vim Configuration
" ============================================================================

" Theme
colorscheme gruvbox
set background=dark

" Editor Settings
set tabstop=2 shiftwidth=2 expandtab
set number relativenumber
set cursorline
set colorcolumn=100
set clipboard=unnamedplus

" Custom Mappings
nnoremap <C-s> :w<CR>
inoremap <C-s> <Esc>:w<CR>a
nnoremap <leader>Q :qa!<CR>
nnoremap <leader>sw :call StripTrailingWhitespace()<CR>

" Language Specific
autocmd FileType python se.config tabstop=4 shiftwidth=4
autocmd FileType go se.config tabstop=4 noexpandtab

" Custom Functions
function! StripTrailingWhitespace()
    let l:save = winsaveview()
    keeppatterns %s/\s\+$//e
    call winrestview(l:save)
endfunction

" Auto Commands
autocmd BufWritePre * call StripTrailingWhitespace()
autocmd FocusLost * silent! wa

" Custom Commands
command! -nargs=1 Search vimgrep /<args>/ **/*
command! Todo vimgrep /TODO\|FIXME/ **/*

" Project Specific
if filereadable('.lvimrc')
    source .lvimrc
endif
```

---

[← Back to Main README](../README.md) | [Troubleshooting →](troubleshooting.md)
