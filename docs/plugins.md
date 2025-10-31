# Plugin Reference

Complete list of all included plugins and their purposes.

## 📚 Table of Contents

- [UI & Themes](#-ui--themes)
- [Completion & LSP](#-completion--lsp)
- [Navigation & Search](#-navigation--search)
- [Language Support](#-language-support)
- [Git Integration](#-git-integration)
- [Code Editing](#-code-editing)
- [Formatting & Linting](#-formatting--linting)
- [Utilities](#-utilities)
- [Optional Plugins](#-optional-plugins)

## 🎨 UI & Themes

### morhetz/gruvbox

**Purpose:** Color scheme with warm, retro groove colors

**Features:**

- Dark and light variants
- High contrast options
- Excellent readability

**Configuration:**

```vim
colorscheme gruvbox
set background=dark
let g:gruvbox_contrast_dark = 'hard'
let g:gruvbox_italic = 1
```

**Commands:**

- `:colorscheme gruvbox` - Activate theme

---

### junegunn/seoul256.vim

**Purpose:** Alternative low-contrast color scheme

**Features:**

- Eye-friendly colors
- 256 color support
- Dark and light variants

**Configuration:**

```vim
let g:seoul256_background = 233
colorscheme seoul256
```

---

### vim-airline/vim-airline

**Purpose:** Lean & mean status/tabline

**Features:**

- Beautiful status line
- Git integration
- Buffer/tab line
- Mode indicators

**Configuration:**

```vim
let g:airline_theme = 'gruvbox'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
```

**Shortcuts:**

- Displays current mode, file, position automatically

---

### vim-airline/vim-airline-themes

**Purpose:** Themes for vim-airline

**Features:**

- Multiple theme options
- Matches color schemes
- Customizable sections

## 🔧 Completion & LSP

### neoclide/coc.nvim

**Purpose:** Intellisense engine, full language server protocol support

**Features:**

- Autocompletion
- Go to definition
- Find references
- Rename refactoring
- Code actions
- Diagnostics
- Snippets

**Installation:**

```vim
:CocInstall coc-tsserver coc-json coc-html coc-css coc-prettier
:CocInstall coc-pyright coc-clangd coc-go coc-phpls
```

**Shortcuts:**

- `gd` - Go to definition
- `gy` - Go to type definition
- `gi` - Go to implementation
- `gr` - Find references
- `K` - Show documentation
- `<leader>rn` - Rename
- `<leader>ca` - Code action

**Commands:**

- `:CocList` - List available lists
- `:CocConfig` - Edit configuration
- `:CocInfo` - Show debug info
- `:CocRestart` - Restart Coc

---

### github/copilot.vim

**Purpose:** AI-powered code completion

**Features:**

- AI suggestions
- Context-aware completions
- Multi-language support
- Learn from your codebase

**Setup:**

```vim
:Copilot setup
:Copilot auth
```

**Shortcuts:**

- `<C-J>` - Accept suggestion
- `<C-K>` - Dismiss suggestion
- `<leader>cp` - Open panel
- `<C-]>` - Next suggestion
- `<C-[>` - Previous suggestion

**Commands:**

- `:Copilot enable` - Enable Copilot
- `:Copilot disable` - Disable Copilot
- `:Copilot status` - Check status

## 🗂️ Navigation & Search

### preservim/nerdtree

**Purpose:** File system explorer

**Features:**

- Tree-style file browser
- File operations (create, delete, rename)
- Bookmark support
- Directory navigation

**Shortcuts:**

- `tt` - Toggle NERDTree
- `ff` - Find current file in tree

**In NERDTree:**

- `m` - File operations menu
- `i` - Open in horizontal split
- `s` - Open in vertical split
- `t` - Open in new tab
- `I` - Toggle hidden files
- `C` - Change root to selected
- `u` - Go up directory
- `r` - Refresh directory
- `R` - Refresh root

**Commands:**

- `:NERDTree` - Open NERDTree
- `:NERDTreeToggle` - Toggle NERDTree
- `:NERDTreeFind` - Find current file

---

### tiagofumo/vim-nerdtree-syntax-highlight

**Purpose:** Syntax highlighting for NERDTree

**Features:**

- File type icons colors
- Folder highlighting
- Git status colors

---

### junegunn/fzf

**Purpose:** Fuzzy finder (binary)

**Features:**

- Fast fuzzy searching
- Integration with multiple sources
- Preview support

---

### junegunn/fzf.vim

**Purpose:** Vim integration for fzf

**Shortcuts:**

- `pp` - Files (fuzzy find files)
- `bb` - Buffers (list open buffers)
- `gg` - Rg (live grep)
- `<leader>pf` - GFiles (git files)

**Commands:**

- `:Files [path]` - Find files
- `:GFiles` - Git files
- `:Buffers` - Open buffers
- `:Rg [pattern]` - Search with ripgrep
- `:Lines` - Search lines in buffers
- `:BLines` - Search lines in current buffer
- `:Tags` - Search tags
- `:Marks` - List marks
- `:History` - Command history
- `:Commits` - Git commits

## 💻 Language Support

### pangloss/vim-javascript

**Purpose:** JavaScript syntax and indentation

**Features:**

- Enhanced JavaScript syntax
- ES6+ support
- JSX basic support

---

### leafgarland/typescript-vim

**Purpose:** TypeScript syntax

**Features:**

- TypeScript syntax highlighting
- TSX support
- Indent support

---

### maxmellon/vim-jsx-pretty

**Purpose:** JSX and TSX syntax

**Features:**

- Better JSX highlighting
- React component support
- Attribute highlighting

---

### othree/html5.vim

**Purpose:** HTML5 syntax and omnicomplete

**Features:**

- HTML5 elements
- Attributes
- Events
- ARIA support

---

### hail2u/vim-css3-syntax

**Purpose:** CSS3 syntax

**Features:**

- CSS3 properties
- Vendor prefixes
- Modern selectors

---

### bfrg/vim-cpp-modern

**Purpose:** Modern C++ syntax

**Features:**

- C++11/14/17/20 support
- STL highlighting
- Template syntax

---

### fatih/vim-go

**Purpose:** Go development

**Features:**

- Go syntax
- Go commands integration
- Formatting
- Testing support

**Commands:**

- `:GoBuild` - Build project
- `:GoRun` - Run project
- `:GoTest` - Run tests
- `:GoFmt` - Format code

**Shortcuts:**

- `<leader>gb` - Go build
- `<leader>gr` - Go run
- `<leader>gt` - Go test

---

### phpactor/phpactor

**Purpose:** PHP language server

**Features:**

- PHP completion
- Refactoring
- Go to definition
- Find references

---

### jwalton512/vim-blade

**Purpose:** Laravel Blade template syntax

**Features:**

- Blade directives
- Component syntax
- Template highlighting

---

### StanAngeloff/php.vim

**Purpose:** Enhanced PHP syntax

**Features:**

- Modern PHP syntax
- Namespaces
- Traits support

## 🔀 Git Integration

### airblade/vim-gitgutter

**Purpose:** Show git diff in the sign column

**Features:**

- Line-by-line git status
- Stage/undo hunks
- Preview changes
- Jump between hunks

**Shortcuts:**

- `]c` - Next hunk
- `[c` - Previous hunk
- `<leader>hs` - Stage hunk
- `<leader>hu` - Undo hunk
- `<leader>hp` - Preview hunk

**Commands:**

- `:GitGutterToggle` - Toggle git gutter
- `:GitGutterSignsToggle` - Toggle signs
- `:GitGutterLineHighlightsToggle` - Toggle line highlights

---

### tpope/vim-fugitive

**Purpose:** Git wrapper

**Features:**

- Git commands in Vim
- Commit interface
- Diff viewing
- Merge conflict resolution
- Git blame

**Shortcuts:**

- `<leader>gs` - Git status
- `<leader>gc` - Git commit
- `<leader>gp` - Git push
- `<leader>gd` - Git diff

**Commands:**

- `:Git` or `:G` - Run git commands
- `:Git status` - Show status
- `:Git commit` - Commit changes
- `:Git push` - Push to remote
- `:Git pull` - Pull from remote
- `:Git blame` - Show blame
- `:Gdiffsplit` - Split diff view

## ✏️ Code Editing

### tpope/vim-surround

**Purpose:** Manipulate surrounding characters

**Features:**

- Change surroundings
- Delete surroundings
- Add surroundings

**Usage:**

- `ds"` - Delete surrounding quotes
- `cs"'` - Change " to '
- `ysiw"` - Surround word with "
- `yss)` - Surround line with ()
- `S"` - Surround selection (visual mode)

**Examples:**

```
"Hello world!" → ds" → Hello world!
'Hello' → cs'" → "Hello"
Hello → ysiw] → [Hello]
```

---

### jiangmiao/auto-pairs

**Purpose:** Auto close brackets, quotes, etc.

**Features:**

- Auto-close pairs
- Smart deletion
- Fast wrap
- Multi-line support

**Auto-closes:**

- `()` `[]` `{}`
- `""` `''` ` `` `
- `<>` (in HTML/XML)

**Shortcuts:**

- `<M-p>` - Toggle auto-pairs
- `<M-e>` - Fast wrap

---

### preservim/nerdcommenter

**Purpose:** Comment functions

**Features:**

- Toggle comments
- Comment blocks
- Multiple comment styles
- Multi-line comments

**Shortcuts:**

- `<leader>cc` - Comment line
- `<leader>cu` - Uncomment line
- `<leader>c` - Toggle comment
- `<leader>cs` - Sexy comment
- `<leader>cm` - Minimal comment

**Commands:**

- `:NERDCommenterToggle` - Toggle comment

## 🎯 Formatting & Linting

### sbdchd/neoformat

**Purpose:** Universal code formatter

**Features:**

- Multiple formatter support
- Auto-format on save
- Per-filetype formatters

**Supported formatters:**

- Prettier (JS/TS/HTML/CSS)
- Black (Python)
- clang-format (C/C++)
- gofmt (Go)
- rustfmt (Rust)
- shfmt (Bash)

**Shortcuts:**

- `<leader>fmt` - Format current file

**Commands:**

- `:Neoformat` - Format current file
- `:Neoformat! [formatter]` - Use specific formatter

**Configuration:**

```vim
" Enable format on save
let g:neoformat_enabled_python = ['black']
let g:neoformat_enabled_javascript = ['prettier']
```

---

### junegunn/vim-easy-align

**Purpose:** Text alignment

**Features:**

- Align by delimiter
- Visual alignment
- Multiple delimiters

**Shortcuts:**

- `ga` - Start alignment (visual mode)
- `gaip=` - Align paragraph by =

**Usage:**

```vim
" Select text, then:
ga=    " Align by =
ga:    " Align by :
ga<Space>  " Align by space
```

## 🛠️ Utilities

### tpope/vim-repeat

**Purpose:** Repeat plugin commands with `.`

**Features:**

- Extend `.` command
- Support for plugin mappings

---

### tpope/vim-sleuth

**Purpose:** Auto-detect indent settings

**Features:**

- Detect tabs vs spaces
- Detect indent width
- Set buffer-local settings

---

### ryanoasis/vim-devicons

**Purpose:** File type icons

**Features:**

- Icons for file types
- Folder icons
- Git status icons
- NERDTree integration

**Requirements:**

- Nerd Font installed

## 🔌 Optional Plugins

These plugins are not included by default but recommended:

### Productivity

```vim
" Distraction-free writing
Plug 'junegunn/goyo.vim'

" Focus mode
Plug 'junegunn/limelight.vim'

" TODO management
Plug 'folke/todo-comments.nvim'

" Undo tree visualizer
Plug 'mbbill/undotree'
```

### Navigation

```vim
" Multiple cursors
Plug 'mg979/vim-visual-multi'

" Easy motion
Plug 'easymotion/vim-easymotion'

" Quick jump
Plug 'phaazon/hop.nvim'

" Smooth scrolling
Plug 'karb94/neoscroll.nvim'
```

### Code Enhancement

```vim
" Rainbow brackets
Plug 'luochen1990/rainbow'

" Indent guides
Plug 'lukas-reineke/indent-blankline.nvim'

" Better quickfix
Plug 'kevinhwang91/nvim-bqf'

" Colorizer
Plug 'norcalli/nvim-colorizer.lua'
```

### Language-Specific

```vim
" Markdown preview
Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app && npm install' }

" Rust tools
Plug 'simrat39/rust-tools.nvim'

" Flutter tools
Plug 'akinsho/flutter-tools.nvim'

" Vue.js
Plug 'posva/vim-vue'

" Svelte
Plug 'evanleck/vim-svelte'
```

### Git Advanced

```vim
" Git signs (alternative to gitgutter)
Plug 'lewis6991/gitsigns.nvim'

" Git blame inline
Plug 'f-person/git-blame.nvim'

" Git messenger
Plug 'rhysd/git-messenger.vim'
```

### Testing

```vim
" Test runner
Plug 'vim-test/vim-test'

" Coverage
Plug 'ruanyl/coverage.vim'
```

## 📊 Plugin Statistics

### By Category

| Category         | Plugin Count |
| ---------------- | ------------ |
| UI & Themes      | 4            |
| Completion & LSP | 2            |
| Navigation       | 4            |
| Language Support | 10           |
| Git              | 2            |
| Code Editing     | 3            |
| Formatting       | 2            |
| Utilities        | 3            |
| **Total**        | **30**       |

### Performance Impact

| Plugin      | Startup Impact  | Memory Usage   | Category  |
| ----------- | --------------- | -------------- | --------- |
| coc.nvim    | High (~100ms)   | High (~50MB)   | Critical  |
| copilot.vim | Medium (~50ms)  | Medium (~30MB) | Optional  |
| nerdtree    | Low (~20ms)     | Low (~10MB)    | Essential |
| fzf.vim     | Very Low (~5ms) | Low (~5MB)     | Essential |
| gruvbox     | Very Low (~1ms) | Low (~2MB)     | Essential |
| vim-airline | Low (~10ms)     | Low (~5MB)     | Essential |

## 🎯 Plugin Management Commands

### Using vcfg

```bash
# List all plugins
vcfg list

# Add plugin
vcfg add tpope/vim-surround

# Remove plugin
vcfg remove copilot.vim

# Enable/disable
vcfg enable vim-airline
vcfg disable copilot.vim

# Get plugin info
vcfg info nerdtree

# Search for plugins
vcfg search fuzzy finder

# Update all
vcfg update

# Clean unused
vcfg clean
```

### Using vim-plug

```vim
" Install plugins
:PlugInstall

" Update plugins
:PlugUpdate

" Upgrade vim-plug itself
:PlugUpgrade

" Check status
:PlugStatus

" Clean unused
:PlugClean

" Review changes
:PlugDiff
```

## 🔧 Plugin Configuration

### Global Configuration

Edit `~/.local/vim/core/plugins.vim` to add/remove plugins:

```vim
call plug#begin('~/.vim/plugged')

" Add your plugins here
Plug 'your/plugin'

call plug#end()
```

### Plugin-Specific Configuration

Create `~/.local/vim/utils/plugin-config.vim`:

```vim
" NERDTree settings
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1

" FZF settings
let g:fzf_layout = { 'down': '~40%' }
let g:fzf_preview_window = 'right:50%'

" Airline settings
let g:airline_theme = 'gruvbox'
let g:airline_powerline_fonts = 1
```

## 📝 Recommended Plugin Sets

### Minimal (Fast startup < 100ms)

```vim
Plug 'junegunn/seoul256.vim'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
```

### Standard (Balanced)

```vim
Plug 'morhetz/gruvbox'
Plug 'vim-airline/vim-airline'
Plug 'preservim/nerdtree'
Plug 'junegunn/fzf.vim'
Plug 'neoclide/coc.nvim'
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'
Plug 'airblade/vim-gitgutter'
```

### Full Featured (All bells and whistles)

All plugins listed above in main categories.

## 🔜 Upcoming Plugins

Planned additions:

- [ ] Session management plugin
- [ ] Better snippet engine
- [ ] Database integration
- [ ] REST client
- [ ] Markdown table formatter

---

[← Back to Main README](../README.md) | [Customization →](customization.md)
