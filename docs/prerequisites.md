# Prerequisites

Required packages and dependencies for the Vim configuration.

## 📋 Core Requirements

### Essential Packages

All platforms need these core packages:

- **Vim** (8.2+) or **Neovim** (0.7+)
- **Git** - Version control
- **Node.js** (14+) and **npm** - Required for Coc.nvim
- **Python 3** - Required for some plugins
- **curl** or **wget** - For downloading

## 🖥️ Platform-Specific Installation

### Termux (Android)

```bash
# Update package list
pkg update && pkg upgrade

# Install core packages
pkg install vim-python nodejs git curl

# Optional but recommended
pkg install make clang python
```

### Arch Linux / proot-distro

```bash
# Update system
sudo pacman -Syu

# Install core packages
sudo pacman -S vim neovim nodejs npm git curl base-devel

# Optional but recommended
sudo pacman -S python python-pip
```

### Ubuntu / Debian

```bash
# Update system
sudo apt update && sudo apt upgrade

# Install core packages
sudo apt install vim neovim nodejs npm git curl build-essential

# Install Python support
sudo apt install python3 python3-pip python3-venv

# Install Node.js (latest LTS)
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### Fedora / RHEL / CentOS

```bash
# Update system
sudo dnf update

# Install core packages
sudo dnf install vim neovim nodejs npm git curl

# Development tools
sudo dnf groupinstall "Development Tools"

# Python
sudo dnf install python3 python3-pip
```

### macOS

```bash
# Install Homebrew (if not installed)
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install packages
brew install vim neovim node git

# Python (usually pre-installed)
brew install python3
```

## 🛠️ Language-Specific Tools

### Web Development

#### Node.js Packages

```bash
# Global packages
npm install -g typescript prettier eslint

# Optional but useful
npm install -g @vue/cli create-react-app
npm install -g serve http-server
```

#### TypeScript

```bash
npm install -g typescript ts-node
```

### C/C++ Development

#### Termux

```bash
pkg install clang gdb cmake make
```

#### Arch Linux

```bash
sudo pacman -S clang gcc gdb cmake make
```

#### Ubuntu/Debian

```bash
sudo apt install clang gcc gdb cmake build-essential
```

#### Formatters

```bash
# Arch
sudo pacman -S clang-format

# Ubuntu/Debian
sudo apt install clang-format

# Termux
pkg install clang
```

### Python Development

#### Python Tools

```bash
# Install pip (if not installed)
python3 -m ensurepip --upgrade

# Install formatters and linters
pip3 install black flake8 autopep8 pylint

# Optional: virtual environment
pip3 install virtualenv
```

#### Termux

```bash
pkg install python python-pip
pip install black flake8 autopep8
```

#### Arch Linux

```bash
sudo pacman -S python-black python-flake8 python-autopep8 python-pylint
```

#### Ubuntu/Debian

```bash
pip3 install --user black flake8 autopep8 pylint
```

### Go Development

#### Install Go

**Termux:**

```bash
pkg install golang
```

**Arch Linux:**

```bash
sudo pacman -S go
```

**Ubuntu/Debian:**

```bash
# Download latest version
wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
sudo tar -C /usr/local -xzf go1.21.0.linux-amd64.tar.gz

# Add to PATH in ~/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc
```

**macOS:**

```bash
brew install go
```

#### Go Tools

```bash
# Install Go tools
go install golang.org/x/tools/gopls@latest
go install github.com/go-delve/delve/cmd/dlv@latest
go install honnef.co/go/tools/cmd/staticcheck@latest
```

### PHP/Laravel Development

#### Install PHP

**Termux:**

```bash
pkg install php composer
```

**Arch Linux:**

```bash
sudo pacman -S php composer
```

**Ubuntu/Debian:**

```bash
sudo apt install php php-cli php-mbstring php-xml composer
```

**macOS:**

```bash
brew install php composer
```

#### PHP Tools

```bash
# Install PHP Actor (LSP)
composer global require phpactor/phpactor

# Install PHP CS Fixer
composer global require friendsofphp/php-cs-fixer

# Install PHPStan
composer global require phpstan/phpstan

# Add to PATH
echo 'export PATH="$HOME/.config/composer/vendor/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Bash/Shell Development

#### Shell Formatters & Linters

**Termux:**

```bash
pkg install shfmt shellcheck
```

**Arch Linux:**

```bash
sudo pacman -S shfmt shellcheck
```

**Ubuntu/Debian:**

```bash
sudo apt install shfmt shellcheck
```

