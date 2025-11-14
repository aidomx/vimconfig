# Vim Configuration for Full-Stack Development

A comprehensive, modular Vim configuration optimized for full-stack web development, C/C++, Python, Go, and mobile development on Termux/HP devices. Comes with **vcfg** - a powerful configuration management tool.

![Vim IDE](https://img.shields.io/badge/Vim-IDE--like-brightgreen)
![Modular](https://img.shields.io/badge/Structure-Modular-blue)
![Termux](https://img.shields.io/badge/Optimized-Termux%2FHP-success)
![vcfg](https://img.shields.io/badge/Tools-vcfg-orange)

## 🚀 Features

- **Modular Structure**: Organized configuration for different languages and frameworks
- **IDE-like Features**: LSP support, autocompletion, debugging, formatting
- **Mobile Optimized**: Termux-friendly key mappings and touch screen support
- **Full-Stack Ready**: Support for Laravel, Next.js, React, Node.js, and more
- **Performance**: Lightweight yet powerful configuration
- **vcfg Tool**: Powerful command-line tool for managing plugins and configuration

## 📦 Quick Start

### Automated Installation (Recommended)

```bash
# Using curl
curl -fsSL https://raw.githubusercontent.com/aidomx/vimconfig/main/install.sh | bash
```

### Or using wget

```bash
wget -qO- https://raw.githubusercontent.com/aidomx/vimconfig/main/install.sh | bash
```

That's it! The installation script will:

- Install all necessary dependencies
- Set up the configuration
- Install vim-plug and all plugins
- Configure vcfg tool

### Manual Installation

See [Installation Guide](docs/installation.md) for detailed manual installation steps.

## 📚 Documentation

### Getting Started

- [Installation Guide](docs/installation.md) - Detailed installation instructions
- [Quick Start Guide](docs/quick-start.md) - Get started with specific languages
- [Prerequisites](docs/prerequisites.md) - Required packages and dependencies

### Configuration

- [Key Mappings](docs/keymappings.md) - Complete keyboard shortcuts reference
- [vcfg Tool](docs/vcfg.md) - Configuration management tool documentation
- [Project Structure](docs/structure.md) - Understanding the configuration layout
- [Customization](docs/customization.md) - How to customize your setup

### Language Support

- [Web Development](docs/languages/web.md) - JavaScript, TypeScript, HTML, CSS
- [C/C++ Development](docs/languages/c-cpp.md) - C and C++ configuration
- [Python Development](docs/languages/python.md) - Python setup
- [Go Development](docs/languages/go.md) - Go configuration
- [PHP/Laravel](docs/languages/php-laravel.md) - PHP and Laravel setup

### Advanced

- [Plugin List](docs/plugins.md) - All included plugins and their purpose
- [Troubleshooting](docs/troubleshooting.md) - Common issues and solutions
- [Termux Optimization](docs/termux.md) - Mobile-specific configuration
- [Performance](docs/performance.md) - Optimization tips

## 🎯 Key Features Overview

### vcfg - Configuration Management Tool

The included `vcfg` tool makes managing your Vim configuration incredibly easy:

```bash
vcfg install        # First-time installation
vcfg update         # Update all plugins
vcfg add <plugin>   # Add new plugin
vcfg disable <name> # Disable plugin
vcfg doctor         # Health check
```

[📖 Full vcfg Documentation](docs/vcfg.md)

### Language Support

| Language              | LSP | Formatting | Debugging | Special Features     |
| --------------------- | --- | ---------- | --------- | -------------------- |
| JavaScript/TypeScript | ✅  | ✅         | ✅        | React, Vue, Next.js  |
| C/C++                 | ✅  | ✅         | ✅        | Modern C++ syntax    |
| Python                | ✅  | ✅         | ✅        | Virtual env support  |
| Go                    | ✅  | ✅         | ✅        | Go modules           |
| PHP                   | ✅  | ✅         | ✅        | Laravel Blade        |
| Bash                  | ✅  | ✅         | ❌        | Shell script support |

### IDE-like Features

- 🔍 **Fuzzy Finding** - Fast file and text search with fzf
- 📁 **File Explorer** - NERDTree with syntax highlighting
- 🔧 **LSP Support** - Full language server protocol via coc.nvim
- 🤖 **AI Completion** - GitHub Copilot integration
- 🎨 **Themes** - Gruvbox and Seoul256 themes
- ⚡ **Fast** - Optimized for performance even on mobile

## 🎯 Quick Examples

### Web Development

```bash
# Open a React project
vim src/App.tsx

# Use <leader>nd to start Next.js dev server
# Use <leader>fmt to format with Prettier
```

### C/C++ Development

```bash
# Open a C++ file
vim main.cpp

# Use <leader>cpp to compile
# Use <leader>cpr to run
```

### PHP/Laravel

```bash
# Open a Blade template
vim resources/views/welcome.blade.php

# Use <leader>la for Artisan commands
# Use <leader>ls to start Laravel server
```

[📖 See all keyboard shortcuts](docs/keymappings.md)

## 🤝 Contributing

Contributions are welcome! Please read our [Contributing Guide](CONTRIBUTING.md) for details on our code of conduct and the process for submitting pull requests.

## 📝 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🙏 Acknowledgments

- [vim-plug](https://github.com/junegunn/vim-plug) - Plugin manager
- [coc.nvim](https://github.com/neoclide/coc.nvim) - Language server protocol
- [NERDTree](https://github.com/preservim/nerdtree) - File explorer
- [fzf.vim](https://github.com/junegunn/fzf.vim) - Fuzzy finder
- All plugin maintainers and contributors

## 📞 Support

- 📖 [Documentation](docs/)
- 🐛 [Issue Tracker](https://github.com/aidomx/vimconfig/issues)
- 💬 [Discussions](https://github.com/aidomx/vimconfig/discussions)

---

**Happy Coding!** 🚀
