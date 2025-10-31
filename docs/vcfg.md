# vcfg - Configuration Management Tool

vcfg is a powerful command-line tool for managing your Vim configuration, plugins, and key mappings.

> **Note:** Certain commands are currently under development and may not be functional.

## 📚 Table of Contents

- [Installation](#installation)
- [Command Reference](#command-reference)
- [Usage Examples](#usage-examples)
- [Plugin Management](#plugin-management)
- [Key Mapping Management](#key-mapping-management)
- [System Maintenance](#system-maintenance)

## 🚀 Installation

vcfg is automatically installed with the main configuration. To install manually:

```bash
# Copy to system PATH
sudo cp ~/.config/vim/vcfg.sh /usr/sbin/vcfg
sudo chmod +x /usr/sbin/vcfg
```

## 📖 Command Reference

### Installation & System Management

| Command              | Description                      |
| -------------------- | -------------------------------- |
| `vcfg install`       | First-time installation via vcfg |
| `vcfg update`        | Update all plugins               |
| `vcfg system-update` | Update configuration system      |
| `vcfg reinstall`     | Complete fresh reinstall         |
| `vcfg doctor`        | System health check              |
| `vcfg version`       | Show version information         |
| `vcfg help`          | Show help                        |

### Plugin Management

| Command                     | Description                |
| --------------------------- | -------------------------- |
| `vcfg add <plugin>`         | Add new plugin             |
| `vcfg remove <plugin>`      | Remove plugin completely   |
| `vcfg enable <plugin>`      | Enable disabled plugin     |
| `vcfg disable <plugin>`     | Disable plugin             |
| `vcfg disable slow_plugins` | Disable known slow plugins |
| `vcfg list`                 | List all installed plugins |
| `vcfg clean`                | Remove unused plugins      |

### Plugin Discovery

| Command               | Description              |
| --------------------- | ------------------------ |
| `vcfg search <query>` | Search plugins on GitHub |
| `vcfg info <plugin>`  | Show plugin information  |

### Key Mapping Management

| Command                        | Description                |
| ------------------------------ | -------------------------- |
| `vcfg editmap`                 | Interactive mapping editor |
| `vcfg editmap add <key> <cmd>` | Add new mapping            |
| `vcfg editmap list`            | List all mappings          |

## 💡 Usage Examples

### Plugin Management

#### Adding Plugins

```bash
# Add a plugin from GitHub
vcfg add tpope/vim-fugitive
vcfg add preservim/nerdtree

# Add multiple plugins
vcfg add tpope/vim-surround tpope/vim-repeat
```

#### Removing Plugins

```bash
# Remove a single plugin
vcfg remove coc.nvim

# Remove multiple plugins
vcfg remove vim-airline vim-airline-themes
```

#### Enabling/Disabling Plugins

```bash
# Disable a plugin temporarily
vcfg disable copilot.vim

# Enable it back
vcfg enable copilot.vim

# Disable all slow plugins
vcfg disable slow_plugins
```

#### Listing Plugins

```bash
# List all installed plugins
vcfg list

# List with status (enabled/disabled) (not ready)
vcfg list --status
```

### Plugin Discovery

#### Searching for Plugins

```bash
# Search for fuzzy finder plugins
vcfg search fuzzy finder

# Search for syntax highlighting
vcfg search "syntax highlight"

# Search for specific language support
vcfg search typescript
```

#### Getting Plugin Information

```bash
# Get detailed information about a plugin
vcfg info nerdtree
vcfg info coc.nvim

# Shows: description, stars, last update, homepage
```

### System Maintenance

#### Update Everything

```bash
# Update all plugins
vcfg update

# Update configuration system
vcfg system-update

# Update both
vcfg update && vcfg system-update
```

#### Health Check

```bash
# Run comprehensive health check
vcfg doctor

# Checks:
# - Vim/Neovim installation
# - Required packages
# - Plugin status
# - Configuration integrity
# - Language servers
```

#### Clean Up

```bash
# Remove unused plugins
vcfg clean

# This will:
# - Remove plugins not in configuration
# - Clean plugin cache
# - Remove orphaned files
```

#### Complete Reinstall

```bash
# Fresh reinstall of everything
vcfg reinstall

# Warning: This will:
# - Backup current configuration
# - Remove all plugins
# - Reinstall from scratch
# - Restore custom settings
```

### Key Mapping Management

#### Interactive Mapping Editor

```bash
# Open interactive editor
vcfg editmap

# Features:
# - Browse all mappings
# - Add/edit/delete mappings
# - Test mappings
# - Export/import mappings
```

#### Add Mappings

```bash
# Add a single mapping
vcfg editmap add '<leader>ff' ':Files<CR>'

# Add with description
vcfg editmap add '<leader>gg' ':GFiles<CR>' 'Search git files'

# Add mapping to specific file
vcfg editmap add '<leader>py' ':!python %<CR>' --file langs/python.vim
```

#### List Mappings

```bash
# List all mappings
vcfg editmap list

# List mappings for specific mode
vcfg editmap list --mode normal
vcfg editmap list --mode insert

# List mappings with filter
vcfg editmap list --filter leader
```

## 🔧 Advanced Usage

### Configuration Files

vcfg manages these configuration files:

```
~/.config/vim/
├── core/
│   ├── plugins.vim      # Plugin declarations
│   └── mappings.vim     # Key mappings
├── langs/               # Language-specific configs
└── utils/               # Utility configs
```

### Custom Plugin Sources (not ready)

```bash
# Add plugin from custom source
vcfg add https://github.com/username/custom-plugin.git

# Add local plugin
vcfg add ~/projects/my-vim-plugin --local
```

### Backup and Restore (not ready)

```bash
# Backup current configuration
vcfg backup --output ~/vim-backup.tar.gz

# Restore from backup
vcfg restore ~/vim-backup.tar.gz

# List available backups
vcfg backup list
```

### Plugin Profiles (not ready)

```bash
# Create plugin profile
vcfg profile create minimal --plugins "nerdtree,fzf"

# Switch to profile
vcfg profile switch minimal

# List profiles
vcfg profile list
```

## 🐛 Troubleshooting

### Common Issues

#### vcfg command not found

```bash
# Add to PATH
echo 'export PATH="$HOME/.config/vim:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

#### Permission denied

```bash
# Fix permissions
chmod +x ~/.config/vim/vcfg.sh
```

#### Plugin installation fails

```bash
# Check network
vcfg doctor

# Retry installation
vcfg update --force
```

### Debug Mode

```bash
# Run with debug output
vcfg --debug update

# Verbose mode
vcfg -v doctor
```

## 📊 Status Codes

vcfg uses standard exit codes:

- `0` - Success
- `1` - General error
- `2` - Invalid arguments
- `3` - Plugin not found
- `4` - Network error
- `5` - Permission denied

## 🔌 Plugin Manager Support

vcfg supports multiple plugin managers:

### vim-plug (Default)

```bash
# Automatically detected and used
vcfg add tpope/vim-fugitive
```

### packer.nvim (Neovim)

```bash
# Use with packer
vcfg --manager packer add tpope/vim-fugitive
```

### lazy.nvim (Neovim)

```bash
# Use with lazy
vcfg --manager lazy add tpope/vim-fugitive
```

## 🎯 Best Practices

1. **Regular Updates**: Run `vcfg update` weekly
2. **Health Checks**: Run `vcfg doctor` after major changes
3. **Clean Up**: Run `vcfg clean` monthly
4. **Backups**: Create backups before major changes
5. **Test New Plugins**: Disable slow plugins if needed

## 📝 Configuration

vcfg can be configured via `~/.config/vim/config.yaml`:

```yaml
# Default plugin manager
plugin_manager: vim-plug

# Auto-update plugins
auto_update: true

# Check frequency (days)
check_frequency: 7

# Backup location
backup_dir: ~/.local/share/vcfg/backups

# Enable debug mode
debug: false
```

## 🔜 Future Features

Planned features for vcfg:

- [ ] Plugin dependency management
- [ ] Automatic performance profiling
- [ ] Cloud backup integration
- [ ] Plugin recommendations
- [ ] Configuration synchronization
- [ ] Web interface

---

[← Back to Main README](../README.md)