**macOS:**

```bash
brew install shfmt shellcheck
```

## 🔧 Code Formatters & Linters

### Universal Formatters

| Tool         | Language       | Install Command                                     |
| ------------ | -------------- | --------------------------------------------------- |
| Prettier     | JS/TS/HTML/CSS | `npm install -g prettier`                           |
| Black        | Python         | `pip install black`                                 |
| clang-format | C/C++          | `pkg install clang` or `sudo pacman -S clang`       |
| gofmt        | Go             | Included with Go                                    |
| shfmt        | Bash           | `pkg install shfmt`                                 |
| PHP CS Fixer | PHP            | `composer global require friendsofphp/php-cs-fixer` |

### Linters

| Tool          | Language   | Install Command                                                         |
| ------------- | ---------- | ----------------------------------------------------------------------- |
| ESLint        | JavaScript | `npm install -g eslint`                                                 |
| flake8        | Python     | `pip install flake8`                                                    |
| shellcheck    | Bash       | `pkg install shellcheck`                                                |
| golangci-lint | Go         | `go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest` |
| PHPStan       | PHP        | `composer global require phpstan/phpstan`                               |

## 🎨 Fonts (Optional but Recommended)

For better visual experience, install a Nerd Font:

### Termux

```bash
# Install Termux:Styling from F-Droid
# Choose a font with icons support
```

### Desktop Linux/macOS

```bash
# Download Nerd Fonts
git clone --depth 1 https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts

# Install specific font (e.g., FiraCode)
./install.sh FiraCode

# Or install all fonts (takes time)
./install.sh
```

Recommended fonts:

- FiraCode Nerd Font
- JetBrains Mono Nerd Font
- Hack Nerd Font

## 🔍 Language Servers (LSP)

Language servers are automatically managed by Coc.nvim, but you can install them manually:

### Install via Coc

```vim
" In Vim, run:
:CocInstall coc-tsserver coc-json coc-html coc-css
:CocInstall coc-pyright coc-clangd coc-go coc-phpls
```

### Manual Installation

#### clangd (C/C++)

```bash
# Arch
sudo pacman -S clang

# Ubuntu
sudo apt install clangd

# Termux
pkg install clang
```

#### pyright (Python)

```bash
npm install -g pyright
```

#### gopls (Go)

```bash
go install golang.org/x/tools/gopls@latest
```

## ✅ Verification

After installing prerequisites, verify everything is working:

```bash
# Check Vim
vim --version

# Check Node.js
node --version
npm --version

# Check Python
python3 --version
pip3 --version

# Check Git
git --version

# Check formatters
prettier --version
black --version
clang-format --version
```

### Run Health Check

After installing the Vim configuration:

```bash
# Using vcfg
vcfg doctor

# Or in Vim
:checkhealth
```

## 🐛 Common Issues

### Node.js Version Too Old

```bash
# Update Node.js to LTS version
# Termux
pkg upgrade nodejs

# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
```

### Python Not Found

```bash
# Create python symlink
sudo ln -s /usr/bin/python3 /usr/bin/python
```

### Missing Build Tools

```bash
# Termux
pkg install make clang

# Arch
sudo pacman -S base-devel

# Ubuntu/Debian
sudo apt install build-essential
```

### Permission Denied

```bash
# Fix npm permissions
mkdir ~/.npm-global
npm config set prefix '~/.npm-global'
echo 'export PATH=~/.npm-global/bin:$PATH' >> ~/.bashrc
source ~/.bashrc
```

## 📦 Optional Enhancements

### Ripgrep (Better Grep)

```bash
# Termux
pkg install ripgrep

# Arch
sudo pacman -S ripgrep

# Ubuntu/Debian
sudo apt install ripgrep

# macOS
brew install ripgrep
```

### fd (Better Find)

```bash
# Termux
pkg install fd

# Arch
sudo pacman -S fd

# Ubuntu/Debian
sudo apt install fd-find

# macOS
brew install fd
```

### bat (Better Cat)

```bash
# Termux
pkg install bat

# Arch
sudo pacman -S bat

# Ubuntu/Debian
sudo apt install bat

# macOS
brew install bat
```

## 🔜 Next Steps

After installing all prerequisites:

1. Proceed to [Installation Guide](installation.md)
2. Or use quick install: `curl -fsSL https://raw.githubusercontent.com/aidomx/vimconfig/main/install.sh | bash`

---

[← Back to Main README](../README.md) | [Installation Guide →](installation.md)
