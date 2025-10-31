# Performance Optimization Guide

Tips and tricks to make Vim blazingly fast.

## 📚 Table of Contents

- [Measuring Performance](#-measuring-performance)
- [Startup Time Optimization](#-startup-time-optimization)
- [Plugin Optimization](#-plugin-optimization)
- [LSP Performance](#-lsp-performance)
- [Syntax Highlighting](#-syntax-highlighting)
- [Memory Usage](#-memory-usage)
- [Termux-Specific Optimization](#-termux-specific-optimization)
- [Best Practices](#-best-practices)

## 📊 Measuring Performance

### Startup Time

```bash
# Measure total startup time
vim --startuptime startup.log
less startup.log

# Find slowest components
grep -v "0\.0" startup.log | sort -k2 -n | tail -20

# Compare startup times
time vim +qall
```

### Runtime Performance

```vim
" Profile runtime
:profile start profile.log
:profile func *
:profile file *
" Do some actions
:profile pause
:noautocmd qall!

" View results
:!less profile.log
```

### Memory Usage

```vim
" Check memory usage
:echo getpid()
" Then in terminal: ps aux | grep [pid]

" Check loaded scripts
:scriptnames

" Check plugin count
:echo len(g:plugs)
```

### Using vcfg Doctor

```bash
# Comprehensive health and performance check
vcfg doctor

# Output includes:
# - Startup time
# - Plugin count
# - Memory usage
# - Slow plugins
# - Recommendations
```

## 🚀 Startup Time Optimization

### Lazy Loading Plugins

Edit `~/.config/vim/core/plugins.vim`:

```vim
" Load on command
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'junegunn/fzf.vim', { 'on': ['Files', 'Rg', 'Buffers'] }

" Load on filetype
Plug 'fatih/vim-go', { 'for': 'go' }
Plug 'rust-lang/rust.vim', { 'for': 'rust' }
Plug 'pangloss/vim-javascript', { 'for': ['javascript', 'typescript'] }

" Load on event
Plug 'neoclide/coc.nvim', { 'branch': 'release', 'event': 'InsertEnter' }

" Load on condition
Plug 'github/copilot.vim', { 'on': [], 'do': ':Copilot setup' }
```

### Disable Unused Plugins

```bash
# List all plugins
vcfg list

# Disable unused plugins
vcfg disable <plugin-name>

# Disable all slow plugins
vcfg disable slow_plugins

# Plugins commonly safe to disable:
vcfg disable copilot.vim        # If not using AI completion
vcfg disable vim-gitgutter       # If not using git features
vcfg disable nerdcommenter       # If using built-in commenting
```

### Optimize Plugin Loading Order

```vim
" Load essential plugins first
call plug#begin()

" 1. Color scheme (needed immediately)
Plug 'morhetz/gruvbox'

" 2. UI essentials
Plug 'vim-airline/vim-airline'

" 3. Core functionality
Plug 'junegunn/fzf.vim'

" 4. Language support (lazy loaded)
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" 5. Optional features (lazy loaded)
Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }

call plug#end()
```

### Defer Non-Essential Settings

```vim
" Use autocmd VimEnter for non-critical settings
autocmd VimEnter * call SetupExtras()

function! SetupExtras()
    " Load heavy configurations after startup
    runtime! utils/extra-features.vim
endfunction
```

## 🔌 Plugin Optimization

### Remove Duplicate Functionality

```vim
" Bad: Multiple file explorers
Plug 'preservim/nerdtree'
Plug 'scrooloose/nerdtree'  " Duplicate!
Plug 'ms-jpq/chadtree'       " Duplicate!

" Good: Choose one
Plug 'preservim/nerdtree'
```

### Minimize Plugin Count

```bash
# Current plugin count
vcfg list | wc -l

# Target: < 30 plugins for best performance
# Recommended: 15-25 plugins
```

### Plugin Alternatives (Lighter Options)

| Heavy Plugin | Lighter Alternative       | Performance Gain      |
| ------------ | ------------------------- | --------------------- |
| coc.nvim     | vim-lsp                   | 30-40% faster startup |
| NERDTree     | netrw (built-in)          | 50% less memory       |
| vim-airline  | lightline.vim             | 20% faster rendering  |
| copilot.vim  | Disable when not needed   | 25% faster startup    |
| vim-polyglot | Individual syntax plugins | 40% less memory       |

### Disable Heavy Features

```vim
" In coc-settings.json
{
  "suggest.maxCompleteItemCount": 20,  // Reduce from 50
  "diagnostic.refreshOnInsertMode": false,
  "suggest.timeout": 500,
  "diagnostic.virtualText": false  // Disable inline diagnostics
}
```

## 🔧 LSP Performance

### Optimize Coc.nvim

```json
// ~/.config/vim/coc-settings.json
{
  // Reduce completion items
  "suggest.maxCompleteItemCount": 20,
  "suggest.timeout": 500,
  "suggest.minTriggerInputLength": 2,

  // Disable features you don't use
  "diagnostic.virtualText": false,
  "diagnostic.refreshOnInsertMode": false,
  "codeLens.enable": false,
  "suggest.enablePreview": false,

  // Limit file watching
  "workspace.maxFileSize": 2,
  "workspace.bottomUpFiletypes": ["javascript", "typescript"],

  // Performance settings
  "diagnostic.checkCurrentLine": true,
  "diagnostic.displayByAle": false
}
```

### Disable Unused Language Servers

```vim
" List installed extensions
:CocList extensions

" Disable unused ones
:CocUninstall coc-phpls  " If not using PHP
:CocUninstall coc-java   " If not using Java
```

### Language Server Memory Limits

```json
{
  "languageserver": {
    "golang": {
      "command": "gopls",
      "args": ["-mode=stdio"],
      "initializationOptions": {
        "memoryMode": "DegradeClosed"
      }
    }
  }
}
```

## 🎨 Syntax Highlighting

### Optimize Syntax Settings

```vim
" Limit syntax synchronization
syntax sync minlines=256
syntax sync maxlines=512

" Disable slow regex patterns
set regexpengine=1  " Old engine (sometimes faster)
" or
set regexpengine=2  " New engine (usually better)

" Test which is faster for your files
```

### Reduce Syntax Complexity

```vim
" Disable complex syntax features
let g:vimsyn_embed = 0
let g:markdown_fenced_languages = ['javascript', 'python']  " Limit to needed langs

" For large files, disable syntax
autocmd BufReadPost * if line('$') > 5000 | syntax off | endif
```

### Use Simpler Color Schemes

```vim
" Lighter themes are faster
colorscheme seoul256  " Simpler colors
" vs
colorscheme gruvbox   " More complex

" Disable true colors if not needed
set notermguicolors
```

## 💾 Memory Usage

### Reduce Buffer Memory

```vim
" Limit buffer history
set viminfo='20,<50,s10

" Reduce undo levels for large files
autocmd BufReadPost * if line('$') > 1000 | set undolevels=100 | endif

" Disable swap files (risky!)
set noswapfile

" Or use memory for swap
set directory=/tmp
```

### Limit Open Buffers

```vim
" Auto-close unused buffers
set hidden
set bufhidden=delete

" Limit buffer count
autocmd BufAdd * if len(getbufinfo({'buflisted':1})) > 10 | execute 'bdelete' getbufinfo({'buflisted':1})[0].bufnr | endif
```

### Clean Up Regularly

```bash
# Clean plugin cache
vcfg clean

# Remove unused plugins
rm -rf ~/.vim/plugged/unused-plugin

# Clear Coc cache
rm -rf ~/.config/coc/extensions/node_modules
```

## 📱 Termux-Specific Optimization

### Reduce Resource Usage

```vim
" Termux-specific settings in utils/termux.vim

" Lighter UI
let g:airline#extensions#tabline#enabled = 0
set noshowmode  " Don't show mode (airline shows it)

" Reduce update frequency
set updatetime=1000  " Increase from 300

" Disable mouse (saves processing)
set mouse=

" Simpler diff mode
set diffopt+=internal,algorithm:patience
```

### Optimize for Mobile

```vim
" Faster rendering
set lazyredraw
set ttyfast

" Reduce history
set history=100  " Default is 10000

" Limit syntax sync
autocmd Syntax * syntax sync minlines=64 maxlines=128
```

### Battery Saving

```vim
" Disable auto-save
set noautowrite

" Increase write delay
set updatetime=2000

" Disable continuous features
let g:gitgutter_enabled = 0  " Disable git gutter
let g:coc_start_at_startup = 0  " Manual Coc start
```

## 🎯 Best Practices

### Profile First, Optimize Second

```bash
# Always measure before optimizing
vim --startuptime before.log +qall
# Make changes
vim --startuptime after.log +qall
# Compare
diff before.log after.log
```

### Progressive Enhancement

Start minimal, add features as needed:

```vim
" Level 1: Minimal (fastest)
" - No plugins
" - Basic settings only

" Level 2: Essential (fast)
" - FZF for search
" - Basic LSP
" - Simple theme

" Level 3: Productive (balanced)
" - Completion
" - File explorer
" - Git integration

" Level 4: Full Featured (slower)
" - All plugins
" - AI completion
" - Advanced integrations
```

### Use Built-in Features

```vim
" Instead of plugins, use built-in features:

" File explorer: use netrw instead of NERDTree
let g:netrw_banner = 0
let g:netrw_liststyle = 3

" Fuzzy search: use :find with path
set path+=**
set wildmenu

" Auto-pairs: use built-in
inoremap ( ()<Left>
inoremap [ []<Left>
inoremap { {}<Left>
```

### Optimize Frequently

```bash
# Weekly optimization routine
vcfg doctor                    # Health check
vcfg clean                     # Remove unused
vcfg disable slow_plugins      # Disable heavy plugins
vim --startuptime startup.log  # Measure impact
```

## 📈 Performance Targets

### Startup Time Goals

| Configuration | Target Startup Time |
| ------------- | ------------------- |
| Minimal       | < 50ms              |
| Light         | < 100ms             |
| Standard      | < 200ms             |
| Full Featured | < 400ms             |
| Heavy         | < 600ms             |

### Memory Usage Goals

| Configuration | Target Memory |
| ------------- | ------------- |
| Minimal       | < 20 MB       |
| Light         | < 50 MB       |
| Standard      | < 100 MB      |
| Full Featured | < 200 MB      |

### Plugin Count Guidelines

| Type          | Plugin Count |
| ------------- | ------------ |
| Minimal       | 0-5          |
| Light         | 5-15         |
| Standard      | 15-25        |
| Full Featured | 25-35        |
| Too Many      | > 35         |

## 🔍 Performance Checklist

Before asking "Why is Vim slow?", check:

- [ ] Run `vcfg doctor`
- [ ] Profile startup time
- [ ] Count plugins (< 30 recommended)
- [ ] Check for slow plugins
- [ ] Review Coc settings
- [ ] Test with minimal config
- [ ] Check file size (syntax off for > 5000 lines)
- [ ] Verify no duplicate plugins
- [ ] Clean unused plugins
- [ ] Check memory usage

## 🛠️ Quick Fixes

### Instant Speed Improvements

```bash
# 1. Disable slow plugins
vcfg disable slow_plugins

# 2. Reduce Coc completions
# In :CocConfig
{
  "suggest.maxCompleteItemCount": 20
}

# 3. Lazy load heavy plugins
# In core/plugins.vim
Plug 'plugin/name', { 'on': 'Command' }

# 4. Disable unused language servers
:CocList extensions
# Disable unused ones

# 5. Clean up
vcfg clean
```

### Emergency Performance Mode

```vim
" Add to vimrc for emergency fast mode
if exists('g:performance_mode')
    " Disable all plugins
    let g:loaded_plugins = 1

    " Minimal settings
    syntax off
    set noshowmatch
    set nocursorline
    set lazyredraw

    " Disable Coc
    let g:coc_start_at_startup = 0
endif

" Start with: vim -c "let g:performance_mode=1"
```

## 📊 Benchmarking Results

### Before Optimization

```
Startup time: 450ms
Plugins: 42
Memory: 180 MB
```

### After Optimization

```
Startup time: 180ms (-60%)
Plugins: 24
Memory: 90 MB (-50%)
```

### Optimization Applied

- Lazy loaded 15 plugins
- Disabled 8 unused plugins
- Reduced Coc completion items
- Optimized syntax settings

---

[← Back to Main README](../README.md) | [Termux Guide →](termux.md)
