# Installation Guide

Complete installation instructions for Vim Configuration.

## 📦 Automated Installation (Recommended)

The easiest way to install is using our installation script:

```bash
# Using curl
curl -fsSL https://raw.githubusercontent.com/aidomx/vimconfig/main/install.sh | bash

# Or using wget
wget -qO- https://raw.githubusercontent.com/aidomx/vimconfig/main/install.sh | bash
```

The script will automatically:

1. Check and install prerequisites
2. Clone the repository
3. Set up configuration files
4. Install vim-plug
5. Install all plugins
6. Set up vcfg tool

## ⚙️ Manual Installation

If you prefer to install manually, follow these steps:

### 1. Install Prerequisites

First, ensure you have the required packages installed. See [Prerequisites Guide](prerequisites.md) for detailed instructions.

### 2. Clone Repository

```bash
git clone https://github.com/aidomx/vimconfig.git ~/.config/vim
```

### 3. Create or Edit ~/.vimrc

Add these lines to your `~/.vimrc`:

```vim
if filereadable(expand('~/.config/vim/init.vim'))
    source ~/.config/vim/init.vim
endif
```

Or create a symlink:

```bash
ln -sf ~/.config/vim/init.vim ~/.vimrc
```

### 4. Install Vim-Plug

Install vim-plug plugin manager:

```bash
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
```

### 5. Install Plugins

Open Vim and run:

```vim
:PlugInstall
```

Wait for all plugins to download and install.

### 6. Install Coc Extensions (Optional but Recommended)

Install language server extensions:

```vim
" Web Development
:CocInstall coc-tsserver coc-json coc-html coc-css coc-prettier
:CocInstall coc-eslint coc-stylelintplus

" Backend Development
:CocInstall coc-pyright coc-clangd coc-go coc-phpls

" Utilities
:CocInstall coc-snippets coc-git coc-lists
```

### 7. Install vcfg Tool (Optional)

The vcfg tool provides easy configuration management:

```bash
# Copy vcfg to your PATH
sudo cp ~/.config/vim/vcfg.sh /usr/sbin/vcfg
sudo chmod +x /usr/sbin/vcfg
```

## 🔄 Updating

### Update All Plugins

Using vcfg:

```bash
vcfg update
```

Or manually in Vim:

```vim
:PlugUpdate
```

### Update Configuration

Using vcfg:

```bash
vcfg system-update
```

Or manually:

```bash
cd ~/.config/vim
git pull origin main
```

## 🗑️ Uninstallation

To completely remove the configuration:

```bash
# Remove configuration directory
rm -rf ~/.config/vim

# Remove vim-plug
rm -rf ~/.vim/autoload/plug.vim
rm -rf ~/.vim/plugged

# Remove vcfg tool (if installed)
sudo rm /usr.config/bin/vcfg

# Remove or edit ~/.vimrc
# Comment out or remove the lines that source the configuration
```

## 🐛 Installation Troubleshooting

### Permission Denied

If you get permission errors:

```bash
# Make sure you have write permissions
chmod -R u+w ~/.config/vim
chmod -R u+w ~/.vim
```

### Plugin Installation Fails

1. Check your internet connection
2. Try updating vim-plug:
   ```bash
   curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
   ```
3. Run `:PlugInstall` again

### Git Not Found

Install git first:

```bash
# Termux
pkg install git

# Arch Linux
sudo pacman -S git

# Ubuntu/Debian
sudo apt install git
```

### Node.js Not Found

Some features require Node.js:

```bash
# Termux
pkg install nodejs

# Arch Linux
sudo pacman -S nodejs npm

# Ubuntu/Debian
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt-get install -y nodejs
```

## 📱 Platform-Specific Installation

### Termux (Android)

```bash
# Update packages
pkg update && pkg upgrade

# Install prerequisites
pkg install vim-python nodejs git curl

# Run installation script
curl -fsSL https://raw.githubusercontent.com/aidomx/vimconfig/main/install.sh | bash
```

### Arch Linux (proot-distro)

```bash
# Update system
sudo pacman -Syu

# Install prerequisites
sudo pacman -S vim neovim nodejs npm git curl base-devel

# Run installation script
curl -fsSL https://raw.githubusercontent.com/aidomx/vimconfig/main/install.sh | bash
```

### Ubuntu/Debian

```bash
# Update system
sudo apt update && sudo apt upgrade

# Install prerequisites
sudo apt install vim neovim nodejs npm git curl build-essential

# Run installation script
curl -fsSL https://raw.githubusercontent.com/aidomx/vimconfig/main/install.sh | bash
```

## ✅ Verify Installation

After installation, verify everything is working:

```bash
# Check vcfg
vcfg version

# Check health
vcfg doctor

# Open Vim and check plugins
vim
:PlugStatus
:CocInfo
```

## 🔜 Next Steps

After successful installation:

1. Read the [Quick Start Guide](quick-start.md)
2. Learn [Key Mappings](keymappings.md)
3. Explore [Language-Specific Guides](languages/)
4. Customize your setup following [Customization Guide](customization.md)

---

[← Back to Main README](../README.md)
