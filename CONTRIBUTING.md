# Contributing Guide

Thank you for considering contributing to this Vim configuration project!

## 🤝 How to Contribute

### Reporting Bugs

1. Check if the bug is already reported in [Issues](https://github.com/aidomx/vimconfig/issues)
2. If not, create a new issue with:
   - Clear title and description
   - Steps to reproduce
   - Expected vs actual behavior
   - System information (`vcfg doctor` output)
   - Screenshots if applicable

### Suggesting Features

1. Check [existing feature requests](https://github.com/aidomx/vimconfig/issues?q=is%3Aissue+label%3Aenhancement)
2. Create a new issue with:
   - Clear description of the feature
   - Use case and benefits
   - Possible implementation approach

### Contributing Code

#### 1. Fork and Clone

```bash
# Fork the repository on GitHub
git clone https://github.com/YOUR_USERNAME/vimconfig.git
cd vimconfig
git remote add upstream https://github.com/aidomx/vimconfig.git
```

#### 2. Create a Branch

```bash
git checkout -b feature/your-feature-name
# or
git checkout -b fix/bug-description
```

#### 3. Make Changes

- Follow the existing code style
- Test your changes thoroughly
- Update documentation if needed
- Add comments for complex logic

#### 4. Commit Changes

```bash
git add .
git commit -m "feat: add new feature"
# or
git commit -m "fix: resolve bug in plugin loading"
```

**Commit Message Format:**

- `feat:` New feature
- `fix:` Bug fix
- `docs:` Documentation changes
- `style:` Code style changes (formatting)
- `refactor:` Code refactoring
- `test:` Adding tests
- `chore:` Maintenance tasks

#### 5. Push and Create PR

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request on GitHub with:

- Clear description of changes
- Reference related issues
- Screenshots/demos if applicable

## 📝 Code Guidelines

### File Organization

```
~/.config/vim/
├── core/           # Core configuration
├── langs/          # Language-specific configs
├── frameworks/     # Framework-specific configs
└── utils/          # Utility configurations
```

### Vim Script Style

```vim
" Use comments
" Group related settings

" Use consistent spacing
set number
set relativenumber

" Use meaningful variable names
let g:airline_theme = 'gruvbox'

" Add error handling
if exists('g:loaded_plugin')
    finish
endif
```

### Documentation

- Update relevant `.md` files
- Add comments in code
- Include examples
- Update README if needed

## 🧪 Testing

Before submitting:

```bash
# Test configuration loads
vim -u ~/.vimrc -c "quit"

# Check for errors
vim -u ~/.vimrc -c "messages"

# Run health check
vcfg doctor

# Test on clean install
rm -rf ~/.vim/plugged
vim -c "PlugInstall" -c "quit"
```

## 🎯 Areas to Contribute

### Easy Issues

- Documentation improvements
- Adding language snippets
- Updating plugin configurations
- Fixing typos

### Medium Issues

- Adding new language support
- Improving key mappings
- Performance optimizations
- Bug fixes

### Advanced Issues

- vcfg tool enhancements
- Plugin management improvements
- LSP configuration optimization
- Cross-platform compatibility

## 💡 Tips

1. **Start Small**: Begin with documentation or small fixes
2. **Ask Questions**: Open an issue for discussion before major changes
3. **Test Thoroughly**: Test on different platforms (Termux, Linux)
4. **Be Patient**: Reviews may take time
5. **Follow Up**: Respond to review comments

## 🔧 Development Setup

```bash
# Install development dependencies
pkg install vim-python nodejs git

# Install Vim configuration
git clone https://github.com/YOUR_USERNAME/vimconfig.git ~/.config/vim
# edit file .vimrc and insert:
if filereadable(expand('~/.config/vim/init.vim'))
  source ~/.config/vim/init.vim
endif

# Install plugins
vim -c "PlugInstall" -c "quit"

# Make changes and test
vim
```

## 📊 Review Process

1. **Automated Checks**: Basic validation runs automatically
2. **Code Review**: Maintainers review your code
3. **Testing**: Changes are tested on multiple platforms
4. **Merge**: Approved changes are merged

## ❓ Questions?

- Open an issue for questions
- Check existing documentation
- Join discussions

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing!
