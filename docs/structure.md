# Project Structure

Understanding the Vim configuration directory structure and organization.

## 📁 Directory Overview

```
~/.config/vim/
├── init.vim                 # Main entry point
├── core/                    # Core configuration
│   ├── settings.vim        # Editor settings
│   ├── mappings.vim        # Key mappings
│   └── plugins.vim         # Plugin declarations
├── langs/                   # Language-specific configs
│   ├── web.vim             # JavaScript/TypeScript/HTML/CSS
│   ├── c.vim               # C/C++ development
│   ├── php.vim             # PHP/Laravel
│   ├── python.vim          # Python
│   ├── go.vim              # Go
│   └── bash.vim            # Shell scripting
├── frameworks/              # Framework-specific configs
│   ├── laravel.vim         # Laravel configuration
│   └── nextjs.vim          # Next.js configuration
├── utils/                   # Utility configurations
│   ├── termux.vim          # Termux optimizations
│   ├── completion.vim      # Coc completion config
│   ├── formatting.vim      # Universal formatting
│   ├── ui.vim              # Themes and UI
│   └── autopairs.vim       # Auto-pairs config
├── docs/                    # Documentation
│   ├── installation.md
│   ├── keymappings.md
│   ├── vcfg.md
│   └── ...
├── coc-settings.json       # Coc.nvim configuration
├── .gitignore              # Git ignore rules
├── LICENSE                 # MIT License
└── README.md               # Main documentation
```

## 🔧 Core Files

### init.vim

The main entry point that loads all other configuration files.

```vim
" Main configuration entry point
" Loads in this order:
" 1. Core settings
" 2. Plugins
" 3. UI configuration
" 4. Language configs
" 5. Framework configs
" 6. Utility configs
" 7. Custom mappings
```

**Purpose:** Orchestrates loading of all configuration modules

**Key sections:**

- Plugin initialization
- Module loading
- Post-configuration hooks

### core/settings.vim

Basic Vim editor settings and behaviors.

**Contains:**

- Line numbers and relative numbers
- Indentation settings (tabs, spaces)
- Search settings (highlighting, ignore case)
- Backup and swap file configuration
- Clipboard integration
- Mouse support
- File encoding
- Window splitting behavior

**Example settings:**

```vim
set number relativenumber
set tabstop=4 shiftwidth=4
set expandtab
set ignorecase smartcase
set hlsearch incsearch
```

### core/plugins.vim

Plugin declarations using vim-plug.

**Structure:**

```vim
call plug#begin('~/.vim/plugged')

" UI & Themes
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'

" Completion & LSP
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Navigation
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf.vim'

" ... more plugins

call plug#end()
```

**Categories:**

- UI/Themes
- Completion/LSP
- Navigation
- Language support
- Git integration
- Utilities

### core/mappings.vim

Global key mappings and leader key configuration.

**Contains:**

- Leader key definition (`let mapleader = " "`)
- File navigation mappings
- Window management
- Tab management
- Save/Quit shortcuts
- General utilities

## 🌐 Language Configurations

### langs/web.vim

Web development configuration (JavaScript, TypeScript, HTML, CSS).

**Features:**

- Syntax highlighting
- JSX/TSX support
- Prettier formatting
- ESLint integration
- React/Vue snippets
- Emmet shortcuts

**Key mappings:**

- `<leader>nd` - Next.js dev server
- `<leader>pd` - Prettier format
- `<leader>es` - ESLint fix

### langs/c.vim

C/C++ development configuration.

**Features:**

- Modern C++ syntax
- clangd LSP
- clang-format integration
- Compilation shortcuts
- GDB integration

**Key mappings:**

- `<leader>cc` - Compile C
- `<leader>cpp` - Compile C++
- `<leader>cr` - Run program
- `<leader>cd` - Debug with GDB

### langs/php.vim

PHP and Laravel development.

**Features:**

- PHP syntax
- Blade template support
- PHPActor LSP
- Composer integration
- Laravel Artisan shortcuts

**Key mappings:**

- `<leader>la` - Artisan command
- `<leader>ls` - Laravel serve
- `<leader>lm` - Run migrations

### langs/python.vim

Python development configuration.

**Features:**

- Python 3 syntax
- Pyright LSP
- Black formatter
- Flake8 linting
- Virtual environment support

**Key mappings:**

- `<leader>py` - Run Python
- `<leader>pf` - Format with Black
- `<leader>pt` - Run pytest

### langs/go.vim

Go development configuration.

**Features:**

- Go syntax
- gopls LSP
- gofmt/goimports
- Go modules support
- Testing integration

**Key mappings:**

- `<leader>gb` - Go build
- `<leader>gr` - Go run
- `<leader>gt` - Go test

### langs/bash.vim

Shell scripting configuration.

**Features:**

- Bash syntax
- ShellCheck linting
- shfmt formatting
- Execution shortcuts

**Key mappings:**

- `<leader>bx` - Make executable and run
- `<leader>br` - Run script
- `<leader>bc` - Syntax check

## 🎨 Framework Configurations

### frameworks/laravel.vim

Laravel-specific configuration and shortcuts.

**Features:**

- Blade syntax
- Artisan integration
- Route definitions
- Migration helpers
- Tinker support

### frameworks/nextjs.vim

Next.js specific configuration.

**Features:**

- Next.js commands
- Dev server integration
- Build shortcuts
- API route support

## 🛠️ Utility Configurations

### utils/termux.vim

Termux and mobile optimization.

**Features:**

