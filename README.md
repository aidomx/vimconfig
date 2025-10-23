# Vim Configuration for Full-Stack Development

A comprehensive, modular Vim configuration optimized for full-stack web development, C/C++, Python, Go, and mobile development on Termux/HP devices.

![Vim IDE](https://img.shields.io/badge/Vim-IDE--like-brightgreen)
![Modular](https://img.shields.io/badge/Structure-Modular-blue)
![Termux](https://img.shields.io/badge/Optimized-Termux%2FHP-success)

## 🚀 Features

- **Modular Structure**: Organized configuration for different languages and frameworks
- **IDE-like Features**: LSP support, autocompletion, debugging, formatting
- **Mobile Optimized**: Termux-friendly key mappings and touch screen support
- **Full-Stack Ready**: Support for Laravel, Next.js, React, Node.js, and more
- **Performance**: Lightweight yet powerful configuration

## 📋 Prerequisites

### Termux Packages

```bash
pkg update && pkg upgrade
pkg install vim-python nodejs git curl make
```

### Arch Linux (proot-distro) Packages

```bash
sudo pacman -Syu
sudo pacman -S vim neovim nodejs npm git curl base-devel
```

## Language-Specific Tools

### Core Formatters & Linters

```bash
# Arch Linux
sudo pacman -S shfmt clang prettier

# Termux
pkg install shfmt clang prettier
```

### Web Development

```bash
# Node.js packages (global)
npm install -g prettier typescript @vue/cli

# Arch Linux
sudo pacman -S typescript npm
```

### C/C++ Development

```bash
# Arch Linux
sudo pacman -S clang gcc gdb cmake

# Termux
pkg install clang gdb cmake
```

### Python Development

```bash
# Arch Linux
sudo pacman -S python-black python-flake8 python-autopep8

# Termux
pkg install python pip
pip install black flake8 autopep8
```

### Go Development

```bash
# Arch Linux
sudo pacman -S go

# Termux
pkg install golang
```

### PHP/Laravel Development

```bash
# Arch Linux
sudo pacman -S php composer

# Termux
pkg install php composer
```

### ⚙️ Installation

1. Clone Repository

```bash
git clone https://github.com/aidomx/vimconfig.git ~/.local/vim
```

2. Create Symlink

```bash
ln -sf ~/.local/vim/init.vim ~/.vimrc
```

3. Install Vim-Plug

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

4. Install Plugins

Open Vim and run:

```vim
:PlugInstall
```

5. Install Coc Extensions (Optional)

```vim
:CocInstall coc-tsserver coc-json coc-html coc-css coc-prettier
:CocInstall coc-pyright coc-clangd coc-go coc-phpls
```

### 🎯 Key Mappings

Global Leader Key

Leader is set to <Space>

**File Navigation**

Shortcut Action
tt Toggle NERDTree
ff Find file in NERDTree
pp Fuzzy filbb Buffer list
gg Live grep search

**Window Management**

Shortcut Action
<leader>s Toggle split view
<leader>m Maximize/restore split
<C-h> Move to left split
<C-j> Move to bottom split
<C-k> Move to top split
<C-l> Move to right split

**Tab Management**

Shortcut Action
<leader>to New tab
<leader>tc Close tab
<leader>tn Next tab
<leader>tp Previous tab

**Code Actions**

Shortcut Action
<leader>fmt Format current file
gd Go to definition
gy Go to type definition
gi Go to implementation
gr Find references
<leader>rn Rename symbol
K Show documentation

**Git Integration**

Shortcut Action
<leader>gs Git status (fugitive)
<leader>gc Git commit
<leader>gp Git push
<leader>gd Git diff

### Language-Specific Shortcuts

**C/C++**

Shortcut Action
<leader>cc Compile C file
<leader>cr Run C program
<leader>cpp Compile C++ file
<leader>cpr Run C++ program

**Bash/Shell**

Shortcut Action
<leader>bx Make executable and run
<leader>br Run script
<leader>bc Syntax check
<leader>bt Test syntax

**Web Development**

Shortcut Action
<leader>nd Next.js dev server
<leader>nb Next.js build
<leader>ns Next.js start
<leader>la Laravel Artisan command
<leader>ls Laravel serve
<leader>lm Laravel migrate

**Python**

Shortcut Action
<leader>py Run Python script

**Go**

Shortcut Action
<leader>gb Go build
<leader>gr Go run
<leader>gt Go test

**Completion**

Shortcut Action
<TAB> Next completion item
<C-P> Previous completion item
<CR> Confirm completion
<C-Space> Trigger completion

**Copilot**

Shortcut Action
<C-J> Accept Copilot suggestion
<C-K> Dismiss suggestion
<leader>cp Open Copilot panel

**Utility**

Shortcut Action
<leader>w Save file
<leader>q Quit
<leader>wq Save and quit
<leader>x Save and quit (alternative)
<leader><space> Clear search highlights

### 🏗️ Project Structure

```
~/.local/vim/
├── init.vim                 # Main configuration
├── core/
│   ├── settings.vim        # Basic editor settings
│   ├── mappings.vim        # Key mappings
│   └── plugins.vim         # Plugin declarations
├── langs/
│   ├── web.vim             # JavaScript/TypeScript/HTML/CSS
│   ├── c.vim               # C/C++ development
│   ├── php.vim             # PHP/Laravel
│   ├── python.vim          # Python
│   ├── go.vim              # Go
│   └── bash.vim            # Shell scripting
├── frameworks/
│   ├── laravel.vim         # Laravel-specific config
│   └── nextjs.vim          # Next.js specific config
└── utils/
    ├── termux.vim          # Termux-specific optimizations
    ├── completion.vim      # Coc completion config
    ├── formatting.vim      # Universal formatting
    └── ui.vim              # UI/theme settings
```

### 🎨 Themes & UI

The configuration includes:

· Gruvbox (default theme)
· Seoul256 (alternative theme)
· vim-airline with gruvbox theme
· NERDTree with syntax highlighting

Change theme in utils/ui.vim:

```vim
" colorscheme gruvbox
colorscheme seoul256
```

### 🔧 Customization

Adding New Language Support

1. Create file in langs/ directory
2. Add language-specific settings and mappings
3. Include in init.vim with runtime! langs/yourlang.vim

Adding New Framework

1. Create file in frameworks/ directory
2. Add framework-specific commands and mappings
3. Include in init.vim

Custom Mappings

Add personal mappings in core/mappings.vim or create utils/custom.vim

### 🔌 Plugin List

UI & Themes

· morhetz/gruvbox - Color scheme
· junegunn/seoul256.vim - Alternative color scheme
· vim-airline/vim-airline - Status line
· vim-airline/vim-airline-themes - Airline themes

Completion & LSP

· neoclide/coc.nvim - Language Server Protocol
· github/copilot.vim - AI code completion

Navigation & Tools

· junegunn/fzf - Fuzzy finder
· junegunn/fzf.vim - FZF Vim integration
· preservim/nerdtree - File explorer
· tiagofumo/vim-nerdtree-syntax-highlight - NERDTree syntax

Language Support

· pangloss/vim-javascript - JavaScript syntax
· leafgarland/typescript-vim - TypeScript syntax
· maxmellon/vim-jsx-pretty - JSX/TSX support
· othree/html5.vim - HTML5 support
· bfrg/vim-cpp-modern - Modern C++ syntax
· fatih/vim-go - Go development
· phpactor/phpactor - PHP support
· jwalton512/vim-blade - Laravel Blade templates

Git

· airblade/vim-gitgutter - Git diff in gutter
· tpope/vim-fugitive - Git integration

Utilities

· tpope/vim-surround - Surround text objects
· jiangmiao/auto-pairs - Auto close brackets
· preservim/nerdcommenter - Code commenting
· sbdchd/neoformat - Code formatting
· junegunn/vim-easy-align - Text alignment

### 🐛 Troubleshooting

Common Issues

Plugins not loading:

```vim
:PlugInstall
:source ~/.vimrc
```

Coc not working:

```vim
:CocInfo
:checkhealth
```

Formatting not working:

· Check if formatters are installed: which shfmt, which prettier
· Verify filetype: set filetype?

Performance Issues

· Disable unused plugins in core/plugins.vim
· Use :CocDisable to temporarily disable completion
· Check memory usage with :echo getpid()

Termux-Specific Issues

Keyboard mappings not working:

· Use alternative mappings with Ctrl instead of Alt
· Enable additional keyboards in Termux settings

Colors not displaying correctly:

```bash
pkg install x11-repo
pkg install xfce4-terminal
```

### 📚 Recommended Coc Extensions

```vim
" Web Development
:CocInstall coc-tsserver coc-json coc-html coc-css coc-prettier
:CocInstall coc-eslint coc-stylelintplus

" Backend Development
:CocInstall coc-pyright coc-clangd coc-go coc-phpls
:CocInstall coc-rust-analyzer coc-java

" Utilities
:CocInstall coc-snippets coc-git coc-lists
```

### 🚀 Quick Start for Specific Languages

Web Development (JavaScript/TypeScript)

1. Install Node.js and npm
2. Install global packages: npm install -g typescript prettier
3. Open .ts or .js file and enjoy full LSP support

C/C++ Development

1. Install clang and clangd
2. Create compile_commands.json in project root
3. Use <leader>cc to compile, <leader>cr to run

PHP/Laravel Development

1. Install PHP and Composer
2. Install PHP Actor: composer global require phpactor/phpactor
3. Open Blade templates with full syntax highlighting

### 🤝 Contributing

1. Fork the repository
2. Create feature branch: git checkout -b feature/amazing-feature
3. Commit changes: git commit -m 'Add amazing feature'
4. Push to branch: git push origin feature/amazing-feature
5. Open Pull Request

### 📝 License

This project is licensed under the MIT License - see the LICENSE file for details.

### 🙏 Acknowledgments

· vim-plug - Plugin manager
· coc.nvim - Language server protocol
· NERDTree - File explorer
· fzf.vim - Fuzzy finder
· All plugin maintainers and contributors