- Touch-friendly mappings
- Alternative key bindings
- Storage access helpers
- Performance optimizations
- Mobile-specific UI tweaks

### utils/completion.vim

Coc.nvim completion configuration.

**Settings:**

- Completion sources
- Trigger behavior
- Popup menu settings
- Snippet configuration
- Language server configs

### utils/formatting.vim

Universal code formatting.

**Features:**

- Auto-format on save
- Per-filetype formatters
- Format command
- Formatter detection

**Supported formatters:**

- Prettier (JS/TS/HTML/CSS)
- Black (Python)
- clang-format (C/C++)
- gofmt (Go)
- shfmt (Bash)
- PHP CS Fixer (PHP)

### utils/ui.vim

Theme and UI configuration.

**Contains:**

- Color scheme selection
- Airline configuration
- Syntax highlighting
- Color adjustments
- Terminal colors

### utils/autopairs.vim

Auto-pairs plugin configuration.

**Features:**

- Auto-close brackets
- Auto-close quotes
- Smart deletion
- Fast wrap
- Multi-line support

## 🔧 Configuration Files

### coc-settings.json

Coc.nvim and LSP configuration.

**Location:** `~/.config/vim/coc-settings.json`

**Contains:**

```json
{
  "diagnostic.level": "warning",
  "suggest.maxCompleteItemCount": 50,
  "languageserver": {
    "go": { ... },
    "python": { ... }
  },
  "coc.preferences.formatOnSave": true
}
```

### .gitignore

Git ignore patterns.

**Ignores:**

- Plugin directory (`plugged/`)
- Swap files (`*.swp`)
- Backup files (`*~`)
- Log files
- OS-specific files

## 📦 Binary Directory

### bin/vcfg

Configuration management tool.

**Location:** `~/.config/vim/bin/vcfg`

**Features:**

- Plugin management
- System updates
- Health checks
- Key mapping editor
- Configuration profiles

**Usage:**

```bash
vcfg install
vcfg update
vcfg add <plugin>
vcfg doctor
```

## 📚 Documentation Directory

### docs/

Comprehensive documentation files.

**Files:**

- `installation.md` - Installation guide
- `keymappings.md` - Keyboard shortcuts
- `vcfg.md` - vcfg tool documentation
- `prerequisites.md` - Required packages
- `troubleshooting.md` - Problem solving
- `structure.md` - This file
- `customization.md` - Customization guide
- `languages/` - Language-specific guides

## 🔄 Loading Order

Configuration loads in this specific order:

1. **init.vim** - Entry point
2. **core/settings.vim** - Basic settings
3. **core/plugins.vim** - Plugin declarations
4. **utils/ui.vim** - Theme and UI
5. **utils/completion.vim** - Completion config
6. **utils/formatting.vim** - Formatting setup
7. **utils/autopairs.vim** - Auto-pairs config
8. **langs/\*.vim** - Language configs
9. **frameworks/\*.vim** - Framework configs
10. **utils/termux.vim** - Platform-specific (if on Termux)
11. **core/mappings.vim** - Key mappings
12. **Post-configuration hooks** - Final setup

## 📝 Adding New Configurations

### Adding New Language Support

1. Create file in `langs/` directory:

   ```bash
   touch ~/.config/vim/langs/rust.vim
   ```

2. Add language-specific settings:

   ```vim
   " langs/rust.vim
   " Rust development configuration

   " Syntax
   autocmd FileType rust se.config ...

   " Key mappings
   autocmd FileType rust nnoremap <leader>rb :!cargo build<CR>

   " LSP
   " Install: :CocInstall coc-rust-analyzer
   ```

3. Include in `init.vim`:
   ```vim
   " Load Rust configuration
   runtime! langs/rust.vim
   ```

### Adding New Framework

1. Create file in `frameworks/`:

   ```bash
   touch ~/.config/vim/frameworks/django.vim
   ```

2. Add framework config:

   ```vim
   " frameworks/django.vim
   " Django-specific configuration

   " Mappings
   nnoremap <leader>dr :!python manage.py runserver<CR>
   nnoremap <leader>dm :!python manage.py migrate<CR>
   ```

3. Include in `init.vim`:
   ```vim
   runtime! frameworks/django.vim
   ```

### Adding Custom Utilities

1. Create file in `utils/`:

   ```bash
   touch ~/.config/vim/utils/custom.vim
   ```

2. Add custom configuration:

   ```vim
   " utils/custom.vim
   " Personal customizations

   " Your custom settings here
   ```

3. Include in `init.vim`:
   ```vim
   runtime! utils/custom.vim
   ```

## 🎯 Best Practices

### Organization

- Keep related settings together
- Use comments to document sections
- Group similar configurations
- Maintain consistent naming

### Performance

- Use `autocmd` with `FileType` for language-specific settings
- Lazy load plugins when possible
- Avoid duplicate mappings
- Keep init.vim clean and modular

### Maintenance

- Document custom changes
- Regular backups before major changes
- Test changes in separate branch
- Use version control

## 🔍 Finding Configuration

### Locate Specific Setting

```vim
" Find where option is set
:verbose set option?

" Find mapping
:verbose map <leader>key

" Find plugin location
:echo g:plugs['plugin-name'].dir
```

### Browse Configuration

```bash
# List all config files
ls -R ~/.config/vim/

# Search for specific setting
grep -r "setting" ~/.config/vim/

# View specific file
vim ~/.config/vim/core/settings.vim
```

---

[← Back to Main README](../README.md) | [Customization Guide →](customization.md)
